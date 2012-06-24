Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab2FXRVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 13:21:10 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:58061 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2FXRVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 13:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <4FE4CBB8.1010800@landley.net>
References: <1340323926-6826-1-git-send-email-gshark.jeong@gmail.com>
 <1340323926-6826-2-git-send-email-gshark.jeong@gmail.com> <4FE4CBB8.1010800@landley.net>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 25 Jun 2012 01:20:47 +0800
X-Google-Sender-Auth: CBplIOkLMSwHkFthuosZSk9IH4Y
Message-ID: <CAK5ve-+cXRR7UHOypoA7bTLd0_K7Y5mNgmH3PadTUAW7TNOmdA@mail.gmail.com>
Subject: Re: [PATCH 1/1 v4] leds: Add LED driver for lm3556 chip
To: Rob Landley <rob@landley.net>
Cc: "G.Shark Jeong" <gshark.jeong@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org, milo kim <milo.kim@ti.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 3:47 AM, Rob Landley <rob@landley.net> wrote:
> On 06/21/2012 07:12 PM, G.Shark Jeong wrote:
>> From: "G.Shark Jeong" <gshark.jeong@gmail.com>
>>
>> LM3556 :
>> The LM3556 is a 4 MHz fixed-frequency synchronous boost
>> converter plus 1.5A constant current driver for a high-current white LED.
>> Datasheet: www.national.com/ds/LM/LM3556.pdf
>>
>> Tested on OMAP4430
> ...
>> +Indicator pattern example:
>> +pattern 0: #echo 0 > sys/class/leds/indicator/pattern
>> +....
>> +pattern 3: #echo 3 > sys/class/leds/indicator/pattern
>> +
>> +Indicater brightness can be controlled through
>
> Indicator
>
>> +sys/class/leds/indicator/brightness file.
>> +
>> +Example:
>> +OFF      : #echo 0 > sys/class/leds/indicator/brightness
>> +5.86 mA  : #echo 1 > sys/class/leds/indicator/brightness
>> +........
>> +46.875mA : #echo 8 > sys/class/leds/indicator/brightness
>> +
>> +Notes
>> +-----
>> +Driver expects it is registered using the i2c_board_info mechanism.
>> +Toregister the chip at address 0x63 on specific adapter, set the platform data
>
> To register
>
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -415,6 +415,14 @@ config LEDS_MAX8997
>>         This option enables support for on-chip LED drivers on
>>         MAXIM MAX8997 PMIC.
>>
>> +config LEDS_LM3556
>> +     tristate "LED support for LM3556 Chip"
>> +     depends on LEDS_CLASS && I2C
>> +     select REGMAP_I2C
>> +     help
>> +       This option enables support for LEDs connected LM3556.
>
> connected to
>
> Other than that, documentation bits Acked-by me.
>

No problem. fixed and applied to my for-next branch.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
