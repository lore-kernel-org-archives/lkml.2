Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2DSApI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:45:08 -0400
Received: from ozlabs.org ([203.10.76.45]:42495 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab2DSApG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:45:06 -0400
Message-ID: <1334796301.6791.9.camel@concordia>
Subject: Re: [PATCH 2/2] irqdomain/powerpc: Fix broken NR_IRQ references
From: Michael Ellerman <michael@ellerman.id.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Thu, 19 Apr 2012 10:45:01 +1000
In-Reply-To: <1334607198-18694-2-git-send-email-grant.likely@secretlab.ca>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca>
	 <1334607198-18694-2-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 14:13 -0600, Grant Likely wrote:

> diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
> index d09f3e8..fc9df1a 100644
> --- a/arch/powerpc/platforms/cell/axon_msi.c
> +++ b/arch/powerpc/platforms/cell/axon_msi.c
> @@ -276,9 +276,6 @@ static int axon_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  	if (rc)
>  		return rc;
>  
> -	/* We rely on being able to stash a virq in a u16 */

Would be nice to move the comment to the hunk below rather than just
deleting it. Otherwise the 65536 looks a bit random.

> -	BUILD_BUG_ON(NR_IRQS > 65536);
> -
>  	list_for_each_entry(entry, &dev->msi_list, list) {
>  		virq = irq_create_direct_mapping(msic->irq_domain);
>  		if (virq == NO_IRQ) {
> @@ -392,7 +389,7 @@ static int axon_msi_probe(struct platform_device *device)
>  	}
>  	memset(msic->fifo_virt, 0xff, MSIC_FIFO_SIZE_BYTES);
>  
> -	msic->irq_domain = irq_domain_add_nomap(dn, 0, &msic_host_ops, msic);
> +	msic->irq_domain = irq_domain_add_nomap(dn, 65536, &msic_host_ops, msic);
>  	if (!msic->irq_domain) {
>  		printk(KERN_ERR "axon_msi: couldn't allocate irq_domain for %s\n",
>  		       dn->full_name);

cheers

