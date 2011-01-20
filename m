Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1ATIqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:46:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1ATIqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:46:21 -0500
Message-ID: <4D37F654.70405@corscience.de>
Date: Thu, 20 Jan 2011 09:46:12 +0100
From: Thomas Weber <weber@corscience.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101220 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com
Subject: Re: [PATCHv4 3/4] OMAP3: Devkit8000: Check return value of gpio_request
References: <1295425166-25540-1-git-send-email-weber@corscience.de> <1295425166-25540-4-git-send-email-weber@corscience.de> <4D36D7DC.4020705@ru.mvista.com>
In-Reply-To: <4D36D7DC.4020705@ru.mvista.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:pA2QS4HCwpVtIZfrQjZueIVMDccunIyrSxLLl0HW0+q
 5zIB22IWgRzOrbGfg6FJAY35SpqQCtHWA3KdCzRMlzcxm6VOZ/
 DVF7WksbM+TxDnFeaZFOHWlaa95kGv+Uxy8BPE67d+xeOuT3aw
 moLPXDGxD3+SlGadnXpKAVB757fXEeB5hYMPRvfM9PpIQAvOnS
 9bWAJrPLYyCTjn03f2D5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Am 19.01.2011 13:23, schrieb Sergei Shtylyov:
> Hello.
>
> On 19-01-2011 11:19, Thomas Weber wrote:
>
>> The return value of gpio_request is ignored.
>> This patch adds the check of the return value of gpio_request.
>
>> Signed-off-by: Thomas Weber<weber@corscience.de>
>> ---
>>   arch/arm/mach-omap2/board-devkit8000.c |   16 ++++++++++++++--
>>   1 files changed, 14 insertions(+), 2 deletions(-)
>
>> diff --git a/arch/arm/mach-omap2/board-devkit8000.c
>> b/arch/arm/mach-omap2/board-devkit8000.c
>> index 9fb416b..4ddd81c 100644
>> --- a/arch/arm/mach-omap2/board-devkit8000.c
>> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> [...]
>> @@ -244,13 +246,23 @@ static int devkit8000_twl_gpio_setup(struct
>> device *dev,
>>
>>       /* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
>>       devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
>> -    gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
>> +    ret = gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
>> +    if (ret < 0) {
>> +        printk(KERN_ERR "Failed to request GPIO for LCD_PWRN\n");
>> +        return ret;
>> +    }
>> +
>>       /* Disable until needed */
>>       gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
>>
>>       /* gpio + 7 is "DVI_PD" (out, active low) */
>>       devkit8000_dvi_device.reset_gpio = gpio + 7;
>> -    gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
>> +    ret = gpio_request(devkit8000_dvi_device.reset_gpio, "DVI
>> PowerDown");
>> +    if (ret < 0) {
>> +        printk(KERN_ERR "Failed to request GPIO for DVI PowerDown\n");
>
>    You forgot to call:
>
>         gpio_free(devkit8000_lcd_device.reset_gpio);
>
Couldn't I use lcd without dvi?
And shouldn't the gpio then be set to -EINVAL for the gpio_is_valid()
check in enable_lcd()/disable_lcd() and enable_dvi()/disable_dvi()?

Thomas
>> +        return ret;
>> +    }
>> +
>>       /* Disable until needed */
>>       gpio_direction_output(devkit8000_dvi_device.reset_gpio, 0);
>
> WBR, Sergei
> -- 
>

