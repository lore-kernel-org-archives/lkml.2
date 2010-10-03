Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0JCLex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 07:34:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:37359 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0JCLew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 07:34:52 -0400
Date: Sun, 3 Oct 2010 20:34:05 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, x0095840@ti.com,
        linux-arm-kernel@lists.infradead.org, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: define SG chain for arm architecture
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20101003112839.GA32736@n2100.arm.linux.org.uk>
References: <20101001163958.GA22533@n2100.arm.linux.org.uk>
	<20101003195758B.fujita.tomonori@lab.ntt.co.jp>
	<20101003112839.GA32736@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101003202920K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 03 Oct 2010 20:34:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010 12:28:39 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sun, Oct 03, 2010 at 08:02:52PM +0900, FUJITA Tomonori wrote:
> > On Fri, 1 Oct 2010 17:39:58 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Fri, Oct 01, 2010 at 11:28:41AM -0500, Fernando Guzman Lugo wrote:
> > > > Define SG chain for ARM architecture in order to work
> > > > with big buffers. This patch is needed in order to
> > > > iovmm users can pass a big buffer to map it and ARM
> > > > architecture has not issues using SG chain.
> > > > 
> > > > This change was suggested by FUJITA Tomonori.
> > > 
> > > Have you audited all places where SG lists are used in the ARM
> > > architecture to ensure that SG chain support is safe?  (That
> > > goes for ARM generic code and ARM specific drivers.)
> > 
> > As far as I know, only SCSI actually uses SG chain feature (that is,
> > sending chained scatter lists). All SCSI drivers were converted when
> > we added SG chain feature. So what you need to care about is the dma
> > code.
> > 
> > There are only several files that actually use scatter list under
> > arch/arm.
> > 
> > >From a quick look, arch/arm/mm/dma-mapping.c,
> > arch/arm/common/dmabounce.c, arch/arm/kernel/dma.c, and
> > arch/arm/include/asm/dma-mapping.h looks fine.
> > 
> > arm/mach-imx/dma-v1.c also looks like to use chained sg API properly
> > (but this isn't used with SCSI, right?).
> > 
> > Seems that arch/arm/plat-omap/iovmm.c can handle the chained SG
> > too. It doesn't allocate the chained SG now though.
> 
> There's also RiscPC and its SCSI drivers could well be an issue for SG
> chaining.  They have to manually save the SCSI 'data pointer' (down to
> the byte position in the SG chain and be able to restore a previously
> saved point.)  This code was written before SG chaining ever appeared,
> and although it has been partly fixed up, it's probably buggy if SG
> chaining were to be enabled.

What SCSI drviers we need to fix?


> If it's just OMAP users who wish to enable SG chaining, then the sane
> thing to do would be to make the definition of the macro conditional
> on OMAP.

Yeah, that should work.
