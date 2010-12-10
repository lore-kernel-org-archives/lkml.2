Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0LJRcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:32:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60770 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752222Ab0LJRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:32:49 -0500
Date: Fri, 10 Dec 2010 17:32:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and
 fix build failure
Message-ID: <20101210173246.GG3200@rakim.wolfsonmicro.main>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de>
 <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6>
 <20101210050755.GA21712@linux-sh.org>
 <20101210121420.GC3200@rakim.wolfsonmicro.main>
 <20101210154332.GB21712@linux-sh.org>
 <20101210170131.GC21712@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210170131.GC21712@linux-sh.org>
X-Cookie: Well thaaaaaaat's okay.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 02:01:31AM +0900, Paul Mundt wrote:

> The above 4 at least should have their dependencies tidied up. The rest
> of them will break on an allmod/yesconfig for SH for .37, which the
> following patch addresses. On the other hand, none of these are really
> all that pressing, particularly as none of these are used by any of the
> SH defconfigs.

> I had considered adding a GENERIC_HARDIRQS_DEPRECATED, but that
> unfortunately gets to be a bit tricky since almost no one sources
> kernel/irq/Kconfig yet, and this isn't likely to be a problem for very
> long anyways -- it's basically just the MFD drivers that play around with
> the irq_chip anyways.

Please remove the changes for the Wolfson drivers, as I said in my
previous mails if you insist that this must be changed in 2.6.37 I would
much rather cherry-pick the existing changes over into 2.6.37 than have
them unusuable on SH for a release (and we'd need to fix -next to remove
the dependency anyway).  

If you're checking this stuff it'd be good to also take a look at
drivers/gpio - there's a bunch of irq_chips in there too.  I would also
urge you to also contact the maintainers for the relevant drivers while
doing these checks, I suspect quite a few people aren't aware of the new
APIs yet.
