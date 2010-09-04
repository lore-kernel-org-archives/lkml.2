Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0IDCMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:12:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45613 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0IDCMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=iBQ05zAzb9L/Gw/Ml1urksl35pbi6DzPSSn7UAq4+v4y21s5PT3UlT0EPMX4qRbE7t
         HAj6xJpC8I684zI/KNz1SFOC1AC4kjcStDMxHPVtR/n88zkKvQEUx0ln7PNNAV1Q22yJ
         KlzElVv27YuMuako8fEuWJH8F40Z3ti91uoD0=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: Re: [PATCH v2 6/6] ARM: pxa168: aspenite: add board support for keypad
Date: Sat, 4 Sep 2010 04:12:00 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com> <1282836457-5651-7-git-send-email-mark.brown314@gmail.com>
In-Reply-To: <1282836457-5651-7-git-send-email-mark.brown314@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009040412.01067.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 26. srpna 2010 17:27:37 Mark F. Brown napsal(a):
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>

Ditto, which is V2 and which are just resubmissions please ?
> ---
>  arch/arm/mach-mmp/aspenite.c |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
> index 9e1bd6b..f04bae6 100644
> --- a/arch/arm/mach-mmp/aspenite.c
> +++ b/arch/arm/mach-mmp/aspenite.c
> @@ -24,6 +24,8 @@
>  #include <mach/pxa168.h>
>  #include <mach/gpio.h>
>  #include <video/pxa168fb.h>
> +#include <linux/input.h>
> +#include <plat/pxa27x_keypad.h>
> 
>  #include "common.h"
> 
> @@ -97,6 +99,13 @@ static unsigned long common_pin_config[] __initdata = {
>  	GPIO81_LCD_DD21,
>  	GPIO82_LCD_DD22,
>  	GPIO83_LCD_DD23,
> +
> +	/* Keypad */
> +	GPIO109_KP_MKIN1,
> +	GPIO110_KP_MKIN0,
> +	GPIO111_KP_MKOUT7,
> +	GPIO112_KP_MKOUT6,
> +	GPIO121_KP_MKIN4,
>  };
> 
>  static struct smc91x_platdata smc91x_info = {
> @@ -193,6 +202,23 @@ struct pxa168fb_mach_info aspenite_lcd_info = {
>  	.invert_pixclock	= 0,
>  };
> 
> +static unsigned int aspenite_matrix_key_map[] = {
> +	KEY(0, 6, KEY_UP),	/* SW 4 */
> +	KEY(0, 7, KEY_DOWN),	/* SW 5 */
> +	KEY(1, 6, KEY_LEFT),	/* SW 6 */
> +	KEY(1, 7, KEY_RIGHT),	/* SW 7 */
> +	KEY(4, 6, KEY_ENTER),	/* SW 8 */
> +	KEY(4, 7, KEY_ESC),	/* SW 9 */
> +};
> +
> +static struct pxa27x_keypad_platform_data aspenite_keypad_info __initdata
> = { +	.matrix_key_rows	= 5,
> +	.matrix_key_cols	= 8,
> +	.matrix_key_map		= aspenite_matrix_key_map,
> +	.matrix_key_map_size	= ARRAY_SIZE(aspenite_matrix_key_map),
> +	.debounce_interval	= 30,
> +};
> +
>  static void __init common_init(void)
>  {
>  	mfp_config(ARRAY_AND_SIZE(common_pin_config));
> @@ -203,6 +229,7 @@ static void __init common_init(void)
>  	pxa168_add_ssp(1);
>  	pxa168_add_nand(&aspenite_nand_info);
>  	pxa168_add_fb(&aspenite_lcd_info);
> +	pxa168_add_keypad(&aspenite_keypad_info);
> 
>  	/* off-chip devices */
>  	platform_device_register(&smc91x_device);
