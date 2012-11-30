Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2K3RPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:15:34 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:60870 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751593Ab2K3RPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:15:32 -0500
Message-ID: <50B8E9AC.2060908@xenotime.net>
Date: Fri, 30 Nov 2012 09:15:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH] Fix build when CONFIG_W1_MASTER_GPIO=m b exporting "allnodes"
References: <1354269872-20626-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1354269872-20626-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 02:04 AM, Grant Likely wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> ERROR: "allnodes" [drivers/w1/masters/w1-gpio.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> [grant.likely: allnodes is too generic; rename to of_allnodes]
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Ville Syrjala <syrjala@sci.fi>


That builds.  Thanks.

(using xenotime.net for email temporarily)

> ---
>  arch/arm/mach-vexpress/v2m.c |    2 +-
>  drivers/of/base.c            |   29 +++++++++++++++--------------
>  drivers/of/fdt.c             |    2 +-
>  drivers/of/pdt.c             |   12 ++++++------
>  include/linux/of.h           |    4 ++--
>  5 files changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> index 560e0df..359f782 100644
> --- a/arch/arm/mach-vexpress/v2m.c
> +++ b/arch/arm/mach-vexpress/v2m.c
> @@ -589,7 +589,7 @@ void __init v2m_dt_init_early(void)
>  		return;
>  
>  	/* Confirm board type against DT property, if available */
> -	if (of_property_read_u32(allnodes, "arm,hbi", &dt_hbi) == 0) {
> +	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) == 0) {
>  		int site = v2m_get_master_site();
>  		u32 id = readl(v2m_sysreg_base + (site == SYS_CFG_SITE_DB2 ?
>  				V2M_SYS_PROCID1 : V2M_SYS_PROCID0));
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index c372411..538e3cf 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -45,7 +45,8 @@ struct alias_prop {
>  
>  static LIST_HEAD(aliases_lookup);
>  
> -struct device_node *allnodes;
> +struct device_node *of_allnodes;
> +EXPORT_SYMBOL(of_allnodes);
>  struct device_node *of_chosen;
>  struct device_node *of_aliases;
>  
> @@ -199,7 +200,7 @@ struct device_node *of_find_all_nodes(struct device_node *prev)
>  	struct device_node *np;
>  
>  	read_lock(&devtree_lock);
> -	np = prev ? prev->allnext : allnodes;
> +	np = prev ? prev->allnext : of_allnodes;
>  	for (; np != NULL; np = np->allnext)
>  		if (of_node_get(np))
>  			break;
> @@ -422,7 +423,7 @@ EXPORT_SYMBOL(of_get_child_by_name);
>   */
>  struct device_node *of_find_node_by_path(const char *path)
>  {
> -	struct device_node *np = allnodes;
> +	struct device_node *np = of_allnodes;
>  
>  	read_lock(&devtree_lock);
>  	for (; np; np = np->allnext) {
> @@ -452,7 +453,7 @@ struct device_node *of_find_node_by_name(struct device_node *from,
>  	struct device_node *np;
>  
>  	read_lock(&devtree_lock);
> -	np = from ? from->allnext : allnodes;
> +	np = from ? from->allnext : of_allnodes;
>  	for (; np; np = np->allnext)
>  		if (np->name && (of_node_cmp(np->name, name) == 0)
>  		    && of_node_get(np))
> @@ -481,7 +482,7 @@ struct device_node *of_find_node_by_type(struct device_node *from,
>  	struct device_node *np;
>  
>  	read_lock(&devtree_lock);
> -	np = from ? from->allnext : allnodes;
> +	np = from ? from->allnext : of_allnodes;
>  	for (; np; np = np->allnext)
>  		if (np->type && (of_node_cmp(np->type, type) == 0)
>  		    && of_node_get(np))
> @@ -512,7 +513,7 @@ struct device_node *of_find_compatible_node(struct device_node *from,
>  	struct device_node *np;
>  
>  	read_lock(&devtree_lock);
> -	np = from ? from->allnext : allnodes;
> +	np = from ? from->allnext : of_allnodes;
>  	for (; np; np = np->allnext) {
>  		if (type
>  		    && !(np->type && (of_node_cmp(np->type, type) == 0)))
> @@ -545,7 +546,7 @@ struct device_node *of_find_node_with_property(struct device_node *from,
>  	struct property *pp;
>  
>  	read_lock(&devtree_lock);
> -	np = from ? from->allnext : allnodes;
> +	np = from ? from->allnext : of_allnodes;
>  	for (; np; np = np->allnext) {
>  		for (pp = np->properties; pp; pp = pp->next) {
>  			if (of_prop_cmp(pp->name, prop_name) == 0) {
> @@ -616,7 +617,7 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
>  		*match = NULL;
>  
>  	read_lock(&devtree_lock);
> -	np = from ? from->allnext : allnodes;
> +	np = from ? from->allnext : of_allnodes;
>  	for (; np; np = np->allnext) {
>  		if (of_match_node(matches, np) && of_node_get(np)) {
>  			if (match)
> @@ -669,7 +670,7 @@ struct device_node *of_find_node_by_phandle(phandle handle)
>  	struct device_node *np;
>  
>  	read_lock(&devtree_lock);
> -	for (np = allnodes; np; np = np->allnext)
> +	for (np = of_allnodes; np; np = np->allnext)
>  		if (np->phandle == handle)
>  			break;
>  	of_node_get(np);
> @@ -1254,9 +1255,9 @@ void of_attach_node(struct device_node *np)
>  
>  	write_lock_irqsave(&devtree_lock, flags);
>  	np->sibling = np->parent->child;
> -	np->allnext = allnodes;
> +	np->allnext = of_allnodes;
>  	np->parent->child = np;
> -	allnodes = np;
> +	of_allnodes = np;
>  	write_unlock_irqrestore(&devtree_lock, flags);
>  }
>  
> @@ -1277,11 +1278,11 @@ void of_detach_node(struct device_node *np)
>  	if (!parent)
>  		goto out_unlock;
>  
> -	if (allnodes == np)
> -		allnodes = np->allnext;
> +	if (of_allnodes == np)
> +		of_allnodes = np->allnext;
>  	else {
>  		struct device_node *prev;
> -		for (prev = allnodes;
> +		for (prev = of_allnodes;
>  		     prev->allnext != np;
>  		     prev = prev->allnext)
>  			;
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index e36ff40..a65c39c 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -712,7 +712,7 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
>   */
>  void __init unflatten_device_tree(void)
>  {
> -	__unflatten_device_tree(initial_boot_params, &allnodes,
> +	__unflatten_device_tree(initial_boot_params, &of_allnodes,
>  				early_init_dt_alloc_memory_arch);
>  
>  	/* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> index 07cc1d6..37b56fd 100644
> --- a/drivers/of/pdt.c
> +++ b/drivers/of/pdt.c
> @@ -241,15 +241,15 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
>  	BUG_ON(!ops);
>  	of_pdt_prom_ops = ops;
>  
> -	allnodes = of_pdt_create_node(root_node, NULL);
> +	of_allnodes = of_pdt_create_node(root_node, NULL);
>  #if defined(CONFIG_SPARC)
> -	allnodes->path_component_name = "";
> +	of_allnodes->path_component_name = "";
>  #endif
> -	allnodes->full_name = "/";
> +	of_allnodes->full_name = "/";
>  
> -	nextp = &allnodes->allnext;
> -	allnodes->child = of_pdt_build_tree(allnodes,
> -			of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
> +	nextp = &of_allnodes->allnext;
> +	of_allnodes->child = of_pdt_build_tree(of_allnodes,
> +			of_pdt_prom_ops->getchild(of_allnodes->phandle), &nextp);
>  
>  	/* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
>  	of_alias_scan(kernel_tree_alloc);
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 7337dc1..60053bd 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -88,14 +88,14 @@ static inline void of_node_put(struct device_node *node) { }
>  #ifdef CONFIG_OF
>  
>  /* Pointer for first entry in chain of all nodes. */
> -extern struct device_node *allnodes;
> +extern struct device_node *of_allnodes;
>  extern struct device_node *of_chosen;
>  extern struct device_node *of_aliases;
>  extern rwlock_t devtree_lock;
>  
>  static inline bool of_have_populated_dt(void)
>  {
> -	return allnodes != NULL;
> +	return of_allnodes != NULL;
>  }
>  
>  static inline bool of_node_is_root(const struct device_node *node)



-- 
~Randy
