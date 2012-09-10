Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2IJHNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:13:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41648 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2IJHNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:13:17 -0400
Message-ID: <504D9308.2080708@gmail.com>
Date: Mon, 10 Sep 2012 16:13:12 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] backlight: add new lm3639 backlight driver
References: <1347246964-28332-1-git-send-email-gshark.jeong@gmail.com> <504D7A8E.1090005@xenotime.net>
In-Reply-To: <504D7A8E.1090005@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


LM3639 has not only pins for backlihgt but also pins for LEDs. So it 
uses functions in led_class and led_core file.
When I see your config file, "randconig", you set CONFIG_NEW_LEDS=y but 
you didn't set CONFIG_LEDS_CLASS.
We need to set CONFIG_NEW_LEDS and CONFIG_LEDS_CLASS both to compile it.
To fix it, I added  two reverse dependencies "select NEW_LEDS" and 
"select CONFIG_LEDS_CLASS".

2012년 09월 10일 14:28, Randy Dunlap 쓴 글:
> On 09/09/2012 08:16 PM, G.Shark Jeong wrote:
>
>> From: "G.Shark Jeong" <gshark.jeong@gmail.com>
>>
>> This driver is a general version for LM3639 backlgiht driver chip of TI.
>>
>> Put NEW_LEDS and LEDS_CLASS into Kconfig file to reduce additional configuration works in LEDs.
>>
>> www.ti.com
>
> eh?
>
>> Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
>
> Linus has asked patch committers to use Reported-by when appropriate.
>
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>
>
>> ---
>>   drivers/video/backlight/Kconfig |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
>> index 2ed68bd..e6c78cd 100644
>> --- a/drivers/video/backlight/Kconfig
>> +++ b/drivers/video/backlight/Kconfig
>> @@ -356,6 +356,8 @@ config BACKLIGHT_LM3639
>>   	tristate "Backlight Driver for LM3639"
>>   	depends on BACKLIGHT_CLASS_DEVICE && I2C
>>   	select REGMAP_I2C
>> +	select NEW_LEDS
>> +	select LEDS_CLASS
>>   	help
>>   	  This supports TI LM3639 Backlight + 1.5A Flash LED Driver
>>   
>
>

