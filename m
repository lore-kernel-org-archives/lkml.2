Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0LGPL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:11:59 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:63363 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579Ab0LGPL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:11:57 -0500
Message-ID: <4CFE4EAC.9000606@metafoo.de>
Date: Tue, 07 Dec 2010 16:11:40 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [RFC v1 PATCH 3/6] led: pmic8058: Add PMIC8058 leds driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-4-git-send-email-tsoni@codeaurora.org> <4CDB0451.3090303@metafoo.de> <4CDBDE5D.4040801@codeaurora.org> <4CFCE8B7.8080305@codeaurora.org>
In-Reply-To: <4CFCE8B7.8080305@codeaurora.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 02:44 PM, Trilok Soni wrote:
> Hi Peter,
> 
>>
>>>> +
>>>> +/**
>>>> + * struct pmic8058_led - per led data
>>>> + * @name - name of the led
>>>> + * @default_trigger - default trigger which needs to e attached
>>>> + * @max_brightness - maximum brightness level supported by the led
>>>> + * @id - supported led id
>>>> + */
>>>> +struct pmic8058_led {
>>>> +	const char	*name;
>>>> +	const char	*default_trigger;
>>>> +	unsigned	max_brightness;
>>> Should max_brightness not rather be hardcoded in the driver? As far as I can tell it
>>> depend on the hardware and is 4 bits wide for flash and bl leds and 5 bits for the
>>> others.
>>>> +	int		id;
>>>
>>> enum pmic8058_leds instead of int
>>
>> Ack.
>>
>>>> +struct pmic8058_leds_platform_data {
>>>> +	int			num_leds;
>>> size_t
>>
>> Ack.
>>
>>>> +	struct pmic8058_led	*leds;
>>>> +};
>>>
>>>
>>> If max_brightness is hardcoded in the driver you can reuse "struct led_info" and
>>> "struct struct led_platform_data" instead of adding your own structs.
>>
> 
> I couldn't remove these pmic8058_led structure due to the "enum pmic8058_led id" member
> info which I need from every led. This can be removed completely only if I abuse
> the "flags" parameter in struct led_info to pass the led id. Let me know what you think.
> 
> ---Trilok Soni
> 

Hi

I think that would be ok, other drivers seem to do the same.

- Lars
