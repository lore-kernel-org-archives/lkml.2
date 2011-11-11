Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab1KKLqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:46:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60377 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754631Ab1KKLqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:46:32 -0500
Date: Fri, 11 Nov 2011 11:46:14 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 16/16] ARM: LPAE: Add the Kconfig entries
Message-ID: <20111111114613.GF23243@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-17-git-send-email-catalin.marinas@arm.com>
 <20111110225737.GX12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110225737.GX12913@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:57:37PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 07, 2011 at 04:16:58PM +0000, Catalin Marinas wrote:
> > +config ARCH_PHYS_ADDR_T_64BIT
> > +	def_bool ARM_LPAE
> > +
> > +config ARCH_DMA_ADDR_T_64BIT
> > +	def_bool ARM_LPAE
> > +
> 
> I still say this shouldn't depend on the host page table format.  LPAE
> itself has nothing to do with whether 64-bit DMA addresses are supported
> by the system.

So we could change this to:

config ARCH_DMA_ADDR_T_64BIT
	depends on ARM_LPAE

and let platforms select it.

The x86 approach is to have another HIGHMEM64G config option for
systems with more than 4GB of RAM and ARCH_DMA_ADDR_T_64BIT is selected
automatically. But this comes under the assumption that there is a 1:1
mapping between phys and bus addresses.

-- 
Catalin
