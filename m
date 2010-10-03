Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0JCLEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 07:04:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:34740 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab0JCLEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 07:04:08 -0400
Date: Sun, 3 Oct 2010 20:02:52 +0900
To: linux@arm.linux.org.uk
Cc: x0095840@ti.com, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: define SG chain for arm architecture
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20101001163958.GA22533@n2100.arm.linux.org.uk>
References: <1285950521-8093-1-git-send-email-x0095840@ti.com>
	<20101001163958.GA22533@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101003195758B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 03 Oct 2010 20:02:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 17:39:58 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Oct 01, 2010 at 11:28:41AM -0500, Fernando Guzman Lugo wrote:
> > Define SG chain for ARM architecture in order to work
> > with big buffers. This patch is needed in order to
> > iovmm users can pass a big buffer to map it and ARM
> > architecture has not issues using SG chain.
> > 
> > This change was suggested by FUJITA Tomonori.
> 
> Have you audited all places where SG lists are used in the ARM
> architecture to ensure that SG chain support is safe?  (That
> goes for ARM generic code and ARM specific drivers.)

As far as I know, only SCSI actually uses SG chain feature (that is,
sending chained scatter lists). All SCSI drivers were converted when
we added SG chain feature. So what you need to care about is the dma
code.

There are only several files that actually use scatter list under
arch/arm.

>From a quick look, arch/arm/mm/dma-mapping.c,
arch/arm/common/dmabounce.c, arch/arm/kernel/dma.c, and
arch/arm/include/asm/dma-mapping.h looks fine.

arm/mach-imx/dma-v1.c also looks like to use chained sg API properly
(but this isn't used with SCSI, right?).

Seems that arch/arm/plat-omap/iovmm.c can handle the chained SG
too. It doesn't allocate the chained SG now though.
