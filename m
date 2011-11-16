Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab1KPRMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:12:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40684 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab1KPRMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:12:15 -0500
Date: Wed, 16 Nov 2011 17:12:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 5/7] regmap: Check if a register is writable instead of
 readable in regcache_read
Message-ID: <20111116171213.GR29986@opensource.wolfsonmicro.com>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-5-git-send-email-lars@metafoo.de>
 <20111116161631.GK29986@opensource.wolfsonmicro.com>
 <4EC3E619.70503@metafoo.de>
 <20111116163812.GM29986@opensource.wolfsonmicro.com>
 <4EC3EA61.2000705@metafoo.de>
 <20111116165622.GP29986@opensource.wolfsonmicro.com>
 <4EC3EE32.2090007@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC3EE32.2090007@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 06:09:06PM +0100, Lars-Peter Clausen wrote:
> On 11/16/2011 05:56 PM, Mark Brown wrote:

> > No, really - just do something legible and robust.  For example, teach
> > regmap_readable() about the cache.

> Doesn't make much sense. We call regmap_readable from regcache_read, which
> is only called if we use a cache. So if we let regmap_readable return true
> in case we use a cache it will always be true in regcache_read and we can
> drop the check entirely.

We should at least check that we actually have a cached value there -
the cache is sparse after all.
