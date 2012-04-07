Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab2DGHK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:10:59 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52964 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2DGHKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:10:39 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] of/irq: add empty irq_of_parse_and_map() for non-dt builds
To: Thomas Abraham <thomas.abraham@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com, linux-samsung-soc@vger.kernel.org,
        patches@linaro.org
In-Reply-To: <1332687769-3127-1-git-send-email-thomas.abraham@linaro.org>
References: <1332687769-3127-1-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 06 Apr 2012 20:57:48 -0700
Message-Id: <20120407035748.F261E3E24EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 20:32:49 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Add a empty irq_of_parse_and_map() function that returns 0 for non-dt
> builds and avoid having #ifdef CONFIG_OF around all calls to
> irq_of_parse_and_map(). In addition to that, the irq_of_parse_and_map()
> function declaration is made available only if CONFIG_OF_IRQ is defined,
> which is the same config option that makes the irq_of_parse_and_map()
> function definition available. While at it, fix a typo as well.
> 
> Suggested-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Oops, I applied the wrong one.  I've applied this one now instead.

> ---
> Changes since v1:
> - Moved irq_of_parse_and_map() function declaration under CONFIG_OF_IRQ.
> - Fix a minor typo in comments.

BTW; For patches submitted to me, keep the changelog above the s-o-b lines
so it gets included in the commit.

g.

> 
>  include/linux/of_irq.h |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index d229ad3..11d57e4 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -10,14 +10,14 @@ struct of_irq;
>  #include <linux/ioport.h>
>  #include <linux/of.h>
>  
> +#if defined(CONFIG_OF_IRQ)
>  /*
> - * irq_of_parse_and_map() is used ba all OF enabled platforms; but SPARC
> + * irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
>   * implements it differently.  However, the prototype is the same for all,
>   * so declare it here regardless of the CONFIG_OF_IRQ setting.
>   */
>  extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
>  
> -#if defined(CONFIG_OF_IRQ)
>  /**
>   * of_irq - container for device_node/irq_specifier pair for an irq controller
>   * @controller: pointer to interrupt controller device tree node
> @@ -76,5 +76,11 @@ extern struct device_node *of_irq_find_parent(struct device_node *child);
>  extern void of_irq_init(const struct of_device_id *matches);
>  
>  #endif /* CONFIG_OF_IRQ */
> +#else /* CONFIG_OF */
> +static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
> +						int index)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_OF */
>  #endif /* __OF_IRQ_H */
> -- 
> 1.6.6.rc2
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
