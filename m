Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3AIFu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 00:50:27 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47544 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3AIFuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 00:50:25 -0500
Message-ID: <50ED0517.5090907@linaro.org>
Date: Wed, 09 Jan 2013 11:20:15 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
CC: mturquette@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: remove unreachable code
References: <1357650191-30842-1-git-send-email-rajagopal.venkat@linaro.org>
In-Reply-To: <1357650191-30842-1-git-send-email-rajagopal.venkat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 06:33 PM, Rajagopal Venkat wrote:
> while reparenting a clock, NULL check is done for clock in
> consideration and its new parent. So re-check is not required.
> If done, else part becomes unreachable.
> 
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> ---
>  drivers/clk/clk.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 251e45d..f896584 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1048,10 +1048,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
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
> 

The same logic holds good for following piece of code too.

1060 |-------if (new_parent)
1061 |-------|-------new_parent_d = new_parent->dentry;
1062 |-------else
1063 |-------|-------new_parent_d = orphandir;


-- 
Tushar Behera
