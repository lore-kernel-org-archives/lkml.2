Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab0LJBkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:40:12 -0500
Received: from www.tglx.de ([62.245.132.106]:45072 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab0LJBkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:40:10 -0500
Date: Fri, 10 Dec 2010 02:39:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and
 fix build failure
In-Reply-To: <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de> (sfid-20101209_233452_977189_2E13469D) <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Mark Brown wrote:

> On 9 Dec 2010, at 23:34, Peter Huewe wrote:
> 
> > This patch fixes a build failure[1] by converting the driver to use the
> > new irq_chip functions.
> 
> The driver has already been converted; if this is required we should
> just backport the relevant change (mfd: Convert WM831x to new irq_
> interrupt methods) in order to avoid merge issues with current code
> rather than reimplementing. However, at this stage in 2.6.37 I don't
> think that's a good idea.

I think it is.

# git grep GENERIC_HARDIRQS_NO_DEPRECATED arch/
arch/sh/Kconfig:        select GENERIC_HARDIRQS_NO_DEPRECATED

Though the question remains, whether this driver is actually used with
sh platforms. If yes, then pushing the already existing change to
Linus is the right way to go. If no, adding a "depends on !SH" is the
simple fix to prevent this allmodconfig fallout. Another option is to
ignore it :) I leave that up to Paul.
 
> > The old functions are deprecated and masked by GENERIC_HARDIRQS_NO__DO_IRQ
> 
> 
> Are you sure it's that option and not GENERIC_HARDIRQS_NO_DEPRECATED? 

Right that changelog sucks. :)

> > Cc: Stable <stable@kernel.org>
> 
> Why are you CCing to stable? This API was only introduced in 2.6.37 which is still
> in -rc and attempting to backport to stable releases would cause those releases to
> fail to build.

Right, thats useless.

Thanks,

	tglx
