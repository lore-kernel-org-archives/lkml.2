Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1DRLu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:50:28 -0400
Received: from smtp.nokia.com ([147.243.128.24]:57016 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab1DRLuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:50:23 -0400
Date: Mon, 18 Apr 2011 14:42:46 +0300 (EEST)
Message-Id: <20110418.144246.77604458849535045.Hiroshi.DOYU@nokia.com>
To: tony@atomide.com
Cc: arnd@arndb.de, linux@arm.linux.org.uk, fernando.lugo@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, grgupta@ti.com, h-kanigeri2@ti.com
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2
 cache
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20110418110502.GI12272@atomide.com>
References: <20110414223036.GA7335@n2100.arm.linux.org.uk>
	<201104180929.33569.arnd@arndb.de>
	<20110418110502.GI12272@atomide.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ext Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Mon, 18 Apr 2011 14:05:08 +0300

> * Arnd Bergmann <arnd@arndb.de> [110418 10:26]:
>> On Friday 15 April 2011, Russell King - ARM Linux wrote:
>> > On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
>> > > From: Ramesh Gupta <grgupta@ti.com>
>> > > 
>> > > This patch is to flush the iommu page table entries from L1 and L2
>> > > caches using dma_map_single. This also simplifies the implementation
>> > > by removing the functions  flush_iopgd_range/flush_iopte_range.
>> > 
>> > No.  This usage is just wrong.  If you're going to use the DMA API then
>> > unmap it, otherwise the DMA API debugging will go awol.
>> 
>> 
>> It's also completely upside-down: The iommu support should provide interfaces
>> using the dma-mapping API, not use that API to provide a machine specific
>> version of the generic interface.
>> 
>> As far as I can tell, nothing actually uses these drivers, maybe we should just
>> remove them before we get any code in the mainline kernel that depends on it.
> 
> There is drivers/media/video/omap3isp/isp.c. But if we now

Yes, and "dspbridge" has introduced this too, IIRC.

> have a generic replacement for this code we should start using it.

I'm afraid that there's no general IOMMU APIs yet, or already? If
there is, migrating to those general IOMMU API is the way, but still
SoC dependent parts remain, anyway. I guess that more or less general
IOMMU API is composed of common set of client APIs(like IOVMM) and the
registration of H/W dependent functions(like omap iommu), I guess.

> Hiroshi, any comments on that?

This patch is not about (1)general buffer handling between CPU cores
but just about (2)page table entry coherency. (2) is quite same to
what ARM does for its pagetable in cpu_*_set_pte_ext. I think that
using dma api to make pte entry coherent may make sense for general
solution, as Russell suggested.

For (1), I agree that IOVMM layer should be refactored by introducing
dma-mapping API in any case. Any patches are appreciated.
