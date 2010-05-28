Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0E1TwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:52:05 -0400
Received: from ip-70-38-54-39.static.privatedns.com ([70.38.54.39]:35965 "EHLO
	ginevra.hungrycats.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753990Ab0E1TwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:52:03 -0400
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
Date: Fri, 28 May 2010 15:51:58 -0400
From: Zygo Blaxell <vger-linux-omap-esightcorp@mailtoo.hungrycats.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Swetland <swetland@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Igor Stoppa <igor.stoppa@nokia.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528195158.GA5910@gibbs.hungrycats.org>
References: <AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
 <4BFFC5DF.5030504@nokia.com>
 <20100528133900.GG26177@thunk.org>
 <4BFFCFC7.7070302@nokia.com>
 <20100528142124.GA26733@srcf.ucam.org>
 <AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
 <20100528160628.7c121dab@lxorguk.ukuu.org.uk>
 <AANLkTin3suKfGBSfiDj0n8ztY8UiHzr4af_Cr0SPOevY@mail.gmail.com>
 <20100528172713.GA7444@gibbs.hungrycats.org>
 <1275070580.1645.379.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275070580.1645.379.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 08:16:20PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-05-28 at 13:27 -0400, Zygo Blaxell wrote:
> > From my reading of this thread, there's a lot of overlap between
> > suspendblockers and constraints.  Many use cases are served equally
> > well with one or the other, 

Oops, I apparently meant "many use cases *of suspendblockers* are served
equally well with one or the other."

> If using suspend-blockers, 
> Please explain to me how:
> - I will avoid the cpu going into some idle state for which the wakeup
> latency is larger than my RT app fancies?

...though I'd think you could do that by holding a suspendblocker, thus
preventing the CPU from going into any idle state at all.

There's four likely outcomes, corresponding to inclusion or non-inclusion
of suspend blockers and PM constraints in the kernel.  Both could coexist
in the same kernel, since a suspend blocker can be trivially expressed as
"an extreme PM constraint with other non-constraint-related semantics."

It's the "other non-constraint-related semantics" that seem to be the
contentious issue.  What can a suspend blocker do that a PM resource
constraint cannot do?  If that set contains at least one useful use case,
then we need either suspend blockers, or some other thing that provides
for the use case.

Lots of people want PM constraints, and I haven't seen anyone suggest
there should *not* be PM constraints in the kernel some day.  I've seen
a few "working and useful PM constraints aren't going to happen any time
soon" statements, and several "there's lots of stuff you still can't do
with PM constraints or suspend blockers" statements, but those aren't
arguments *against* PM constraints or *for* suspend blockers.

