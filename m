Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1FPOE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:04:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54358 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab1FPOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N5zSrSAi+//Sw8jlZ1sgpaoXM8rmzDC8HYzwkyP8YiU2KmrTQAJZp8Lq3qnqpWMe7f
         jLvoq+YfIY6s05QMFOAhQ5WlIrPP/4aJXP4Dqwp47x1F0Ge6kaKdKRBbH+kflxHuNIdN
         jZBv9nuzsmTCUtU2p/Nu13Yc0nPwcxNBxhw2o=
Message-ID: <4DFA0D83.6070604@gmail.com>
Date: Thu, 16 Jun 2011 09:04:51 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 03/11] dt/irq: add irq_domain_add_simple() helper
References: <20110616042653.29371.2052.stgit@ponder> <20110616044141.29371.76366.stgit@ponder>
In-Reply-To: <20110616044141.29371.76366.stgit@ponder>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 06/15/2011 11:41 PM, Grant Likely wrote:
> irq_domain_add_simple() is an easy way to generate an irq translation
> domain for simple irq controllers.  It assumes a flat 1:1 mapping from
> hardware irq number to an offset of the first linux irq number assigned
> to the controller
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  include/linux/irq.h    |   11 +++++++++
>  kernel/irq/irqdomain.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 68 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index a103c01..50830fc 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -797,6 +797,17 @@ extern unsigned int irq_domain_map(struct irq_domain *domain,
>  				   irq_hw_number_t hwirq);
>  extern void irq_domain_unmap(struct irq_domain *domain, irq_hw_number_t hw);
>  
> +struct of_device_id;
> +#ifdef CONFIG_OF
> +extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
> +extern void irq_domain_generate_simple(struct of_device_id *match,

match should be const

> +					u64 phys_base, unsigned int irq_start);
> +#else

Empty function for irq_domain_add_simple?

> +static inline void irq_domain_generate_simple(struct of_device_id *match,
> +					u64 phys_base, unsigned int irq_start) { }
> +#endif
> +
> +

Rob
