Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0LFNo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:44:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27763 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0LFNo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:44:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6188"; a="65452452"
Message-ID: <4CFCE8B7.8080305@codeaurora.org>
Date: Mon, 06 Dec 2010 19:14:23 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [RFC v1 PATCH 3/6] led: pmic8058: Add PMIC8058 leds driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-4-git-send-email-tsoni@codeaurora.org> <4CDB0451.3090303@metafoo.de> <4CDBDE5D.4040801@codeaurora.org>
In-Reply-To: <4CDBDE5D.4040801@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> 
>>> +
>>> +/**
>>> + * struct pmic8058_led - per led data
>>> + * @name - name of the led
>>> + * @default_trigger - default trigger which needs to e attached
>>> + * @max_brightness - maximum brightness level supported by the led
>>> + * @id - supported led id
>>> + */
>>> +struct pmic8058_led {
>>> +	const char	*name;
>>> +	const char	*default_trigger;
>>> +	unsigned	max_brightness;
>> Should max_brightness not rather be hardcoded in the driver? As far as I can tell it
>> depend on the hardware and is 4 bits wide for flash and bl leds and 5 bits for the
>> others.
>>> +	int		id;
>>
>> enum pmic8058_leds instead of int
> 
> Ack.
> 
>>> +struct pmic8058_leds_platform_data {
>>> +	int			num_leds;
>> size_t
> 
> Ack.
> 
>>> +	struct pmic8058_led	*leds;
>>> +};
>>
>>
>> If max_brightness is hardcoded in the driver you can reuse "struct led_info" and
>> "struct struct led_platform_data" instead of adding your own structs.
> 

I couldn't remove these pmic8058_led structure due to the "enum pmic8058_led id" member
info which I need from every led. This can be removed completely only if I abuse
the "flags" parameter in struct led_info to pass the led id. Let me know what you think.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
