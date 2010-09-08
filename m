Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0IHFea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:34:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52245 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0IHFe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LLeX1ASX2O2pp9NRB7R1MRZO9KyNS6gBpTlbG3YCdbLz5+GWQrcP4jsvzUcXDjg7Dr
         kOTttMpRdUNbow2+uYSfEsm9ctZO9mxFYPR0VJXwFuv0pLOez14z3+WTcTys1zs6hwXz
         +L10YCkLieiq+XyoE9LrUOcW3hoRMJx1xReEA=
MIME-Version: 1.0
In-Reply-To: <1283914607-10570-4-git-send-email-mark.brown314@gmail.com>
References: <1283914607-10570-1-git-send-email-mark.brown314@gmail.com>
	<1283914607-10570-4-git-send-email-mark.brown314@gmail.com>
Date: Wed, 8 Sep 2010 13:34:24 +0800
Message-ID: <AANLkTi=StWVfeGjNCqJWJka0yifXv6rEB6GoZEkq7NT5@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: pxa168/teton bga: add board support for i2c and rtc-ds1337
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 10:56 AM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/mach-mmp/teton_bga.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
> index bbeda5c..8e5801c 100644
> --- a/arch/arm/mach-mmp/teton_bga.c
> +++ b/arch/arm/mach-mmp/teton_bga.c
> @@ -22,6 +22,7 @@
>  #include <mach/gpio.h>
>  #include <linux/input.h>
>  #include <plat/pxa27x_keypad.h>
> +#include <linux/i2c.h>
>
>  #include "common.h"
>
> @@ -35,6 +36,10 @@ static unsigned long teton_bga_pin_config[] __initdata = {
>        GPIO110_KP_MKIN0,
>        GPIO111_KP_MKOUT7,
>        GPIO112_KP_MKOUT6,
> +
> +       /* i2c bus */
> +       GPIO105_CI2C_SDA,
> +       GPIO106_CI2C_SCL,
>  };
>
>  static unsigned int teton_bga_matrix_key_map[] = {
> @@ -52,6 +57,10 @@ static struct pxa27x_keypad_platform_data teton_bga_keypad_info __initdata = {
>        .debounce_interval      = 30,
>  };
>
> +static struct i2c_board_info teton_bga_i2c_info[] __initdata = {
> +       { I2C_BOARD_INFO("ds1337", 0x68), },
> +};
> +

I don't have the schematic of teton. But RTC chips should always has
an irq pin. Is it also connected in your platform?

>  static void __init teton_bga_init(void)
>  {
>        mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
> @@ -59,6 +68,7 @@ static void __init teton_bga_init(void)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
