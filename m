Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1LTTrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:47:19 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36564 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1LTTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:47:13 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Date: Tue, 20 Dec 2011 20:47:10 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        w.sang@pengutronix.de, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kernel@pengutronix.de, cjb@laptop.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com
References: <1324402840-32451-1-git-send-email-b29396@freescale.com> <1324402840-32451-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1324402840-32451-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112202047.10308.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> ---
>  include/linux/of.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 4948552..d0d91a1 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -189,6 +189,17 @@ extern struct device_node *of_get_next_child(const
> struct device_node *node, for (child = of_get_next_child(parent, NULL);
> child != NULL; \
>  	     child = of_get_next_child(parent, child))
> 
> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	struct device_node *child = NULL;
> +	int num = 0;
> +
> +	while ((child = of_get_next_child(np, child)))

The assignment in this condition really looks eerie, maybe just rewrite it to do  
{ } while () ? Also, aren't the parenthesis unnecessary?

M
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
>  static inline int of_device_is_compatible(const struct device_node
> *device, const char *name)
>  {
