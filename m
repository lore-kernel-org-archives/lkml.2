Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2AGKsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 05:48:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38885 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2AGKse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 05:48:34 -0500
MIME-Version: 1.0
In-Reply-To: <001401cccc19$25b52920$711f7b60$%han@samsung.com>
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
	<001401cccc19$25b52920$711f7b60$%han@samsung.com>
Date: Sat, 7 Jan 2012 16:18:33 +0530
Message-ID: <CAJuYYwR9vCohqW91p6_fPw39h-yuxN7cfvhM6s=9bnzPyDKgBQ@mail.gmail.com>
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
 gpio controlled panel reset
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        kyungmin.park@samsung.com, cbou@mail.ru, kwangwoo.lee@gmail.com,
        augulis.darius@gmail.com, ben-linux@fluff.org, lars@metafoo.de,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Han,

On 6 January 2012 07:46, Jingoo Han <jg1.han@samsung.com> wrote:
> Hi, Thomas.
[...]

>>  obj-$(CONFIG_LCD_PLATFORM)      += platform_lcd.o
>> +obj-$(CONFIG_LCD_PWRCTRL)       += lcd_pwrctrl.o
> Can you remove unnecessary space?
> Please use <tab><space><space><space> instead of <space><tab><space><space><space>
> between PWRCTRL) and += lcd_.

Ok. I will fix that.

>> [...]
>> +static struct platform_driver lcd_pwrctrl_driver = {
>> +     .driver         = {
>> +             .name   = "lcd-pwrctrl",
>> +             .owner  = THIS_MODULE,
>> +             .of_match_table = of_match_ptr(lcd_pwrctrl_match),
>> +     },
>> +     .probe          = lcd_pwrctrl_probe,
>> +     .remove         = lcd_pwrctrl_remove,
>> +     .suspend        = lcd_pwrctrl_suspend,
>> +     .resume         = lcd_pwrctrl_resume,
> Please use 'struct dev_pm_ops'.

Ok.

>> +};
>> +
>> +static int __init lcd_pwrctrl_init(void)
>> +{
>> +     return platform_driver_register(&lcd_pwrctrl_driver);
>> +}
>> +
>> +static void __exit lcd_pwrctrl_cleanup(void)
>> +{
>> +     platform_driver_unregister(&lcd_pwrctrl_driver);
>> +}
>> +
>> +module_init(lcd_pwrctrl_init);
>> +module_exit(lcd_pwrctrl_cleanup);
> Use module_platform_driver(lcd_pwrctrl_driver).
> It can make the code simpler.

Ok. Thanks for your review Mr. Han. I will do the required changes.

Regards,
Thomas.
