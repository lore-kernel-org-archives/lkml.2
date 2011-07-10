Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1GJO3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 10:29:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59827 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1GJO3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 10:29:54 -0400
Message-ID: <4E19B75D.2080109@gmail.com>
Date: Sun, 10 Jul 2011 09:29:49 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: nico@fluxnic.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] ARM: move ARCH_HAS_DMA_SET_COHERENT_MASK into memory.h
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <1309366019-24379-3-git-send-email-robherring2@gmail.com> <4E1866A2.9040407@gmail.com> <20110709145856.GM4812@n2100.arm.linux.org.uk>
In-Reply-To: <20110709145856.GM4812@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2011 09:58 AM, Russell King - ARM Linux wrote:
> On Sat, Jul 09, 2011 at 09:33:06AM -0500, Rob Herring wrote:
>> I noticed this is going to have conflicts with your ARM_DMA_ZONE_SIZE
>> series. Can you add this into your series? This still presents another
>> issue to solve for single kernel binary, but hopefully the dma mapping
>> work will help.
> 
> That's a different problem - its about limiting the maximum DMA mask
> which can be set, so that memory is sourced from the right place
> even for drivers which use 32-bit masks.

Yes, I know that they are different.

> It's needed to ensure that dma_set_coherent_mask() can be overridden.
> One solution to it would be to ensure that we always define
> ARCH_HAS_DMA_SET_COHERENT_MASK, and handle the differences internally,
> which is something I've been thinking about adding to my DMA bounce
> series of patches.

asm/dma-mapping.h only includes asm/memory.h. We are getting lucky that
linux/dma-mapping.h is picking up ARCH_HAS_DMA_SET_COHERENT_MASK because
the include path looks like this for ixp4xx and pxa: linux/dma-mapping.h
-> linux/scatterlist.h -> asm/io.h -> mach/io.h -> mach/hardware.h.

I was previously thinking the define was getting picked up thru
asm/pci.h somehow. So I can just drop this from my series. It does need
to get fixed though or other header re-working could silently break this.

Rob
