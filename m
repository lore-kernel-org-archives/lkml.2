Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2I0NzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:55:10 -0400
Received: from linux-sh.org ([111.68.239.195]:45064 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2I0NzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:55:09 -0400
Date: Thu, 27 Sep 2012 22:54:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/4] irqdomain: augment add_simple() to allocate descs
Message-ID: <20120927135420.GM13568@linux-sh.org>
References: <1348751625-17420-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348751625-17420-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:13:45PM +0200, Linus Walleij wrote:
> +	if (first_irq > 0) {
> +		int irq_base;
> +
> +		irq_base = irq_alloc_descs(first_irq, 0, size, numa_node_id());
> +		if (irq_base < 0) {
> +			WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
> +			     first_irq);
> +			irq_base = first_irq;
> +		}
> +		return irq_domain_add_legacy(of_node, size, irq_base, 0,
>  					     ops, host_data);

If first_irq is specified you presumably want irq_alloc_desc_at()
behaviour, so you should use irq_alloc_descs(first_irq, first_irq, ...),
similar to what irq_create_strict_mappings() does.

Also don't use numa_node_id() for this, of_node_to_nid() handles both the
OF and non-OF cases.
