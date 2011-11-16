Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab1KPQOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:14:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47966 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893Ab1KPQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:14:22 -0500
Date: Wed, 16 Nov 2011 16:14:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 3/7] regmap: Properly round cache_word_size
Message-ID: <20111116161420.GJ29986@opensource.wolfsonmicro.com>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321457302-8724-3-git-send-email-lars@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 04:28:18PM +0100, Lars-Peter Clausen wrote:

> +	if (config->val_bits <= 8)
> +		map->cache_word_size = 1;
> +	else if (config->val_bits <= 16)
> +		map->cache_word_size = 2;
> +	else
> +		return -EINVAL;

Just do val_bits + 7 if you're going to do this.
