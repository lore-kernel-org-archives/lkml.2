Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863Ab0LJFJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 00:09:13 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40578 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0LJFJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 00:09:11 -0500
Date: Fri, 10 Dec 2010 14:07:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and fix build failure
Message-ID: <20101210050755.GA21712@linux-sh.org>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de> <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com> <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 02:39:55AM +0100, Thomas Gleixner wrote:
> On Fri, 10 Dec 2010, Mark Brown wrote:
> > On 9 Dec 2010, at 23:34, Peter Huewe wrote:
> > > This patch fixes a build failure[1] by converting the driver to use the
> > > new irq_chip functions.
> > 
> > The driver has already been converted; if this is required we should
> > just backport the relevant change (mfd: Convert WM831x to new irq_
> > interrupt methods) in order to avoid merge issues with current code
> > rather than reimplementing. However, at this stage in 2.6.37 I don't
> > think that's a good idea.
> 
> I think it is.
> 
> # git grep GENERIC_HARDIRQS_NO_DEPRECATED arch/
> arch/sh/Kconfig:        select GENERIC_HARDIRQS_NO_DEPRECATED
> 
> Though the question remains, whether this driver is actually used with
> sh platforms. If yes, then pushing the already existing change to
> Linus is the right way to go. If no, adding a "depends on !SH" is the
> simple fix to prevent this allmodconfig fallout. Another option is to
> ignore it :) I leave that up to Paul.
>  
There are no current SH boards that are using this MFD, but there's
certainly no technical reason for why there can't be. I'd rather avoid an
artificial !SH dependency, but adding in something like

	depends on !GENERIC_HARDIRQS_NO_DEPRECATED

for .37 would be fine. We do build randconfigs and so on quite regularly,
so it would obviously be nice not to have this break the build.
