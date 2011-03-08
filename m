Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1CHM71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:59:27 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:47058 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593Ab1CHM70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:59:26 -0500
Message-ID: <4D762811.7050104@stericsson.com>
Date: Tue, 8 Mar 2011 13:58:57 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: add a core driver for TI TPS61050/TPS61052 chips
References: <1299577241-31328-1-git-send-email-linus.walleij@stericsson.com> <20110308115222.GB20944@opensource.wolfsonmicro.com>
In-Reply-To: <20110308115222.GB20944@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 12:52 PM, Mark Brown wrote:
> On Tue, Mar 08, 2011 at 10:40:41AM +0100, Linus Walleij wrote:
>
>    
>> +config TPS6105X
>> +	tristate "TPS61050/61052 Boost Converters"
>> +	depends on I2C&&  EXPERIMENTAL
>>      
> Why EXPERIMENTAL?
>    

No real reason, I'll drop it.

> +	default y if MACH_U8500
>    
> Not sure I'm enthusiastic about that - it's sensible for the machine to
> want that but I can see this getting out of hand if you've got a lot of
> machines doing that.  Perhaps have the machine select the regulator for
> builds with REGULATOR enabled?
>    

OK I'll move this over to the mach-ux500 patch using
select.

>> +	/* Put the chip in SHUTDOWN mode */
>> +	ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
>> +		TPS6105X_REG0_MODE_MASK,
>> +		TPS6105X_REG0_MODE_SHUTDOWN<<  TPS6105X_REG0_MODE_SHIFT);
>> +	if (ret)
>> +		return ret;
>>      
> I'm not sure this is what we want.  If the device is driving the
> backlight it'll result in the backlight flashing off during boot which
> doesn't seem desirable.  The standard thing is just to inherit the
> hardware state.
>    

It's a leftover from code that was toggling the mode to see if
the hardware was there (it was reflected in another register).

I'll take it out.

Thanks,
Linus Walleij
