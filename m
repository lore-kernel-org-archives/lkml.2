Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2AAOTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:19:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61600 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2AAOTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:19:43 -0500
MIME-Version: 1.0
In-Reply-To: <1324541855-19911-3-git-send-email-haojian.zhuang@marvell.com>
References: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
	<1324541855-19911-3-git-send-email-haojian.zhuang@marvell.com>
Date: Sun, 1 Jan 2012 15:19:42 +0100
Message-ID: <CACRpkdZJanrnPhGQ=SzRPn1vNpjgHAaknsybTqpExPdWOhjMCA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] ARM: mmp: enable pinmux in mmp platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 9:17 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> Configuring pinmux in brownstone, aspenite & ttc dkb platform. The functions
> of pins are initialized in platform driver.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>

Deleting platform data and moving complex stuff to the pinctrl
subsystem where it belongs - great!

>        select CPU_MOHAWK
> +       select PINCTRL
> +       select PINMUX_PXA168

Will need to be renamed PINCTRL_PXA168 etc, sorry for the
painful renaming, just want to keep things consistent.

>        help
>          Select code specific to PXA168
>
>  config CPU_PXA910
>        bool
>        select CPU_MOHAWK
> +       select PINCTRL
> +       select PINMUX_PXA910

Here too.

>        help
>          Select code specific to PXA910
>
>  config CPU_MMP2
>        bool
>        select CPU_PJ4
> +       select PINCTRL
> +       select PINMUX_MMP2

Here too.

> +#define P168_CTRL              "pxa168-pinmux"
> +
> +static struct pinmux_map aspenite_pmx_map[] = {
> +       PINMUX_MAP_SYS_HOG("SSP1 SYSCLK", P168_CTRL, "ac97 sysclk"),
> +       PINMUX_MAP_SYS_HOG("SSP1 RX", P168_CTRL, "ssp1 rx"),
> +       PINMUX_MAP_SYS_HOG("SSP1 TX", P168_CTRL, "ssp1 tx"),
> +       PINMUX_MAP_SYS_HOG("DFIO", P168_CTRL, "dfio"),
> +       PINMUX_MAP_SYS_HOG("SMC CS0", P168_CTRL, "smc cs0"),
> +       PINMUX_MAP_SYS_HOG("SMC CS1", P168_CTRL, "smc cs1"),
> +       PINMUX_MAP_SYS_HOG("SMC RDY", P168_CTRL, "smc rdy"),
> +       PINMUX_MAP_SYS_HOG("SMC", P168_CTRL, "smc"),
> +       PINMUX_MAP_SYS_HOG("LCD", P168_CTRL, "lcd"),
> +       PINMUX_MAP_SYS_HOG("KP MKIN", P168_CTRL, "kpmkin"),
> +       PINMUX_MAP_SYS_HOG("KP MKOUT", P168_CTRL, "kpmkout"),
> +       PINMUX_MAP_SYS_HOG_GROUP("UART1 RX", P168_CTRL, "uart1 rx", "uart1rx-1"),
> +       PINMUX_MAP_SYS_HOG_GROUP("UART1 TX", P168_CTRL, "uart1 tx", "uart1tx-1"),
>  };

Excellent.

> -       mfp_config(ARRAY_AND_SIZE(common_pin_config));
> +       int ret;
> +
> +       ret = pinmux_register_mappings(ARRAY_AND_SIZE(aspenite_pmx_map));
> +       if (ret < 0)
> +               goto out;

Oh I never saw the ARRAY_AND_SIZE() macro before, cool!

Mostly same comments for the other board, thanks!

Yours,
Linus Walleij
