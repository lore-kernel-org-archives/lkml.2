Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032Ab1JGJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:57:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34285 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759802Ab1JGJ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:57:23 -0400
Date: Fri, 7 Oct 2011 10:57:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 01/11 RESEND] ASoC: wm8510: Convert to snd_soc_write
Message-ID: <20111007095720.GA19080@opensource.wolfsonmicro.com>
References: <1317944619.5579.1.camel@phoenix>
 <1317944707.5579.3.camel@phoenix>
 <1317955220.7624.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317955220.7624.2.camel@phoenix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:40:20AM +0800, Axel Lin wrote:

> +static void wm8510_sync_cache(struct snd_soc_codec *codec)
> +{
> +	short i;
> +	u16 *cache;
> +
> +	if (!codec->cache_sync)
> +		return;
> +	codec->cache_only = 0;
> +	codec->cache_bypass = 1;
> +	/* restore cache */
> +	cache = codec->reg_cache;
> +	for (i = 0; i < codec->driver->reg_cache_size; i++) {
> +		if (i == WM8510_RESET || cache[i] == wm8510_reg[i])
> +			continue;
> +		snd_soc_write(codec, i, cache[i]);
> +	}
> +	codec->cache_bypass = 0;
> +	codec->cache_sync = 0;

The usual trick for avoiding this is to provide a register default value
for the reset register and then write that value when the chip is reset.
This then means that the write to the reset register is suppressed by
the cache restore code when it skips writes of default registers.

Thanks for doing this work.
