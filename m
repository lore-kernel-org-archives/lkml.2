Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0INHJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:09:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56805 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0INHJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nJxJzyy34lgF5XCtsTTns8F0z+dqgJ2JXGeUIAylVIBfqIhACJvxRtyBvJOSUX9oNp
         rgOkuceBkpf/jOe4Jc8T4aKUb/4PDfh+Ybnq5D5zMZxWKpmm/cy6wnyO3dyrdIM+EphT
         DUGv5noG9eLuhOVx96D0DPxQQtnJFqMarBoiY=
MIME-Version: 1.0
In-Reply-To: <1284349896-14545-4-git-send-email-mark.brown314@gmail.com>
References: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com> <1284349896-14545-4-git-send-email-mark.brown314@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 14 Sep 2010 15:08:59 +0800
Message-ID: <AANLkTi=DPkXtHNY9bP0VXVi1gUD=-kHm8fuouutTinUW@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: pxa168/teton bga: add board support for i2c
 and rtc-ds1337
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: marek.vasut@gmail.com, haojian.zhuang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        markb@marvell.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 11:51 AM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Defined I2C/ALARM pin definitions
> DS1337 RTC alarm support is tied to RTC_INT_GPIO
>
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>

Applied with Acks.

> ---
>  arch/arm/mach-mmp/teton_bga.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
> index 2966117..d631bbc 100644
> --- a/arch/arm/mach-mmp/teton_bga.c
> +++ b/arch/arm/mach-mmp/teton_bga.c
> @@ -18,6 +18,7 @@
>  #include <linux/gpio.h>
>  #include <linux/input.h>
>  #include <plat/pxa27x_keypad.h>
> +#include <linux/i2c.h>
>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -38,6 +39,13 @@ static unsigned long teton_bga_pin_config[] __initdata = {
>        GPIO110_KP_MKIN0,
>        GPIO111_KP_MKOUT7,
>        GPIO112_KP_MKOUT6,
> +
> +       /* I2C Bus */
> +       GPIO105_CI2C_SDA,
> +       GPIO106_CI2C_SCL,
> +
> +       /* RTC */
> +       GPIO78_GPIO,
>  };
>
>  static unsigned int teton_bga_matrix_key_map[] = {
> @@ -55,6 +63,13 @@ static struct pxa27x_keypad_platform_data teton_bga_keypad_info __initdata = {
>        .debounce_interval      = 30,
>  };
>
> +static struct i2c_board_info teton_bga_i2c_info[] __initdata = {
> +       {
> +               I2C_BOARD_INFO("ds1337", 0x68),
> +               .irq = gpio_to_irq(RTC_INT_GPIO)
> +       },
> +};
> +
>  static void __init teton_bga_init(void)
>  {
>        mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
> @@ -62,6 +77,7 @@ static void __init teton_bga_init(void)
>        /* on-chip devices */
>        pxa168_add_uart(1);
>        pxa168_add_keypad(&teton_bga_keypad_info);
> +       pxa168_add_twsi(0, NULL, ARRAY_AND_SIZE(teton_bga_i2c_info));
>  }
>
>  MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
> --
> 1.7.0.4
>
>
