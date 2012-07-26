Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2GZPBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:01:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61681 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GZPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:01:21 -0400
Message-ID: <50115BBA.2020400@linaro.org>
Date: Thu, 26 Jul 2012 16:01:14 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-21-git-send-email-lee.jones@linaro.org> <20120726115055.GD3099@opensource.wolfsonmicro.com> <50114D71.9060700@linaro.org> <20120726142825.GK3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726142825.GK3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 15:28, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 03:00:17PM +0100, Lee Jones wrote:
>> On 26/07/12 12:50, Mark Brown wrote:
>
>>> Yet again no binding documentation....
>
>> RFC. ;)
>
>> I'll write the documentation when/if the properties are accepted.
>
> No, write the documentation.  It's way too much effort to reverse
> engineer the bindings from the code.
>
>>>> +		default :
>>>> +			codec->ear_cmv = EAR_CMV_UNKNOWN;
>>>> +			dev_err(dev, "Unsuitable earpiece voltage found in DT\n");
>
>>> The platform data code picks a default, can't the DT code do the same?
>
>> No, I don't think that it does? The original code returns -EINVAL
>> unless a value is specified.
>
> The code doesn't specify values for the enumeration so it ought to
> default to EAR_CMV_0_95V if nothing is specified.

Ah, I see what you mean. I guess we could compromise and print a warning 
_and_ fall back to the 0th original emum.

>> The original author is keen to have a clear error message in case
>> users try to specify non-exact values. I'd rather we fail-out than
>> use incorrect values which would be a great deal harder for a user
>> to debug.
>
> By that argument all the properties should be mandatory but it's only
> this one IIRC.

This is the only value which the user can pick an obscure value, such as 
913, thinking they can pick 913mV. I'm happy to fall-back, as long as 
Ola is too.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
