Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0JKEKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:10:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64598 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0JKEKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:10:49 -0400
Date: Sun, 10 Oct 2010 22:10:46 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] of: add of_pdt namespace to pdt code
Message-ID: <20101011041046.GD23588@angua.secretlab.ca>
References: <20101010015606.5a5fb6c5@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010015606.5a5fb6c5@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 01:56:06AM -0700, Andres Salomon wrote:
> 
> For symbols still lacking namespace qualifiers, add an of_pdt_ prefix.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Applied, thanks

g.

> ---
>  arch/sparc/kernel/leon_kernel.c |    2 +-
>  drivers/of/pdt.c                |   40 +++++++++++++++++++-------------------
>  include/linux/of_pdt.h          |    2 +-
>  3 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
> index 6a7b4db..2d51527 100644
> --- a/arch/sparc/kernel/leon_kernel.c
> +++ b/arch/sparc/kernel/leon_kernel.c
> @@ -282,5 +282,5 @@ void __init leon_init_IRQ(void)
>  
>  void __init leon_init(void)
>  {
> -	prom_build_more = &leon_node_init;
> +	of_pdt_build_more = &leon_node_init;
>  }
> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> index fd02fc1..31a4fb8 100644
> --- a/drivers/of/pdt.c
> +++ b/drivers/of/pdt.c
> @@ -26,7 +26,7 @@
>  
>  static struct of_pdt_ops *of_pdt_prom_ops __initdata;
>  
> -void __initdata (*prom_build_more)(struct device_node *dp,
> +void __initdata (*of_pdt_build_more)(struct device_node *dp,
>  		struct device_node ***nextp);
>  
>  #if defined(CONFIG_SPARC)
> @@ -53,7 +53,7 @@ static inline const char *of_pdt_node_name(struct device_node *dp)
>  
>  #endif /* !CONFIG_SPARC */
>  
> -static struct property * __init build_one_prop(phandle node, char *prev,
> +static struct property * __init of_pdt_build_one_prop(phandle node, char *prev,
>  					       char *special_name,
>  					       void *special_val,
>  					       int special_len)
> @@ -100,17 +100,17 @@ static struct property * __init build_one_prop(phandle node, char *prev,
>  	return p;
>  }
>  
> -static struct property * __init build_prop_list(phandle node)
> +static struct property * __init of_pdt_build_prop_list(phandle node)
>  {
>  	struct property *head, *tail;
>  
> -	head = tail = build_one_prop(node, NULL,
> +	head = tail = of_pdt_build_one_prop(node, NULL,
>  				     ".node", &node, sizeof(node));
>  
> -	tail->next = build_one_prop(node, NULL, NULL, NULL, 0);
> +	tail->next = of_pdt_build_one_prop(node, NULL, NULL, NULL, 0);
>  	tail = tail->next;
>  	while(tail) {
> -		tail->next = build_one_prop(node, tail->name,
> +		tail->next = of_pdt_build_one_prop(node, tail->name,
>  					    NULL, NULL, 0);
>  		tail = tail->next;
>  	}
> @@ -118,7 +118,7 @@ static struct property * __init build_prop_list(phandle node)
>  	return head;
>  }
>  
> -static char * __init get_one_property(phandle node, const char *name)
> +static char * __init of_pdt_get_one_property(phandle node, const char *name)
>  {
>  	char *buf = "<NULL>";
>  	int len;
> @@ -132,7 +132,7 @@ static char * __init get_one_property(phandle node, const char *name)
>  	return buf;
>  }
>  
> -static struct device_node * __init prom_create_node(phandle node,
> +static struct device_node * __init of_pdt_create_node(phandle node,
>  						    struct device_node *parent)
>  {
>  	struct device_node *dp;
> @@ -146,18 +146,18 @@ static struct device_node * __init prom_create_node(phandle node,
>  
>  	kref_init(&dp->kref);
>  
> -	dp->name = get_one_property(node, "name");
> -	dp->type = get_one_property(node, "device_type");
> +	dp->name = of_pdt_get_one_property(node, "name");
> +	dp->type = of_pdt_get_one_property(node, "device_type");
>  	dp->phandle = node;
>  
> -	dp->properties = build_prop_list(node);
> +	dp->properties = of_pdt_build_prop_list(node);
>  
>  	irq_trans_init(dp);
>  
>  	return dp;
>  }
>  
> -static char * __init build_full_name(struct device_node *dp)
> +static char * __init of_pdt_build_full_name(struct device_node *dp)
>  {
>  	int len, ourlen, plen;
>  	char *n;
> @@ -177,7 +177,7 @@ static char * __init build_full_name(struct device_node *dp)
>  	return n;
>  }
>  
> -static struct device_node * __init prom_build_tree(struct device_node *parent,
> +static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
>  						   phandle node,
>  						   struct device_node ***nextp)
>  {
> @@ -185,7 +185,7 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
>  	struct device_node *dp;
>  
>  	while (1) {
> -		dp = prom_create_node(node, parent);
> +		dp = of_pdt_create_node(node, parent);
>  		if (!dp)
>  			break;
>  
> @@ -202,13 +202,13 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
>  #if defined(CONFIG_SPARC)
>  		dp->path_component_name = build_path_component(dp);
>  #endif
> -		dp->full_name = build_full_name(dp);
> +		dp->full_name = of_pdt_build_full_name(dp);
>  
> -		dp->child = prom_build_tree(dp,
> +		dp->child = of_pdt_build_tree(dp,
>  				of_pdt_prom_ops->getchild(node), nextp);
>  
> -		if (prom_build_more)
> -			prom_build_more(dp, nextp);
> +		if (of_pdt_build_more)
> +			of_pdt_build_more(dp, nextp);
>  
>  		node = of_pdt_prom_ops->getsibling(node);
>  	}
> @@ -223,13 +223,13 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
>  	BUG_ON(!ops);
>  	of_pdt_prom_ops = ops;
>  
> -	allnodes = prom_create_node(root_node, NULL);
> +	allnodes = of_pdt_create_node(root_node, NULL);
>  #if defined(CONFIG_SPARC)
>  	allnodes->path_component_name = "";
>  #endif
>  	allnodes->full_name = "/";
>  
>  	nextp = &allnodes->allnext;
> -	allnodes->child = prom_build_tree(allnodes,
> +	allnodes->child = of_pdt_build_tree(allnodes,
>  			of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
>  }
> diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
> index 303c5ff..0f7d0c5 100644
> --- a/include/linux/of_pdt.h
> +++ b/include/linux/of_pdt.h
> @@ -36,7 +36,7 @@ extern void *prom_early_alloc(unsigned long size);
>  /* for building the device tree */
>  extern void of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops);
>  
> -extern void (*prom_build_more)(struct device_node *dp,
> +extern void (*of_pdt_build_more)(struct device_node *dp,
>  		struct device_node ***nextp);
>  
>  #endif /* _LINUX_OF_PDT_H */
> -- 
> 1.5.6.5
> 
