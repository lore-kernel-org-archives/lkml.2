Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1JMScq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:32:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63563 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab1JMSco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:32:44 -0400
Date: Thu, 13 Oct 2011 12:32:40 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rajendra Nayak <rnayak@ti.com>
Cc: broonie@opensource.wolfsonmicro.com, b-cousson@ti.com, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/5] dt: add empty dt helpers for non-dt build
Message-ID: <20111013183240.GM18574@ponder.secretlab.ca>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-3-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318263578-7407-3-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:49:35PM +0530, Rajendra Nayak wrote:
> Add empty of_device_is_compatible(), of_find_property()
> and of_parse_phandle() for non-dt builds to work.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>

Applied, thanks.  The of_find_property() already had an empty version
in devicetree/next, but I've picked up the other two.

g.

> ---
>  include/linux/of.h |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 9180dc5..47ce461 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -263,6 +263,25 @@ static inline const void *of_get_property(const struct device_node *node,
>  	return NULL;
>  }
>  
> +static inline int of_device_is_compatible(const struct device_node *device,
> +				   const char *name)
> +{
> +	return 0;
> +}
> +
> +static inline struct property *of_find_property(const struct device_node *np,
> +					 const char *name,
> +					 int *lenp)
> +{
> +	return NULL;
> +}
> +
> +static inline struct device_node *of_parse_phandle(struct device_node *np,
> +					    const char *phandle_name,
> +					    int index)
> +{
> +	return NULL;
> +}
>  #endif /* CONFIG_OF */
>  
>  static inline int of_property_read_u32(const struct device_node *np,
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
