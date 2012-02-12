Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2BLUWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 15:22:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35295 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573Ab2BLUWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 15:22:18 -0500
Message-ID: <4F381F6C.1030908@gmail.com>
Date: Sun, 12 Feb 2012 14:22:04 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Dong Aisheng <dong.aisheng@linaro.org>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/1] dt: add of_get_child_count helper function
References: <1328980929-5423-1-git-send-email-dong.aisheng@linaro.org>
In-Reply-To: <1328980929-5423-1-git-send-email-dong.aisheng@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 11:22 AM, Dong Aisheng wrote:
> Currently most code to get child count in kernel are almost same,
> add a helper to implement this function for dt to use.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> 
> ---
> Hi Rob,
> 
> Since my imx pinctrl driver series still depends on the pinctrl core dt
> binding patch which is still not in mainline, i'd like this pure dt patch
> go separately first in case others want to use.
> 

Applied for 3.4.

Rob

> changes v2->v3:
>  Addressed some people's comments:
>  * do not use assignment as expression
>  * return 0 for non-dt case
> 
> Changes v1->v2:
>  * change the name from of_get_child_number to of_get_child_count
> ---
>  include/linux/of.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index a75a831..ae242ef 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -195,6 +195,17 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
>  	for (child = of_get_next_child(parent, NULL); child != NULL; \
>  	     child = of_get_next_child(parent, child))
>  
> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	struct device_node *child = NULL;
> +	int num = 0;
> +
> +	while ((child = of_get_next_child(np, child)) != NULL)
> +		num++;
> +
> +	return num;
> +}
> +
>  extern struct device_node *of_find_node_with_property(
>  	struct device_node *from, const char *prop_name);
>  #define for_each_node_with_property(dn, prop_name) \
> @@ -268,6 +279,11 @@ static inline bool of_have_populated_dt(void)
>  #define for_each_child_of_node(parent, child) \
>  	while (0)
>  
> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	return 0;
> +}
> +
>  static inline int of_device_is_compatible(const struct device_node *device,
>  					  const char *name)
>  {

