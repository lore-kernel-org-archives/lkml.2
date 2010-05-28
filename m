Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab0E1PAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:00:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34679 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755897Ab0E1PAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:00:52 -0400
Date: Fri, 28 May 2010 16:06:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Igor Stoppa <igor.stoppa@nokia.com>,
       tytso@mit.edu, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528160628.7c121dab@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
References: <20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
	<4BFFC5DF.5030504@nokia.com>
	<20100528133900.GG26177@thunk.org>
	<4BFFCFC7.7070302@nokia.com>
	<20100528142124.GA26733@srcf.ucam.org>
	<AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the suggestion that has the closet fit with what we're trying
> to accomplish is Ingo's (or perhaps Ingo's explanation of Alan's):
> http://lkml.org/lkml/2010/5/28/106 where it's implemented as a
> constraint of some sort.

I think we ended up in the same place on our own.

> Arve points out that qos constraint objects could work (but not if
> specifically tied to apps): http://lkml.org/lkml/2010/5/28/120 though
> he suggests that "latency" constraints don't represent this as well as
> "state" constraints.

With latency you have an "I don't give damn" latency in your model which
we could describe as infinite or "manyana" perhaps.

> Though if you look at it that way, then suspend_blockers become qos
> constraint objects, but their implementation and usage remain pretty
> much the same as we have now, which does not address Alan's concern
> regarding code turning up in drivers, etc.  I'm not sure how you can
> solve this problem (avoiding races around entering/exiting the suspend
> or suspend-like state) without having a means for drivers to prevent
> entry to that state.

I am much much less concerned about general expressions of constraint
appearing in drivers. One of my early mails gave a list of other
people/projects/problems that need them - from hard real time, to high
speed serial on low end embedded to virtualisation.

They fix a general problem in terms of a driver specific item. We end up
making changes around the tree but we make everyone happy not just
Android. Also we are isolating policy properly. The apps and drivers say
"I have these needs", the power manager figures out how to meet them.

Where it gets ugly is if you start trying to have drivers giving an app a
guarantee which the app then magically has to know to dispose of.

If you are prepared to exclude untrusted apps from perfectly reliable
event reporting (ie from finger to application action) that doesn't seem
to be a neccessity anyway.
 
> livelock/deadlock/priority-inversion style issues due to interaction
> between different processes in different groups.

Priority inversion with the cgroup case is like synchronization effects
with the suspend blockers - its a real ugly problem and one that is known
to be hard to fix if you let it happen so I agree there.

