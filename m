Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2JBE5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:57:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53602 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JBE5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:57:47 -0400
Date: Tue, 2 Oct 2012 06:57:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 -tip 3/5] x86, MSI: Minor readability fixes
Message-ID: <20121002045741.GB7756@gmail.com>
References: <cover.1349074231.git.agordeev@redhat.com>
 <1638b429b0e5684b6620ef36d101ef782ddeacb8.1349074231.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638b429b0e5684b6620ef36d101ef782ddeacb8.1349074231.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 84d632b..0489699 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3123,7 +3123,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
>  
>  	if (irq_remapped(cfg)) {
>  		compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
> -		return err;
> +		return 0;
>  	}
>  
>  	if (x2apic_enabled())
> @@ -3150,7 +3150,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
>  			MSI_DATA_DELIVERY_LOWPRI) |
>  		MSI_DATA_VECTOR(cfg->vector);
>  
> -	return err;
> +	return 0;
>  }
>  
>  static int
> @@ -3232,7 +3232,7 @@ int setup_msix_irqs(struct pci_dev *dev, int nvec)
>  	list_for_each_entry(msidesc, &dev->msi_list, list) {
>  		irq = create_irq_nr(irq_want, node);
>  		if (irq == 0)
> -			return -1;
> +			return -ENOSPC;
>  		irq_want = irq + 1;
>  		if (!irq_remapping_enabled)
>  			goto no_ir;

This should be backported into earlier patches.

Thanks,

	Ingo
