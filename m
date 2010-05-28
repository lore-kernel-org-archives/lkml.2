Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0E1WQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:16:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab0E1WQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:16:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Sat, 29 May 2010 00:18:14 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <20100528005045.6ea5feba@lxorguk.ukuu.org.uk> <1275031797.32462.18.camel@laptop>
In-Reply-To: <1275031797.32462.18.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005290018.14832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010, Peter Zijlstra wrote:
> On Fri, 2010-05-28 at 00:50 +0100, Alan Cox wrote:
> > Today "idle" means "no task running"
> > 
> > If you are prepared to rephrase that as "no task that matters is running"
> > what would need to answer ?
> 
> I'm not sure we need or want to go there.
> 
> Why not simply let upatedb block on its IO because its QoS policy tells
> us that its IO priority is idle. Therefore it will not avoid the IO
> device from going idle and indefinitely delaying servicing requests.
> 
> When updatedb blocks, the runqueue becomes empty and we gain goodness.
> 
> Or are we talking about the same thing?

There may be apps that don't actually do I/O that we may want to be treated
that way too.

Consider the following scenario.  I have a purely computational task that's
running on my laptop in the background (say it's a folding@home or something
similar), but I only want it to run when (a) the box is on AC power and (b)
when user interface is "active" (the latter would have to be defined precisely,
but for the purpose of this thought experiment let's assume we have such a
definition).  Then, I'd only like it to be regarded as runnable if (a) and (b)
both happen at the same time, but it can't block on I/O.

Thanks,
Rafael
