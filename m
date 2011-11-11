Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab1KKNY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:24:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45051 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KKNY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:24:27 -0500
Date: Fri, 11 Nov 2011 13:24:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 16/16] ARM: LPAE: Add the Kconfig entries
Message-ID: <20111111132415.GD12913@n2100.arm.linux.org.uk>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com> <1320682618-1182-17-git-send-email-catalin.marinas@arm.com> <20111110225737.GX12913@n2100.arm.linux.org.uk> <20111111114613.GF23243@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111111114613.GF23243@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 11:46:14AM +0000, Catalin Marinas wrote:
> So we could change this to:
> 
> config ARCH_DMA_ADDR_T_64BIT
> 	depends on ARM_LPAE
> 
> and let platforms select it.

Actually, even this is conceptually wrong.  You really need to get away
from the thought that a dma address in any way is encapsulated within
the machine physical address.

They're two separate things.  For example, you could have an ARMv4 based
system (so, 32-bit address bus) connected to a PCI bridge which supports
64-bit addressing.  This PCI bridge could map system memory into PCI
space greater than 4GB (ok, there are down-sides to doing this, but this
is just an example to illustrate the point).  This would therefore require
a 64-bit dma_addr_t.

The size of dma_addr_t has very little to do with the page table format
or even the host address bus width, and is more to do with bus and
system setup than host CPU setup.

So, I think that we can have:

config ARCH_DMA_ADDR_T_64BIT
	bool

and we just leave it at that - if a platform needs 64-bit DMA addresses,
then selecting this symbol would be the correct approach.
