Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GZOAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:00:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38516 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2GZOAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:00:21 -0400
Message-ID: <50114D71.9060700@linaro.org>
Date: Thu, 26 Jul 2012 15:00:17 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-21-git-send-email-lee.jones@linaro.org> <20120726115055.GD3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726115055.GD3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 12:50, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 11:28:53AM +0100, Lee Jones wrote:
>
>>   drivers/mfd/ab8500-core.c               |    1 +
>>   include/linux/mfd/abx500/ab8500-codec.h |    6 ++-
>>   sound/soc/codecs/ab8500-codec.c         |   79 +++++++++++++++++++++++++++++++
>>   3 files changed, 84 insertions(+), 2 deletions(-)
>
> Yet again no binding documentation....

RFC. ;)

I'll write the documentation when/if the properties are accepted.

>>   	{
>>   		.name = "ab8500-codec",
>> +		.of_compatible = "stericsson,ab8500-codec",
>>   	},
>
> Why are we doing this?  The MFD cells are a totally Linux specific
> thing, there's no reason to represent them in the device tree unless
> they're in some way reusable and the "ab8500-codec" name suggests that's
> unlikely.  Just put the properties on the parent node and instantiate
> the MFD cell as normal.
>
>> +	/* Has a non-standard Vamic been requested? */
>> +	if(of_get_property(np, "stericsson,amic1a-bias-vamic2", NULL))
>
> Coding style.

Missing space? Sorry, typo, I'll change.

>> +	if (!of_property_read_u32(np, "stericsson,earpeice-cmv", &value)) {
>> +		switch (value) {
>> +		case 950 :
>> +			codec->ear_cmv = EAR_CMV_0_95V;
>> +			break;
>> +		case 1100 :
>> +			codec->ear_cmv = EAR_CMV_1_10V;
>> +			break;
>> +		case 1270 :
>> +			codec->ear_cmv = EAR_CMV_1_27V;
>> +			break;
>> +		case 1580 :
>> +			codec->ear_cmv = EAR_CMV_1_58V;
>> +			break;
>> +		default :
>> +			codec->ear_cmv = EAR_CMV_UNKNOWN;
>> +			dev_err(dev, "Unsuitable earpiece voltage found in DT\n");
>
> The platform data code picks a default, can't the DT code do the same?

No, I don't think that it does? The original code returns -EINVAL unless 
a value is specified.

The original author is keen to have a clear error message in case users 
try to specify non-exact values. I'd rather we fail-out than use 
incorrect values which would be a great deal harder for a user to debug.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
