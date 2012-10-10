Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2JJFmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 01:42:04 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44628 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2JJFmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 01:42:01 -0400
Message-ID: <1349847713.17211.4.camel@localhost>
Subject: Re: [PATCH] No need to call irq_domain_legacy_revmap() for twice
From: Mike <qiudayu@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org, grant.likely@secretlab.ca
Date: Wed, 10 Oct 2012 13:41:53 +0800
In-Reply-To: <1348479475-13074-1-git-send-email-qiudayu@linux.vnet.ibm.com>
References: <1348479475-13074-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
x-cbid: 12101005-9574-0000-0000-000004CC918D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments?
Thanks
在 2012-09-24一的 17:37 +0800，Mike Qiu写道：
> Function irq_create_mapping() calls irq_find_mapping(). The later
> function has checked if the indicated IRQ domain has hw IRQ mapped to
> virtual IRQ through legacy mode or not and return the value of the
> legacy irq number by call irq_domain_legacy_revmap(). We needn't
> to call irq_domain_legacy_revmap() to do same check in
> irq_create_mapping() again.
> 
> The patch removes the duplicate call.
> 
> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> ---
>  kernel/irq/irqdomain.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 49a7772..286d672 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -547,9 +547,12 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  		return virq;
>  	}
> 
> -	/* Get a virtual interrupt number */
> +	/*
> +	 * For IRQ domain with type of IRQ_DOMAIN_MAP_LEGACY, we needn't
> +	 * create the IRQ mapping for non-existing one, so just return 0.
> +	 */
>  	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> -		return irq_domain_legacy_revmap(domain, hwirq);
> +		return 0;
> 
>  	/* Allocate a virtual interrupt number */
>  	hint = hwirq % nr_irqs;


