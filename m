Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab1KPRQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:16:05 -0500
Received: from smtp-out-055.synserver.de ([212.40.185.55]:1126 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1757334Ab1KPRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:15:04 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14958
Message-ID: <4EC3EFB3.9080205@metafoo.de>
Date: Wed, 16 Nov 2011 18:15:31 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 5/7] regmap: Check if a register is writable instead of
 readable in regcache_read
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-5-git-send-email-lars@metafoo.de> <20111116161631.GK29986@opensource.wolfsonmicro.com> <4EC3E619.70503@metafoo.de> <20111116163812.GM29986@opensource.wolfsonmicro.com> <4EC3EA61.2000705@metafoo.de> <20111116165622.GP29986@opensource.wolfsonmicro.com> <4EC3EE32.2090007@metafoo.de> <20111116171213.GR29986@opensource.wolfsonmicro.com>
In-Reply-To: <20111116171213.GR29986@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 06:12 PM, Mark Brown wrote:
> On Wed, Nov 16, 2011 at 06:09:06PM +0100, Lars-Peter Clausen wrote:
>> On 11/16/2011 05:56 PM, Mark Brown wrote:
> 
>>> No, really - just do something legible and robust.  For example, teach
>>> regmap_readable() about the cache.
> 
>> Doesn't make much sense. We call regmap_readable from regcache_read, which
>> is only called if we use a cache. So if we let regmap_readable return true
>> in case we use a cache it will always be true in regcache_read and we can
>> drop the check entirely.
> 
> We should at least check that we actually have a cached value there -
> the cache is sparse after all.

That's what the cache already does today, you recently change the rbtree
implementation to return -ENOENT if there is no cached value.
