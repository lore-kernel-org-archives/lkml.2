Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0LKCAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 21:00:24 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53934 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab0LKCAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 21:00:23 -0500
Date: Sat, 11 Dec 2010 10:59:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and fix build failure
Message-ID: <20101211015907.GC3750@linux-sh.org>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de> <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com> <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6> <20101210050755.GA21712@linux-sh.org> <20101210121420.GC3200@rakim.wolfsonmicro.main> <20101210154332.GB21712@linux-sh.org> <20101210172407.GF3200@rakim.wolfsonmicro.main> <20101210174843.GB3750@linux-sh.org> <20101210182455.GJ3200@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210182455.GJ3200@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 06:24:55PM +0000, Mark Brown wrote:
> On Sat, Dec 11, 2010 at 02:48:43AM +0900, Paul Mundt wrote:
> 
> > I have no intention of dropping the select from SH, but I'm not going to
> > insist that these drivers have the deprecated dependency if we're a) not
> > really using them and b) there's a reasonable expectation that they'll
> > basically be taken care of in .38 anyways.
> 
> That's unfortunate, I'm a bit concerned about support for users picking
> up the kernel and using it to build products.
> 
As I pointed out initially, backtracking would only encourage people to
continue to add new code that uses deprecated interfaces. This happens
time and time again, and is a far greater concern.

> Samuel, would you be OK with cherry picking the relevant commits to the
> Wolfson drivers back into .37?  I'm especially concerned about WM8994
> here - I'd really not like to see a kernel version go out where that
> doesn't work.
> 
That hardly addresses the issue, and simply covers your own driver. The
issue at hand is whether it's worth flagging the deprecated API users
with an explicit dependency or not. You've dismissed the idea of getting
your dependencies right out of hand, but also don't wish to ship a broken
driver, so we need an alternative.

After a full tree audit it's the MFD drivers and a couple of GPIO
expanders that could theoretically be enabled and break the build. I
suppose I could switch to

	select GENERIC_HARDIRQS_NO_DEPRECATED if !MFD_SUPPORT && !GPIOLIB

for .37 since it's too late to convert the remaining drivers now.
Conditionalizing it will at least limit the number of platforms where the
old API is visible.

> > I haven't been following the progress in -next, but now that you've
> > pointed it out I'll give it a look. It's less effort to just fix up the
> > remaining users than it is to audit API dependencies for all of them at
> > least.
> 
> Probably slightly more in that you can't just blindly add the dependency
> when you see the problem but yeah.

At what point is a dependency being "blindly" added? The patch provided
was meant as a stop-gap for .37 so that the drivers using the deprecated
API have an explicit dependency on it. For .38 it's trivial to convert
them, and as I've done pretty much all of the conversion work that's
upstream right now I don't think you're in much position to say what has
and hasn't been thought out.
