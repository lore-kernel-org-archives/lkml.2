Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0LJMOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:14:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42581 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755623Ab0LJMOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:14:23 -0500
Date: Fri, 10 Dec 2010 12:14:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and
 fix build failure
Message-ID: <20101210121420.GC3200@rakim.wolfsonmicro.main>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de>
 <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6>
 <20101210050755.GA21712@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210050755.GA21712@linux-sh.org>
X-Cookie: Well thaaaaaaat's okay.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 02:07:55PM +0900, Paul Mundt wrote:
> On Fri, Dec 10, 2010 at 02:39:55AM +0100, Thomas Gleixner wrote:
> > On Fri, 10 Dec 2010, Mark Brown wrote:

> > > The driver has already been converted; if this is required we should
> > > just backport the relevant change (mfd: Convert WM831x to new irq_
> > > interrupt methods) in order to avoid merge issues with current code
> > > rather than reimplementing. However, at this stage in 2.6.37 I don't
> > > think that's a good idea.

> > I think it is.

> > # git grep GENERIC_HARDIRQS_NO_DEPRECATED arch/
> > arch/sh/Kconfig:        select GENERIC_HARDIRQS_NO_DEPRECATED

Oh dear.  Can anyone comment on why SH is selecting this?  My first
thought is that the savings from enabling it are going to be on the
small side so it wouldn't be a big issue to leave it off for 2.6.37
and possibly 2.6.38 also.

If we're going to start enabling this on platforms I'd also suggest that
we enable it on x86 in -next so that we get reasonable coverage from
build tests.  It needs to be enabled on a major architecture to catch
the change during development.

> > Though the question remains, whether this driver is actually used with
> > sh platforms. If yes, then pushing the already existing change to

It's not just this driver - I'd expect everything with an interrupt
controller in drivers/mfd to have an issue here, and I don't think
disabling them all on SH for this release is such a good approach.

> > Linus is the right way to go. If no, adding a "depends on !SH" is the
> > simple fix to prevent this allmodconfig fallout. Another option is to
> > ignore it :) I leave that up to Paul.

> There are no current SH boards that are using this MFD, but there's
> certainly no technical reason for why there can't be. I'd rather avoid an
> artificial !SH dependency, but adding in something like

> 	depends on !GENERIC_HARDIRQS_NO_DEPRECATED

> for .37 would be fine. We do build randconfigs and so on quite regularly,
> so it would obviously be nice not to have this break the build.

I'd rather not do that, certainly not for everything.
