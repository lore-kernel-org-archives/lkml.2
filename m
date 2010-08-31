Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0HaE4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:56:05 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56723 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab0HaE4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jlTX1gD/ntpnpgk4J2phN5FwIiQSJgpyf1XoZg4TcPyfpUMs0w5sE8tTFSXwk3vmv1
         1TsJdX4yMLm50rLp/BRGr5V0qeFX3k+9APeqvDC8+FQzRaHu9FZ7Pb0YfyCxuMBIZTRh
         6BA+vCP8IGD6qTfi9cZ71OHdjfEv6e5NAGsC8=
MIME-Version: 1.0
In-Reply-To: <1282814339-10934-3-git-send-email-mark.brown314@gmail.com>
References: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com>
	<1282814339-10934-3-git-send-email-mark.brown314@gmail.com>
Date: Tue, 31 Aug 2010 12:56:01 +0800
Message-ID: <AANLkTimZyGdRpQV_ZgJ8TdJzQ=rvpjV3+kPJsU+QKT=g@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: pxa168: added keypad support
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 5:18 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/mach-mmp/include/mach/mfp-pxa168.h |    7 +++++++
>  arch/arm/mach-mmp/include/mach/pxa168.h     |    7 +++++++
>  arch/arm/mach-mmp/pxa168.c                  |    3 +++
>  drivers/input/keyboard/Kconfig              |    2 +-
>  4 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/include/mach/mfp-pxa168.h b/arch/arm/mach-mmp/include/mach/mfp-pxa168.h
> index ded43c4..4621067 100644
> --- a/arch/arm/mach-mmp/include/mach/mfp-pxa168.h
> +++ b/arch/arm/mach-mmp/include/mach/mfp-pxa168.h
> @@ -289,4 +289,11 @@
>  #define GPIO86_PWM1_OUT                MFP_CFG(GPIO86, AF2)
>  #define GPIO86_PWM2_OUT                MFP_CFG(GPIO86, AF3)
>
> +/* Keypad */
> +#define GPIO109_KP_MKIN1        MFP_CFG(GPIO109, AF7)
> +#define GPIO110_KP_MKIN0        MFP_CFG(GPIO110, AF7)
> +#define GPIO111_KP_MKOUT7       MFP_CFG(GPIO111, AF7)
> +#define GPIO112_KP_MKOUT6       MFP_CFG(GPIO112, AF7)
> +#define GPIO121_KP_MKIN4        MFP_CFG(GPIO121, AF7)
> +
>  #endif /* __ASM_MACH_MFP_PXA168_H */
> diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h b/arch/arm/mach-mmp/include/mach/pxa168.h
> index 220738f..f34e663 100644
> --- a/arch/arm/mach-mmp/include/mach/pxa168.h
> +++ b/arch/arm/mach-mmp/include/mach/pxa168.h
> @@ -11,6 +11,7 @@ extern void __init pxa168_init_irq(void);
>  #include <plat/i2c.h>
>  #include <plat/pxa3xx_nand.h>
>  #include <video/pxa168fb.h>
> +#include <plat/pxa27x_keypad.h>
>
>  extern struct pxa_device_desc pxa168_device_uart1;
>  extern struct pxa_device_desc pxa168_device_uart2;
> @@ -27,6 +28,7 @@ extern struct pxa_device_desc pxa168_device_ssp4;
>  extern struct pxa_device_desc pxa168_device_ssp5;
>  extern struct pxa_device_desc pxa168_device_nand;
>  extern struct pxa_device_desc pxa168_device_fb;
> +extern struct pxa_device_desc pxa168_device_keypad;
>
>  static inline int pxa168_add_uart(int id)
>  {
> @@ -105,4 +107,9 @@ static inline int pxa168_add_fb(struct pxa168fb_mach_info *mi)
>        return pxa_register_device(&pxa168_device_fb, mi, sizeof(*mi));
>  }
>
> +static inline int pxa168_add_keypad(struct pxa27x_keypad_platform_data *data)
> +{
> +       return pxa_register_device(&pxa168_device_keypad, data, sizeof(*data));
> +}
> +
>  #endif /* __ASM_MACH_PXA168_H */
> diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
> index eaebf66..2fa16fb 100644
> --- a/arch/arm/mach-mmp/pxa168.c
> +++ b/arch/arm/mach-mmp/pxa168.c
> @@ -77,6 +77,7 @@ static APBC_CLK(ssp2, PXA168_SSP2, 4, 0);
>  static APBC_CLK(ssp3, PXA168_SSP3, 4, 0);
>  static APBC_CLK(ssp4, PXA168_SSP4, 4, 0);
>  static APBC_CLK(ssp5, PXA168_SSP5, 4, 0);
> +static APBC_CLK(keypad, PXA168_KPC, 0, 32000);
>
>  static APMU_CLK(nand, NAND, 0x01db, 208000000);
>  static APMU_CLK(lcd, LCD, 0x7f, 312000000);
> @@ -98,6 +99,7 @@ static struct clk_lookup pxa168_clkregs[] = {
>        INIT_CLKREG(&clk_ssp5, "pxa168-ssp.4", NULL),
>        INIT_CLKREG(&clk_nand, "pxa3xx-nand", NULL),
>        INIT_CLKREG(&clk_lcd, "pxa168-fb", NULL),
> +       INIT_CLKREG(&clk_keypad, "pxa27x-keypad", NULL),
>  };
>
>  static int __init pxa168_init(void)
> @@ -150,3 +152,4 @@ PXA168_DEVICE(ssp3, "pxa168-ssp", 2, SSP3, 0xd401f000, 0x40, 56, 57);
>  PXA168_DEVICE(ssp4, "pxa168-ssp", 3, SSP4, 0xd4020000, 0x40, 58, 59);
>  PXA168_DEVICE(ssp5, "pxa168-ssp", 4, SSP5, 0xd4021000, 0x40, 60, 61);
>  PXA168_DEVICE(fb, "pxa168-fb", -1, LCD, 0xd420b000, 0x1c8);
> +PXA168_DEVICE(keypad, "pxa27x-keypad", -1, KEYPAD, 0xd4012000, 0x4c);
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 9cc488d..aa037fe 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -338,7 +338,7 @@ config KEYBOARD_OPENCORES
>
>  config KEYBOARD_PXA27x
>        tristate "PXA27x/PXA3xx keypad support"
> -       depends on PXA27x || PXA3xx
> +       depends on PXA27x || PXA3xx || ARCH_MMP
>        help
>          Enable support for PXA27x/PXA3xx keypad controller.
>
> --
> 1.7.0.4
>
It seems good. Acked
