Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1BLKe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 05:34:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53184 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BLKeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 05:34:23 -0500
Date: Sat, 12 Feb 2011 10:34:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 16/19] ARM: LPAE: Use generic dma_addr_t type
	definition
Message-ID: <20110212103413.GD15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-17-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295891761-18366-17-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 05:55:58PM +0000, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> This patch uses the types.h implementation in asm-generic to define the
> dma_addr_t type as the same width as phys_addr_t.
> 
> NOTE: this is a temporary patch until the corresponding patches unifying
> the dma_addr_t and removing the dma64_addr_t are merged into mainline.

I'm not too sure about this patch.  All of the DMA devices we have only
take 32-bit addresses for their DMA, so making dma_addr_t 64-bit seems
wrong as we'll implicitly truncate these addresses.

As ARM platforms don't (sanely) support DMA, I think dropping this patch
for the time being would be a good idea, and stick with 32-bit dma_addr_t,
especially as we need to first do a sweep for dma_addr_t usage in device
driver structures (such as dma engine scatter lists.)  These really should
use __le32/__be32/u32 depending on whether they're little endian, big
endian or native endian.
