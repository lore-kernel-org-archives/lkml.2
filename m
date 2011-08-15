Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1HOGiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:38:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52781 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1HOGiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:38:07 -0400
Date: Sun, 14 Aug 2011 23:35:59 -0700 (PDT)
Message-Id: <20110814.233559.1395275660949133114.davem@davemloft.net>
To: shawn.guo@freescale.com
Cc: shawn.guo@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110815063643.GI7244@S2100-06.ap.freescale.net>
References: <20110815060708.GH7244@S2100-06.ap.freescale.net>
	<20110814.230529.611834234177280886.davem@davemloft.net>
	<20110815063643.GI7244@S2100-06.ap.freescale.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 14 Aug 2011 23:36:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Guo <shawn.guo@freescale.com>
Date: Mon, 15 Aug 2011 14:36:44 +0800

> @@ -245,4 +245,11 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
>         nextp = &allnodes->allnext;
>         allnodes->child = of_pdt_build_tree(allnodes,
>                         of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
> +
> +       /* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
> +       of_chosen = of_find_node_by_path("/chosen");
> +       if (of_chosen == NULL)
> +               of_chosen = of_find_node_by_path("/chosen@0");
> +       of_aliases = of_find_node_by_path("/aliases");
> +       of_alias_scan(dt_alloc);
>  }

There is no dt_alloc variable visible in this function.

I didn't need to use a compiler to find this problem, and neither
do you.
