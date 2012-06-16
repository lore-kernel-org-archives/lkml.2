Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2FPGCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:02:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:59199 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab2FPGCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:02:33 -0400
Message-ID: <1339826522.9220.225.camel@pasglop>
Subject: Re: [PATCH 10/12] irqdomain: Add debugging message
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Date: Sat, 16 Jun 2012 16:02:02 +1000
In-Reply-To: <1339822897-15840-11-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
	 <1339822897-15840-11-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
> Trivial patch to beef up debugging messages on irqdomain.c
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Paul Mundt <lethal@linux-sh.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
>  kernel/irq/irqdomain.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index c0a00de..0e02a1d 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -334,6 +334,9 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
>  	irq_hw_number_t hwirq = hwirq_base;
>  	int i;
>  
> +	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
> +		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
> +
>  	for (i = 0; i < count; i++) {
>  		struct irq_data *irq_data = irq_get_irq_data(virq + i);
>  


