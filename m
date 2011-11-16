Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1KPQYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:24:51 -0500
Received: from smtp-out-055.synserver.de ([212.40.185.55]:1114 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756020Ab1KPQYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:49 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17751
Message-ID: <4EC3E3FB.3050305@metafoo.de>
Date: Wed, 16 Nov 2011 17:25:31 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 3/7] regmap: Properly round cache_word_size
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-3-git-send-email-lars@metafoo.de> <20111116161420.GJ29986@opensource.wolfsonmicro.com>
In-Reply-To: <20111116161420.GJ29986@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 05:14 PM, Mark Brown wrote:
> On Wed, Nov 16, 2011 at 04:28:18PM +0100, Lars-Peter Clausen wrote:
> 
>> +	if (config->val_bits <= 8)
>> +		map->cache_word_size = 1;
>> +	else if (config->val_bits <= 16)
>> +		map->cache_word_size = 2;
>> +	else
>> +		return -EINVAL;
> 
> Just do val_bits + 7 if you're going to do this.

This won't work once we add support for a value bit-width of more than 16
bit. But I can use DIV_ROUND_UP for this patch and we change it once we add
support for 32 bit cache word size.
