Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0HaEOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:14:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59177 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab0HaEOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Bt/yUvW2ZM8qAVvV7y/p+ZdbOTJI/Y6ML5Gf01AJtUEiv+vx8qk/CNysnFP/nIZQqw
         hBSv62vqiS1Cbr+49jtqO/jY7/K3us2iZs+aWs4MNO4gSFT3v4YFQ8e+ipHS4OITHwX3
         CQ3vUScIMYX5JwbzU+x0kq77MHQpx2D7qIzw8=
MIME-Version: 1.0
In-Reply-To: <1282814339-10934-2-git-send-email-mark.brown314@gmail.com>
References: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com> <1282814339-10934-2-git-send-email-mark.brown314@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 31 Aug 2010 12:13:48 +0800
Message-ID: <AANLkTim64nZ_wATk+Mc7LpJ_=z_ESj1UCFzrzbmdbaH9@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: pxa27x/pxa3xx: moved pxa27x_keypad.h to platform
 pxa directory
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 5:18 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> mach-mmp utilizes pxa27x_keypad code so we need to move header to
> platform pxa directory.

Good move. I'm actually very inclined to move this into include/linux/input/.

And you may try '-M' when generating patches with 'git format-patch', and
see the difference of the output.

>
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/mach-pxa/devices.c                    |    2 +-
>  arch/arm/mach-pxa/em-x270.c                    |    2 +-
>  arch/arm/mach-pxa/ezx.c                        |    2 +-
>  arch/arm/mach-pxa/include/mach/pxa27x_keypad.h |   59 ------------------------
>  arch/arm/mach-pxa/littleton.c                  |    2 +-
>  arch/arm/mach-pxa/mainstone.c                  |    4 +-
>  arch/arm/mach-pxa/mioa701.c                    |    2 +-
>  arch/arm/mach-pxa/palmld.c                     |    2 +-
>  arch/arm/mach-pxa/palmt5.c                     |    2 +-
>  arch/arm/mach-pxa/palmtreo.c                   |    2 +-
>  arch/arm/mach-pxa/palmtx.c                     |    2 +-
>  arch/arm/mach-pxa/palmz72.c                    |    2 +-
>  arch/arm/mach-pxa/tavorevb.c                   |    2 +-
>  arch/arm/mach-pxa/z2.c                         |    2 +-
>  arch/arm/mach-pxa/zylonite.c                   |    2 +-
>  arch/arm/plat-pxa/include/plat/pxa27x_keypad.h |   59 ++++++++++++++++++++++++
>  drivers/input/keyboard/pxa27x_keypad.c         |    2 +-
>  17 files changed, 75 insertions(+), 75 deletions(-)
>  delete mode 100644 arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
>  create mode 100644 arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
>
> diff --git a/arch/arm/mach-pxa/devices.c b/arch/arm/mach-pxa/devices.c
> index a2fc859..08b4103 100644
> --- a/arch/arm/mach-pxa/devices.c
> +++ b/arch/arm/mach-pxa/devices.c
> @@ -11,7 +11,7 @@
>  #include <mach/mmc.h>
>  #include <mach/irda.h>
>  #include <mach/ohci.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/pxa2xx_spi.h>
>  #include <mach/camera.h>
>  #include <mach/audio.h>
> diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
> index 0517c17..51286a7 100644
> --- a/arch/arm/mach-pxa/em-x270.c
> +++ b/arch/arm/mach-pxa/em-x270.c
> @@ -43,7 +43,7 @@
>  #include <mach/pxafb.h>
>  #include <mach/ohci.h>
>  #include <mach/mmc.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <plat/i2c.h>
>  #include <mach/camera.h>
>  #include <mach/pxa2xx_spi.h>
> diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
> index 3fe61f4..f997e84 100644
> --- a/arch/arm/mach-pxa/ezx.c
> +++ b/arch/arm/mach-pxa/ezx.c
> @@ -32,7 +32,7 @@
>  #include <mach/ohci.h>
>  #include <plat/i2c.h>
>  #include <mach/hardware.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/camera.h>
>
>  #include "devices.h"
> diff --git a/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h b/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
> deleted file mode 100644
> index 7b4eadc..0000000
> --- a/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
> +++ /dev/null
> @@ -1,59 +0,0 @@
> -#ifndef __ASM_ARCH_PXA27x_KEYPAD_H
> -#define __ASM_ARCH_PXA27x_KEYPAD_H
> -
> -#include <linux/input.h>
> -#include <linux/input/matrix_keypad.h>
> -
> -#define MAX_MATRIX_KEY_ROWS    (8)
> -#define MAX_MATRIX_KEY_COLS    (8)
> -#define MATRIX_ROW_SHIFT       (3)
> -#define MAX_DIRECT_KEY_NUM     (8)
> -
> -/* pxa3xx keypad platform specific parameters
> - *
> - * NOTE:
> - * 1. direct_key_num indicates the number of keys in the direct keypad
> - *    _plus_ the number of rotary-encoder sensor inputs,  this can be
> - *    left as 0 if only rotary encoders are enabled,  the driver will
> - *    automatically calculate this
> - *
> - * 2. direct_key_map is the key code map for the direct keys, if rotary
> - *    encoder(s) are enabled, direct key 0/1(2/3) will be ignored
> - *
> - * 3. rotary can be either interpreted as a relative input event (e.g.
> - *    REL_WHEEL/REL_HWHEEL) or specific keys (e.g. UP/DOWN/LEFT/RIGHT)
> - *
> - * 4. matrix key and direct key will use the same debounce_interval by
> - *    default, which should be sufficient in most cases
> - */
> -struct pxa27x_keypad_platform_data {
> -
> -       /* code map for the matrix keys */
> -       unsigned int    matrix_key_rows;
> -       unsigned int    matrix_key_cols;
> -       unsigned int    *matrix_key_map;
> -       int             matrix_key_map_size;
> -
> -       /* direct keys */
> -       int             direct_key_num;
> -       unsigned int    direct_key_map[MAX_DIRECT_KEY_NUM];
> -
> -       /* rotary encoders 0 */
> -       int             enable_rotary0;
> -       int             rotary0_rel_code;
> -       int             rotary0_up_key;
> -       int             rotary0_down_key;
> -
> -       /* rotary encoders 1 */
> -       int             enable_rotary1;
> -       int             rotary1_rel_code;
> -       int             rotary1_up_key;
> -       int             rotary1_down_key;
> -
> -       /* key debounce interval */
> -       unsigned int    debounce_interval;
> -};
> -
> -extern void pxa_set_keypad_info(struct pxa27x_keypad_platform_data *info);
> -
> -#endif /* __ASM_ARCH_PXA27x_KEYPAD_H */
> diff --git a/arch/arm/mach-pxa/littleton.c b/arch/arm/mach-pxa/littleton.c
> index 83f3236..eb58506 100644
> --- a/arch/arm/mach-pxa/littleton.c
> +++ b/arch/arm/mach-pxa/littleton.c
> @@ -43,7 +43,7 @@
>  #include <mach/pxafb.h>
>  #include <mach/mmc.h>
>  #include <mach/pxa2xx_spi.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/littleton.h>
>  #include <plat/i2c.h>
>  #include <plat/pxa3xx_nand.h>
> diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
> index c2a8717..126dca1 100644
> --- a/arch/arm/mach-pxa/mainstone.c
> +++ b/arch/arm/mach-pxa/mainstone.c
> @@ -41,7 +41,7 @@
>  #include <asm/mach/irq.h>
>  #include <asm/mach/flash.h>
>
> -#include <mach/pxa27x.h>
> +#include <plat/pxa27x.h>
>  #include <mach/gpio.h>
>  #include <mach/mainstone.h>
>  #include <mach/audio.h>
> @@ -50,7 +50,7 @@
>  #include <mach/mmc.h>
>  #include <mach/irda.h>
>  #include <mach/ohci.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>
>  #include "generic.h"
>  #include "devices.h"
> diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
> index dc66942..ffb3f5a 100644
> --- a/arch/arm/mach-pxa/mioa701.c
> +++ b/arch/arm/mach-pxa/mioa701.c
> @@ -45,7 +45,7 @@
>
>  #include <mach/pxa27x.h>
>  #include <mach/regs-rtc.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/pxafb.h>
>  #include <mach/mmc.h>
>  #include <mach/udc.h>
> diff --git a/arch/arm/mach-pxa/palmld.c b/arch/arm/mach-pxa/palmld.c
> index 91038ee..3ff0c4a 100644
> --- a/arch/arm/mach-pxa/palmld.c
> +++ b/arch/arm/mach-pxa/palmld.c
> @@ -39,7 +39,7 @@
>  #include <mach/mmc.h>
>  #include <mach/pxafb.h>
>  #include <mach/irda.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/palmasoc.h>
>  #include <mach/palm27x.h>
>
> diff --git a/arch/arm/mach-pxa/palmt5.c b/arch/arm/mach-pxa/palmt5.c
> index 1c28199..5b9f766 100644
> --- a/arch/arm/mach-pxa/palmt5.c
> +++ b/arch/arm/mach-pxa/palmt5.c
> @@ -39,7 +39,7 @@
>  #include <mach/mmc.h>
>  #include <mach/pxafb.h>
>  #include <mach/irda.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/udc.h>
>  #include <mach/palmasoc.h>
>  #include <mach/palm27x.h>
> diff --git a/arch/arm/mach-pxa/palmtreo.c b/arch/arm/mach-pxa/palmtreo.c
> index 52defd5..f685a60 100644
> --- a/arch/arm/mach-pxa/palmtreo.c
> +++ b/arch/arm/mach-pxa/palmtreo.c
> @@ -39,7 +39,7 @@
>  #include <mach/mmc.h>
>  #include <mach/pxafb.h>
>  #include <mach/irda.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/udc.h>
>  #include <mach/ohci.h>
>  #include <mach/pxa2xx-regs.h>
> diff --git a/arch/arm/mach-pxa/palmtx.c b/arch/arm/mach-pxa/palmtx.c
> index 144dc2b..89a3792 100644
> --- a/arch/arm/mach-pxa/palmtx.c
> +++ b/arch/arm/mach-pxa/palmtx.c
> @@ -43,7 +43,7 @@
>  #include <mach/mmc.h>
>  #include <mach/pxafb.h>
>  #include <mach/irda.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/udc.h>
>  #include <mach/palmasoc.h>
>  #include <mach/palm27x.h>
> diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
> index 87e4b10..38f4425 100644
> --- a/arch/arm/mach-pxa/palmz72.c
> +++ b/arch/arm/mach-pxa/palmz72.c
> @@ -41,7 +41,7 @@
>  #include <mach/mmc.h>
>  #include <mach/pxafb.h>
>  #include <mach/irda.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/udc.h>
>  #include <mach/palmasoc.h>
>  #include <mach/palm27x.h>
> diff --git a/arch/arm/mach-pxa/tavorevb.c b/arch/arm/mach-pxa/tavorevb.c
> index f02dcb5..0f440c9 100644
> --- a/arch/arm/mach-pxa/tavorevb.c
> +++ b/arch/arm/mach-pxa/tavorevb.c
> @@ -25,7 +25,7 @@
>
>  #include <mach/pxa930.h>
>  #include <mach/pxafb.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>
>  #include "devices.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
> index f0d0228..8c44bc4 100644
> --- a/arch/arm/mach-pxa/z2.c
> +++ b/arch/arm/mach-pxa/z2.c
> @@ -37,7 +37,7 @@
>  #include <mach/z2.h>
>  #include <mach/pxafb.h>
>  #include <mach/mmc.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <mach/pxa2xx_spi.h>
>
>  #include <plat/i2c.h>
> diff --git a/arch/arm/mach-pxa/zylonite.c b/arch/arm/mach-pxa/zylonite.c
> index 2edad61..69df3ed 100644
> --- a/arch/arm/mach-pxa/zylonite.c
> +++ b/arch/arm/mach-pxa/zylonite.c
> @@ -30,7 +30,7 @@
>  #include <mach/zylonite.h>
>  #include <mach/mmc.h>
>  #include <mach/ohci.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  #include <plat/pxa3xx_nand.h>
>
>  #include "devices.h"
> diff --git a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
> new file mode 100644
> index 0000000..7b4eadc
> --- /dev/null
> +++ b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
> @@ -0,0 +1,59 @@
> +#ifndef __ASM_ARCH_PXA27x_KEYPAD_H
> +#define __ASM_ARCH_PXA27x_KEYPAD_H
> +
> +#include <linux/input.h>
> +#include <linux/input/matrix_keypad.h>
> +
> +#define MAX_MATRIX_KEY_ROWS    (8)
> +#define MAX_MATRIX_KEY_COLS    (8)
> +#define MATRIX_ROW_SHIFT       (3)
> +#define MAX_DIRECT_KEY_NUM     (8)
> +
> +/* pxa3xx keypad platform specific parameters
> + *
> + * NOTE:
> + * 1. direct_key_num indicates the number of keys in the direct keypad
> + *    _plus_ the number of rotary-encoder sensor inputs,  this can be
> + *    left as 0 if only rotary encoders are enabled,  the driver will
> + *    automatically calculate this
> + *
> + * 2. direct_key_map is the key code map for the direct keys, if rotary
> + *    encoder(s) are enabled, direct key 0/1(2/3) will be ignored
> + *
> + * 3. rotary can be either interpreted as a relative input event (e.g.
> + *    REL_WHEEL/REL_HWHEEL) or specific keys (e.g. UP/DOWN/LEFT/RIGHT)
> + *
> + * 4. matrix key and direct key will use the same debounce_interval by
> + *    default, which should be sufficient in most cases
> + */
> +struct pxa27x_keypad_platform_data {
> +
> +       /* code map for the matrix keys */
> +       unsigned int    matrix_key_rows;
> +       unsigned int    matrix_key_cols;
> +       unsigned int    *matrix_key_map;
> +       int             matrix_key_map_size;
> +
> +       /* direct keys */
> +       int             direct_key_num;
> +       unsigned int    direct_key_map[MAX_DIRECT_KEY_NUM];
> +
> +       /* rotary encoders 0 */
> +       int             enable_rotary0;
> +       int             rotary0_rel_code;
> +       int             rotary0_up_key;
> +       int             rotary0_down_key;
> +
> +       /* rotary encoders 1 */
> +       int             enable_rotary1;
> +       int             rotary1_rel_code;
> +       int             rotary1_up_key;
> +       int             rotary1_down_key;
> +
> +       /* key debounce interval */
> +       unsigned int    debounce_interval;
> +};
> +
> +extern void pxa_set_keypad_info(struct pxa27x_keypad_platform_data *info);
> +
> +#endif /* __ASM_ARCH_PXA27x_KEYPAD_H */
> diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
> index 0e53b3b..0610d10 100644
> --- a/drivers/input/keyboard/pxa27x_keypad.c
> +++ b/drivers/input/keyboard/pxa27x_keypad.c
> @@ -32,7 +32,7 @@
>  #include <asm/mach/map.h>
>
>  #include <mach/hardware.h>
> -#include <mach/pxa27x_keypad.h>
> +#include <plat/pxa27x_keypad.h>
>  /*
>  * Keypad Controller registers
>  */
> --
> 1.7.0.4
>
>
