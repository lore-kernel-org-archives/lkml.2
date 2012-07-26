Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2GZLiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:38:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52974 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2GZLiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:38:21 -0400
Message-ID: <50112C29.6020606@linaro.org>
Date: Thu, 26 Jul 2012 12:38:17 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 07/21] ASoC: io: Prevent use of regmap if request fails
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-8-git-send-email-lee.jones@linaro.org> <20120726113204.GY3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726113204.GY3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 12:32, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 11:28:40AM +0100, Lee Jones wrote:
>
>> @@ -52,10 +52,13 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
>>   		if (codec->cache_only)
>>   			return -1;
>>
>> -		ret = regmap_read(codec->control_data, reg, &val);
>> -		if (ret == 0)
>> -			return val;
>> -		else
>> +		if (codec->using_regmap) {
>> +			ret = regmap_read(codec->control_data, reg, &val);
>> +			if (ret == 0)
>> +				return val;
>> +			else
>> +				return -1;
>> +		} else
>
> No, this makes no sense.  There is no non-regmap I/O support in soc-io,
> anything using the soc-io hw_read() function must be using regmap.
>
>>   	case SND_SOC_REGMAP:
>>   		/* Device has made its own regmap arrangements */
>> -		codec->using_regmap = true;
>
> Again, this makes no sense.  If we're explicitly being asked to use
> regmap then we should be using regmap or just failing to set up I/O
> (which is obviously a catastrophic failure).

How much work is there involved in regmap:ing a device, so that 
dev_get_regmap() doesn't fail?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
