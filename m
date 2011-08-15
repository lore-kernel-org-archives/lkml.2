Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1HOFpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:45:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1HOFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:45:53 -0400
Date: Sun, 14 Aug 2011 22:43:41 -0700 (PDT)
Message-Id: <20110814.224341.2228974983062837890.davem@davemloft.net>
To: shawn.guo@linaro.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, patches@linaro.org
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313371817-5135-1-git-send-email-shawn.guo@linaro.org>
References: <1313371817-5135-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 14 Aug 2011 22:43:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>
Date: Mon, 15 Aug 2011 09:30:17 +0800

>  	*allnextp = NULL;
>  
> +	/* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
> +	of_chosen = of_find_node_by_path("/chosen");
> +	if (of_chosen == NULL)
> +		of_chosen = of_find_node_by_path("/chosen@0");
> +	of_aliases = of_find_node_by_path("/aliases");
> +	of_alias_scan(dt_alloc);
> +
>  	pr_debug(" <- unflatten_device_tree()\n");
>  }

You need to add invocations of the scan to other places in the
tree that build the in-kernel device tree.
