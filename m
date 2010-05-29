Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0EaQeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:34:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:53751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0EaQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:34:00 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1275149418.4503.128.camel@mulgrave.site>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	 <20100527220949.GB10602@srcf.ucam.org>
	 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100527223605.GB11364@srcf.ucam.org>
	 <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	 <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>
	 <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	 <1275120618.27810.12699.camel@twins>
	 <1275149418.4503.128.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 20:12:15 +0200
Message-ID: <1275156735.1645.497.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 11:10 -0500, James Bottomley wrote:
> > If current hardware can't cope, too friggin bad, get better hardware.
> > 
> > But the truth is, all your OMAP phones really can deal with it.
> 
> That's rubbish and you know it.  We do software workarounds for hardware
> problems all the time ... try doing a git grep -i errata in arch x86, or
> imagine a USB subsystem that only supported sane standards conforming
> devices: that would have an almost zero intersect with the current USB
> device market.
> 
> The job of the kernel is to accommodate hardware as best it can ...
> sometimes it might not be able to, but most of the time it does a pretty
> good job.

Sure, and if x86 could wake from S3 on a keypress/mouse movement etc..
you could use S3 as idle state.. not sure people would love the
wakeup-latency, but that's a QoS matter.

But if there simply are no suitable wakeup sources from an idle state
(S3 really is nothing more than a hardware idle state) then it might not
be suitable for transparent idle modes and no amount of software hackery
will solve that.

So what I'm saying is, if your hardware can't generate the needed wakeup
events, the auto-suspend stuff won't work either. If it can it can be
implemented as a regular idle mode.

> The facts are that C states and S states are different and are entered
> differently.  For some omap hardware, the power consumption in the
> lowest C state (with all the ancillary power control) is the same as S3,
> that's fine, suspend from idle works as well as suspend to ram modulo
> bad apps. For quite a lot of MSM hardware, the lowest C state power
> consumption is quite a bit above S3. 

Wth is MSM?

But really, why can't existing hardware get shipped with existing hacks,
and for future hardware that does behave we have a proper solution?

