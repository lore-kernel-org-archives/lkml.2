Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1LTS4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:56:45 -0500
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:49004 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1LTS4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:56:38 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Dec 2011 13:56:38 EST
Message-ID: <4EF0D8D0.1020505@gmail.com>
Date: Tue, 20 Dec 2011 12:49:52 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        shawn.guo@freescale.com
Subject: Re: [PATCH 1/1] dt: reform for_each_property to for_each_property_of_node_of_node
References: <1324403518-3462-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1324403518-3462-1-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/20/2011 11:51 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Make this micro more easy to use(do not need to pass properties, a node is

Make this macro easier to use...

> enough), also change to a more sensible name as for_each_child_of_node.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> ---
>  drivers/of/base.c  |    2 +-
>  include/linux/of.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 9b6588e..f6f6fe8 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1159,7 +1159,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  	if (!of_aliases)
>  		return;
>  
> -	for_each_property(pp, of_aliases->properties) {
> +	for_each_property_of_node(of_aliases, pp) {
>  		const char *start = pp->name;
>  		const char *end = start + strlen(start);
>  		struct device_node *np;
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 4948552..f1a490c 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -219,8 +219,8 @@ extern int of_device_is_available(const struct device_node *device);
>  extern const void *of_get_property(const struct device_node *node,
>  				const char *name,
>  				int *lenp);
> -#define for_each_property(pp, properties) \
> -	for (pp = properties; pp != NULL; pp = pp->next)
> +#define for_each_property_of_node(dn, pp) \
> +	for (pp = dn->properties; pp != NULL; pp = pp->next)

Probably should prepend it with "of_" while you're at it.

Rob
