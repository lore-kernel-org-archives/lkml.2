Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1I1Mww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:52:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36445 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab1I1Mwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:52:51 -0400
Date: Wed, 28 Sep 2011 13:52:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/7] regmap: Add a mutex to guard the sync operation
Message-ID: <20110928125249.GH3279@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1317206627-6673-3-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317206627-6673-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:43:43AM +0100, Dimitris Papastamos wrote:

> +	mutex_lock(&map->sync_lock);
>  	dev_dbg(map->dev, "Syncing %s cache\n",
>  		map->cache_ops->name);
>  	name = map->cache_ops->name;
> @@ -254,6 +257,7 @@ int regcache_sync(struct regmap *map)
>  	}
>  out:
>  	trace_regcache_sync(map->dev, name, "stop");
> +	mutex_unlock(&map->sync_lock);

Shouldn't we either be taking the regmap lock when doing the sync or
otherwise guarding against something other than a cache sync?
