Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1KBRVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:21:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39624 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab1KBRVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:21:50 -0400
Date: Wed, 2 Nov 2011 17:21:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 16/16] ARM: LPAE: Add the Kconfig entries
Message-ID: <20111102172142.GB12913@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-17-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-17-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:39PM +0100, Catalin Marinas wrote:
> +config ARCH_DMA_ADDR_T_64BIT
> +	def_bool ARM_LPAE
> +

I think this should be selected only when we have a DMA engine supporting
64-bit addresses.  Technically LPAE itself doesn't give us that assurance.

If you have this kind of a setup:

CPU <==++==> RAM
       ||
     IOMMU
       |
   DMA device

where == and || means >32-bit addressing, and | means 32-bit addressing.

In such a setup, having dma_addr_t be 64-bit is pointless because it
should never see 64-bit addresses (the DMA API should deal with the
IOMMU and provide a list of DMA addresses to be placed into RAM for
the DMA device which takes account of the mappings setup in the IOMMU.)

So, I think 64-bit dma_addr_t should be a property of the DMA devices
present in the system rather than whether the CPUs MMU can deal with
>32-bit addresses or not.
