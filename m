Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2HAHeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:34:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34079 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2HAHeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:34:12 -0400
Message-ID: <5018DBEE.9090203@linaro.org>
Date: Wed, 01 Aug 2012 08:34:06 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Subject: Re: [PATCH 5/6] ARM: ux500: Ensure probing of Audio devices when
 Device Tree is enabled
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-11-git-send-email-lee.jones@linaro.org> <201207312054.13818.arnd@arndb.de>
In-Reply-To: <201207312054.13818.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 21:54, Arnd Bergmann wrote:
> On Tuesday 31 July 2012, Lee Jones wrote:
>> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
>> index e641003..87a5cd7 100644
>> --- a/arch/arm/mach-ux500/board-mop500.c
>> +++ b/arch/arm/mach-ux500/board-mop500.c
>> @@ -794,6 +794,7 @@ static void __init u8500_init_machine(void)
>>                                  ARRAY_SIZE(mop500_platform_devs));
>>
>>                  mop500_sdi_init(parent);
>> +               mop500_msp_init(parent);
>>                  i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
>>                  i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
>>                  i2c_register_board_info(2, mop500_i2c2_devices,
>> @@ -801,6 +802,8 @@ static void __init u8500_init_machine(void)
>>
>>                  mop500_uib_init();
>>
>> +       } else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
>> +               mop500_of_msp_init(parent);
>>          } else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
>>                  /*
>>                   * The HREFv60 board removed a GPIO expander and routed
>> @@ -812,6 +815,7 @@ static void __init u8500_init_machine(void)
>>                                  ARRAY_SIZE(mop500_platform_devs));
>>
>>                  hrefv60_sdi_init(parent);
>> +               mop500_msp_init(parent);
>>
>>                  i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
>>                  i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
>
>
> Looks like you're adding the same call to each of the three cases:
> mop500, snowball and hrefv60+. How about moving it before or after
> the if/elseif block?

The Snowball one is different 'mop500_msp_init' -> 'mop500_of_msp_init'.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
