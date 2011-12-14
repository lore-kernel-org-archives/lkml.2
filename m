Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1LNQCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:02:47 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45879 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1LNQCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:02:46 -0500
MIME-Version: 1.0
In-Reply-To: <1323876538-20406-2-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-2-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 09:02:24 -0700
X-Google-Sender-Auth: eD7WDGoDF4KuOcjb_O06U7cBQLc
Message-ID: <CACxGe6vNaQtd5FtTWbYpH_Hwfp7OgMfOcBYuDEDULJ3XnYdL9g@mail.gmail.com>
Subject: Re: [PATCH 1/9] dt: add empty of_get_node/of_put_node functions
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 8:28 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Add empty of_get_node/of_put_node functions for !CONFIG_OF builds.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Looks good.

> ---
>  include/linux/of.h |   29 ++++++++++++++---------------
>  1 files changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 4948552..e291381 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -65,6 +65,20 @@ struct device_node {
>  #endif
>  };
>
> +#if defined(CONFIG_SPARC) || !defined(CONFIG_OF)
> +/* Dummy ref counting routines - to be implemented later */
> +static inline struct device_node *of_node_get(struct device_node *node)
> +{
> +       return node;
> +}
> +static inline void of_node_put(struct device_node *node)
> +{
> +}
> +#else
> +extern struct device_node *of_node_get(struct device_node *node);
> +extern void of_node_put(struct device_node *node);
> +#endif
> +
>  #ifdef CONFIG_OF
>
>  /* Pointer for first entry in chain of all nodes. */
> @@ -95,21 +109,6 @@ static inline void of_node_set_flag(struct device_node *n, unsigned long flag)
>
>  extern struct device_node *of_find_all_nodes(struct device_node *prev);
>
> -#if defined(CONFIG_SPARC)
> -/* Dummy ref counting routines - to be implemented later */
> -static inline struct device_node *of_node_get(struct device_node *node)
> -{
> -       return node;
> -}
> -static inline void of_node_put(struct device_node *node)
> -{
> -}
> -
> -#else
> -extern struct device_node *of_node_get(struct device_node *node);
> -extern void of_node_put(struct device_node *node);
> -#endif
> -
>  /*
>  * OF address retrieval & translation
>  */
> --
> 1.7.5.4
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
