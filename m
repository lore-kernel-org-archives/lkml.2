Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab3AIGfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:35:39 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60484 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3AIGfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:35:38 -0500
Message-ID: <50ED0FB2.4060007@linaro.org>
Date: Wed, 09 Jan 2013 12:05:30 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
CC: mturquette@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: remove unreachable code
References: <1357650191-30842-1-git-send-email-rajagopal.venkat@linaro.org> <1357712988-22317-1-git-send-email-rajagopal.venkat@linaro.org>
In-Reply-To: <1357712988-22317-1-git-send-email-rajagopal.venkat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 11:59 AM, Rajagopal Venkat wrote:
> while reparenting a clock, NULL check is done for clock in
> consideration and its new parent. So re-check is not required.
> If done, else part becomes unreachable.
> 
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> ---

It is good to have revision history of the patches (version number and
changelog).

>  drivers/clk/clk.c |   13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 251e45d..1c4097c 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1040,7 +1040,6 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>  {
>  #ifdef CONFIG_COMMON_CLK_DEBUG
>  	struct dentry *d;
> -	struct dentry *new_parent_d;
>  #endif
>  
>  	if (!clk || !new_parent)
> @@ -1048,22 +1047,14 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>  
>  	hlist_del(&clk->child_node);
>  
> -	if (new_parent)
> -		hlist_add_head(&clk->child_node, &new_parent->children);
> -	else
> -		hlist_add_head(&clk->child_node, &clk_orphan_list);
> +	hlist_add_head(&clk->child_node, &new_parent->children);
>  
>  #ifdef CONFIG_COMMON_CLK_DEBUG
>  	if (!inited)
>  		goto out;
>  
> -	if (new_parent)
> -		new_parent_d = new_parent->dentry;
> -	else
> -		new_parent_d = orphandir;
> -
>  	d = debugfs_rename(clk->dentry->d_parent, clk->dentry,
> -			new_parent_d, clk->name);
> +			new_parent->dentry, clk->name);
>  	if (d)
>  		clk->dentry = d;
>  	else
> 


-- 
Tushar Behera
