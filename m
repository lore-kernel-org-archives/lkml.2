Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026Ab1JGNKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:10:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:32981 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1JGNKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:10:47 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111007095720.GA19080@opensource.wolfsonmicro.com>
References: <1317944619.5579.1.camel@phoenix> <1317944707.5579.3.camel@phoenix>
 <1317955220.7624.2.camel@phoenix> <20111007095720.GA19080@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 7 Oct 2011 21:10:21 +0800
Message-ID: <CAF+7xWkC5=9etjwde-nLegAEFd4AyzJcXyGUZyp9FWJjaE-fRA@mail.gmail.com>
Subject: Re: [PATCH 01/11 RESEND] ASoC: wm8510: Convert to snd_soc_write
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/7 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Oct 07, 2011 at 10:40:20AM +0800, Axel Lin wrote:
>
>> +static void wm8510_sync_cache(struct snd_soc_codec *codec)
>> +{
>> +     short i;
>> +     u16 *cache;
>> +
>> +     if (!codec->cache_sync)
>> +             return;
>> +     codec->cache_only = 0;
>> +     codec->cache_bypass = 1;
>> +     /* restore cache */
>> +     cache = codec->reg_cache;
>> +     for (i = 0; i < codec->driver->reg_cache_size; i++) {
>> +             if (i == WM8510_RESET || cache[i] == wm8510_reg[i])
>> +                     continue;
>> +             snd_soc_write(codec, i, cache[i]);
>> +     }
>> +     codec->cache_bypass = 0;
>> +     codec->cache_sync = 0;
>
> The usual trick for avoiding this is to provide a register default value
> for the reset register and then write that value when the chip is reset.
> This then means that the write to the reset register is suppressed by
> the cache restore code when it skips writes of default registers.
>
Nice trick. Then we can use snd_soc_cache_sync() to replace the
customized xxxx_sync_cache() calls.

I'll send a v3 soon.

> Thanks for doing this work.
And thanks for your valuable review.

Regards,
Axel
