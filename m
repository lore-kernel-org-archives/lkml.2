Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2GaUyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:54:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2GaUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:54:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/6] ARM: ux500: Ensure probing of Audio devices when Device Tree is enabled
Date: Tue, 31 Jul 2012 20:54:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-11-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1343741493-17671-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207312054.13818.arnd@arndb.de>
X-Provags-ID: V02:K0:HIHhLfwMit3LkTYIK6vKc+Z8vDSGCeHELBS9Rdy9rRl
 TDM/Wheh2mvzBdZkTla59xHPfKFFSebFX08iT7DnBsRcgG1dA1
 9LDrYjmU1z8zTiw0dEmGI7dev1DHXyXHXeNC0E944Jhq3Pz1/D
 F34eStL+6qL9sYp/0vyecnh+pIlQboYD3q6JYd420+7xKbNL6P
 +o5oQG/PYVdmp4rKVAwKj9NoEl0RZnDWcl0BjfhAaB96R5TlGL
 0xZbopEEFM8rZ1bB5eYSa38cHSOZo/wGvJs6XopSxlJ9Q3jSKi
 M84oTlHeND68vlFRuOI78OFCA/z8Cgl7P3hPZ1kH6F3K/kvvqD
 vkVbVxa2ckJXhE9KFF4s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Lee Jones wrote:
> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
> index e641003..87a5cd7 100644
> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -794,6 +794,7 @@ static void __init u8500_init_machine(void)
>                                 ARRAY_SIZE(mop500_platform_devs));
>  
>                 mop500_sdi_init(parent);
> +               mop500_msp_init(parent);
>                 i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
>                 i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
>                 i2c_register_board_info(2, mop500_i2c2_devices,
> @@ -801,6 +802,8 @@ static void __init u8500_init_machine(void)
>  
>                 mop500_uib_init();
>  
> +       } else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
> +               mop500_of_msp_init(parent);
>         } else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
>                 /*
>                  * The HREFv60 board removed a GPIO expander and routed
> @@ -812,6 +815,7 @@ static void __init u8500_init_machine(void)
>                                 ARRAY_SIZE(mop500_platform_devs));
>  
>                 hrefv60_sdi_init(parent);
> +               mop500_msp_init(parent);
>  
>                 i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
>                 i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;


Looks like you're adding the same call to each of the three cases:
mop500, snowball and hrefv60+. How about moving it before or after
the if/elseif block?

	Arnd
