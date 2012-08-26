Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2HZSVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:21:32 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60848 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab2HZSVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:21:31 -0400
Date: Sun, 26 Aug 2012 20:21:26 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 12/19] x86, irq: Add data structure to keep AMD specific
 irq remapping information
Message-ID: <20120826182126.GD3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-13-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-13-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:58PM +0200, Joerg Roedel wrote:
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -101,6 +101,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
>  	irq_attr->polarity	= polarity;
>  }
>  
> +/* Intel specific interrupt remapping information */
>  struct irq_2_iommu {
>  	struct intel_iommu *iommu;
>  	u16 irte_index;
> @@ -108,6 +109,12 @@ struct irq_2_iommu {
>  	u8  irte_mask;
>  };
>  
> +/* AMD specific interrupt remapping information */
> +struct irq_2_irte {
> +	u16 devid; /* Device ID for IRTE table */
> +	u16 index; /* Index into IRTE table*/
> +};
so irte_index like in iommu case would make the comment superfluous. However
the struct is already named _irte...
However, the "{Intel|AMD} specific..." is helpfull since irte and such are
present in both.

Sebastian
