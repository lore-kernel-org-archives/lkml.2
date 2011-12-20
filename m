Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab1LTSfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:35:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57971 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1LTSfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:35:06 -0500
Message-ID: <4EF0D556.3030701@gmail.com>
Date: Tue, 20 Dec 2011 12:35:02 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        cjb@laptop.org, w.sang@pengutronix.de
Subject: Re: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
References: <1324402840-32451-1-git-send-email-b29396@freescale.com> <1324402840-32451-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1324402840-32451-2-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 11:40 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Currently most code to get child count in kernel are almost same,
> add a helper to implement this function for dt to use.
> 
> ---
> Changes v1->v2:
>  * change the name from of_get_child_number to of_get_child_count
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>

I assume you want this to go in with the rest of the series? If not, let
me know.

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob

> ---
>  include/linux/of.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 4948552..d0d91a1 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -189,6 +189,17 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
>  	for (child = of_get_next_child(parent, NULL); child != NULL; \
>  	     child = of_get_next_child(parent, child))
>  
> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	struct device_node *child = NULL;
> +	int num = 0;
> +
> +	while ((child = of_get_next_child(np, child)))
> +		num++;
> +
> +	return num;
> +}
> +
>  extern struct device_node *of_find_node_with_property(
>  	struct device_node *from, const char *prop_name);
>  #define for_each_node_with_property(dn, prop_name) \
> @@ -262,6 +273,11 @@ static inline bool of_have_populated_dt(void)
>  #define for_each_child_of_node(parent, child) \
>  	while (0)
>  
> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int of_device_is_compatible(const struct device_node *device,
>  					  const char *name)
>  {
