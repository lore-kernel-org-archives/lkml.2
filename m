Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1HGOiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 10:38:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57278 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1HGOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 10:37:58 -0400
Message-ID: <4E3EA340.2010100@gmail.com>
Date: Sun, 07 Aug 2011 09:37:52 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>, Ben Dooks <ben-i2c@fluff.org>
Subject: Re: [PATCH] dt: add empty of_get_property for non-dt
References: <1312584630-23371-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1312584630-23371-1-git-send-email-swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 05:50 PM, Stephen Warren wrote:
> The patch adds empty function of_get_property for non-dt build, so that
> drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> 
> This also fixes the current Tegra compile problem in linux-next.
> 
You could just use of_property_read_u32 in the driver. It already has
empty version and will simplify the driver code some.

Rob

> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  include/linux/of.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 0085bb0..9180dc5 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -256,6 +256,13 @@ static inline int of_property_read_string(struct device_node *np,
>  	return -ENOSYS;
>  }
>  
> +static inline const void *of_get_property(const struct device_node *node,
> +				const char *name,
> +				int *lenp)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_OF */
>  
>  static inline int of_property_read_u32(const struct device_node *np,

