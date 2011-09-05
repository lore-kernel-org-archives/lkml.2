Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab1IEQP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 12:15:59 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39059 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072Ab1IEQPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 12:15:54 -0400
Message-ID: <4E64F5B5.9000903@metafoo.de>
Date: Mon, 05 Sep 2011 18:15:49 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/6] regmap: Add the rbtree cache support
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com> <1315230662-12401-4-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1315230662-12401-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 03:50 PM, Dimitris Papastamos wrote:
> [...]
> +
> +static int regcache_rbtree_init(struct regmap *map)
> +{
> +	struct regcache_rbtree_ctx *rbtree_ctx;
> +	int i;
> +	int ret;
> +
> +	map->cache = kmalloc(sizeof *rbtree_ctx, GFP_KERNEL);
> +	if (!map->cache)
> +		return -ENOMEM;
> +
> +	rbtree_ctx = map->cache;
> +	rbtree_ctx->root = RB_ROOT;
> +	rbtree_ctx->cached_rbnode = NULL;
> +
> +	for (i = 0; i < map->num_cache_defaults; i++) {
> +		ret = regcache_rbtree_write(map,
> +					    map->cache_defaults[ret].reg,
> +					    map->cache_defaults[ret].def);

map->cache_defaults[i]

> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	regcache_exit(map);
> +	return ret;
> +}
> [...]
