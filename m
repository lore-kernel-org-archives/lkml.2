Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2GQAMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 20:12:43 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42080 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab2GQAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 20:12:39 -0400
Date: Mon, 16 Jul 2012 17:12:28 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>, aletes.xgr@gmail.com,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] clk: fix compile for OF && !COMMON_CLK
Message-ID: <20120717001228.GA28886@gmail.com>
References: <1342475161-20402-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342475161-20402-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120716-16:46, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> With commit 766e6a4ec602d0c107 (clk: add DT clock binding support),
> compiling with OF && !COMMON_CLK is broken.
> 

Hi Rob,

Thanks for sending this quickly.

<snip>
> @@ -313,19 +314,19 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
>  struct device_node;
>  struct of_phandle_args;
>  
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>  struct clk *of_clk_get(struct device_node *np, int index);
>  struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
>  struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
>  #else
>  static inline struct clk *of_clk_get(struct device_node *np, int index)
>  {
> -	return NULL;
> +	return ERR_PTR(-EINVAL);

This change seems unrelated?

>  }
>  static inline struct clk *of_clk_get_by_name(struct device_node *np,
>  					     const char *name)
>  {
> -	return NULL;
> +	return ERR_PTR(-EINVAL);

Ditto.

Thanks,
Mike

>  }
>  #endif
>  
> -- 
> 1.7.9.5
> 
