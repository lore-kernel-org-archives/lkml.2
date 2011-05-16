Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1EPR2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:28:49 -0400
Received: from service87.mimecast.com ([94.185.240.25]:51063 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753417Ab1EPR2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:28:48 -0400
Subject: Re: [PATCH v5 03/19] ARM: LPAE: Use unsigned long for
 __phys_to_virt and __virt_to_phys
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110508214437.GP27807@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	 <1304859098-10760-4-git-send-email-catalin.marinas@arm.com>
	 <20110508214437.GP27807@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Mon, 16 May 2011 18:28:37 +0100
Message-ID: <1305566917.19230.158.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 16 May 2011 17:28:46.0673 (UTC) FILETIME=[B6314C10:01CC13EE]
X-MC-Unique: 111051618284600601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 22:44 +0100, Russell King - ARM Linux wrote:
> On Sun, May 08, 2011 at 01:51:22PM +0100, Catalin Marinas wrote:
> > The !CONFIG_ARM_PATCH_PHYS_VIRT case uses macros for __phys_to_virt and
> > __virt_to_phys but does not use any type casting. This causes issues
> 
> It might be a good idea to include the compiler warning message in the
> commit log, so that the 'issues' being addressed are readily known.

Here's the new log:

    ARM: LPAE: Use unsigned long for __phys_to_virt and __virt_to_phys
    
    The !CONFIG_ARM_PATCH_PHYS_VIRT case uses macros for __phys_to_virt and
    __virt_to_phys but does not use any type casting. This causes compiler
    warnings with LPAE where the phys_addr_t and dma_addr_t are 64-bit:
    
      CC      arch/arm/mm/dma-mapping.o
    In file included from /work/Linux/linux-marc/include/linux/dma-mapping.h:93:0,
                     from /work/Linux/linux-marc/arch/arm/mm/dma-mapping.c:19:
    /work/Linux/linux-marc/arch/arm/include/asm/dma-mapping.h: In function 'dma_to_virt':
    /work/Linux/linux-marc/arch/arm/include/asm/dma-mapping.h:35:9: warning:
            cast to pointer from integer of different size
    
    Note that these macros are only valid for lowmem physical addresses
    where the range is within 32-bit address range.
    
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin


