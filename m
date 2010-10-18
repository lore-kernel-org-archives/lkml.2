Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab0JRVJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:09:37 -0400
Received: from www.tglx.de ([62.245.132.106]:34794 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126Ab0JRVJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:09:36 -0400
Date: Mon, 18 Oct 2010 23:09:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Check if irq is remapped before freeing irte
In-Reply-To: <4CBCB274.7010108@kernel.org>
Message-ID: <alpine.LFD.2.00.1010182304050.6815@localhost6.localdomain6>
References: <4CBCB274.7010108@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Yinghai Lu wrote:
> 
> Index: linux-2.6/drivers/pci/intr_remapping.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/intr_remapping.c
> +++ linux-2.6/drivers/pci/intr_remapping.c
> @@ -60,7 +60,7 @@ int get_irte(int irq, struct irte *entry
>  	unsigned long flags;
>  	int index;
>  
> -	if (!entry || !irq_iommu)
> +	if (!entry || !irq_iommu || !irq_iommu->iommu)
>  		return -1;

Hmm, why do we need this? This is only called from
ir_ioapic_set_affinity() and ir_msi_set_affinity().

We should never end up there when intr_remapping=off, right ?
  
>  	spin_lock_irqsave(&irq_2_ir_lock, flags);
> @@ -268,7 +268,7 @@ int free_irte(int irq)
>  	unsigned long flags;
>  	int rc;
>  
> -	if (!irq_iommu)
> +	if (!irq_iommu || !irq_iommu->iommu)
>  		return -1;

That one makes sense

Thanks,

	tglx
