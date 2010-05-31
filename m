Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0EaUuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:50:24 -0400
Received: from www.tglx.de ([62.245.132.106]:55409 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab0EaUuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:50:22 -0400
Date: Mon, 31 May 2010 22:49:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@suse.de>
cc: Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1275149418.4503.128.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.1005312231120.2933@localhost.localdomain>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>  <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>  <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>  <20100527220949.GB10602@srcf.ucam.org>  <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
  <20100527223605.GB11364@srcf.ucam.org>  <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>  <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>  <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>  <1275120618.27810.12699.camel@twins>
 <1275149418.4503.128.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010, James Bottomley wrote:
> The job of the kernel is to accommodate hardware as best it can ...
> sometimes it might not be able to, but most of the time it does a pretty
> good job.
> 
> The facts are that C states and S states are different and are entered
> differently. 

That's an x86'ism which is going away. And that's really completely
irrelevant for the mobile device space. Can we please stop trying to
fix todays x86 based laptop problems? They are simply not fixable.

> For some omap hardware, the power consumption in the
> lowest C state (with all the ancillary power control) is the same as S3,
> that's fine, suspend from idle works as well as suspend to ram modulo
> bad apps. For quite a lot of MSM hardware, the lowest C state power
> consumption is quite a bit above S3.  It's not acceptable to tell those
> people "tough, your battery runs out in 30 minutes because you bought
> the wrong hardware".  We have to figure out how to get to S3 ... whether
> this is from idle or some other mechanism is again a discussion point,
> but not doing it is not an option.

If you'd have read the answers from Alan carefully, then you'd have
noticed that even x86 hardware is getting to the point where OMAP is
today. i.e. support of transparent suspend from idle. If that wouldn't
happen then x86 would be simply unusable for mobile devices. It's that
easy. And we really do _NOT_ care about the existing laptop hardware
which does not provide that because it's a lost case. Not only due to
the missing (or just disabled) wakeup sources, also due to the fact
that you cannot do sensible power management by completely disabling
clock and/or power of unused devices in the chipset. There is a damn
good reason why the mobile space is _NOT_ x86 based at the moment.

Thanks,

	tglx
