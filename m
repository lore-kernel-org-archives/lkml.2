Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1HIR1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:27:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44011 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1HIR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:27:53 -0400
Date: Tue, 9 Aug 2011 11:27:48 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: devicetree-discuss@lists.ozlabs.org, Ben Dooks <ben-i2c@fluff.org>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, John Bonesio <bones@secretlab.ca>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH] dt: add empty of_get_property for non-dt
Message-ID: <20110809172748.GA32195@ponder.secretlab.ca>
References: <1312584630-23371-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312584630-23371-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 04:50:30PM -0600, Stephen Warren wrote:
> The patch adds empty function of_get_property for non-dt build, so that
> drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> 
> This also fixes the current Tegra compile problem in linux-next.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  include/linux/of.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)

Merged, thanks.

g.

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
> -- 
> 1.7.0.4
> 
