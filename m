Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1KPQiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:38:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59087 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab1KPQiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:38:15 -0500
Date: Wed, 16 Nov 2011 16:38:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 5/7] regmap: Check if a register is writable instead of
 readable in regcache_read
Message-ID: <20111116163812.GM29986@opensource.wolfsonmicro.com>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-5-git-send-email-lars@metafoo.de>
 <20111116161631.GK29986@opensource.wolfsonmicro.com>
 <4EC3E619.70503@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC3E619.70503@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 05:34:33PM +0100, Lars-Peter Clausen wrote:
> On 11/16/2011 05:16 PM, Mark Brown wrote:

> > This logic doesn't entirely follow - one can have registers which are
> > volatile but could be read once at startup.  Plus...

> Hm? The use case here is chips which do not support readback. So we never
> want to fallback to a hardware read but still want to be able to do a cached
> read.

This code will be run on every chip, including chips with read/write
access.  Caches are useful for all chips.

> >> @@ -206,7 +206,7 @@ int regcache_read(struct regmap *map,

> >>  	BUG_ON(!map->cache_ops);

> >> -	if (!regmap_readable(map, reg))
> >> +	if (!regmap_writeable(map, reg))
> >>  		return -EIO;

> > ...the code winds up just looking like an obvious bug.

> Why? If a register is not writable we won't have anything in the cache for
> it. So reading from the cache for a register which is not writable doesn't
> make any sense.

If you're looking at the read function and it's checking to see if the
register is writeable the first thought would be that this is a
cut'n'paste error.  The above code is at best *way* too cute.
