Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1IVR3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:29:51 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43735 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1IVR3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:29:50 -0400
Date: Thu, 22 Sep 2011 11:29:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt: add empty for_each_child_of_node, of_find_property
Message-ID: <20110922172944.GM17168@ponder.secretlab.ca>
References: <1316632990-12876-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316632990-12876-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:23:10PM -0600, Stephen Warren wrote:
> The patch adds a couple empty functions for non-dt build, so that
> drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---

Applied, thanks.

g.

> Unfortunately, I screwed up and my recent sdhci-tegra.c changes rely on this
> change to compile without CONFIG_OF; I really need to stop doing my test-
> builds in a single branch will all my outstanding changes present:-(
> 
>  include/linux/of.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 9180dc5..1fc5875 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -242,6 +242,16 @@ static inline bool of_have_populated_dt(void)
>  	return false;
>  }
>  
> +#define for_each_child_of_node(parent, child) \
> +	while (0)
> +
> +static inline struct property *of_find_property(const struct device_node *np,
> +						const char *name,
> +						int *lenp)
> +{
> +	return NULL;
> +}
> +
>  static inline int of_property_read_u32_array(const struct device_node *np,
>  					     const char *propname,
>  					     u32 *out_values, size_t sz)
> -- 
> 1.7.0.4
> 
