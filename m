Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1B1GnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:43:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62561 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1B1GnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:43:17 -0500
Date: Mon, 28 Feb 2011 15:41:39 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 01/09] ARM: s3c2442: gta02: Fix usage gpio bank j pin
 definitions
In-reply-to: <1297043521-21903-1-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <000801cbd712$907019c0$b1504d40$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvGaWsLml7Qs7B+RIi4LQie++LyxAQp/UjA
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> The gta02 header file still uses the old S3C2410_GPJx defines instead of
the
> S3C2410_GPJ(x) macro. Since the S3C2410_GPJx defines have already been
> removed
> this causes the following build failure:
> 
> 	sound/soc/samsung/neo1973_wm8753.c: In function 'lm4853_set_spk':
> 	sound/soc/samsung/neo1973_wm8753.c:259: error: 'S3C2440_GPJ2'
> undeclared (first use in this function)
> 	sound/soc/samsung/neo1973_wm8753.c:259: error: (Each undeclared
> identifier is reported only once
> 	sound/soc/samsung/neo1973_wm8753.c:259: error: for each function it
> appears in.)
> 	sound/soc/samsung/neo1973_wm8753.c: In function 'lm4853_get_spk':
> 	sound/soc/samsung/neo1973_wm8753.c:267: error: 'S3C2440_GPJ2'
> undeclared (first use in this function)
> 	sound/soc/samsung/neo1973_wm8753.c: In function 'lm4853_event':
> 	sound/soc/samsung/neo1973_wm8753.c:276: error: 'S3C2440_GPJ1'
> undeclared (first use in this function)
> 	sound/soc/samsung/neo1973_wm8753.c: At top level:
> 	sound/soc/samsung/neo1973_wm8753.c:439: error: 'S3C2440_GPJ2'
> undeclared here (not in a function)
> 	sound/soc/samsung/neo1973_wm8753.c:440: error: 'S3C2440_GPJ1'
> undeclared here (not in a function)
> 
> This patches fixes the issue by doing a
> s,S3C2410_GPJ([\d]+),S3C2410_GPJ(\1),g

Maybe, "s,S3C2440_GPJ([\d]+),S3C2410_GPJ(\1),g" instead ?

> on the file.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/include/mach/gta02.h |   26
+++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/include/mach/gta02.h b/arch/arm/mach-
> s3c2440/include/mach/gta02.h
> index 953331d..3a56a22 100644
> --- a/arch/arm/mach-s3c2440/include/mach/gta02.h
> +++ b/arch/arm/mach-s3c2440/include/mach/gta02.h
> @@ -44,19 +44,19 @@
>  #define GTA02v3_GPIO_nUSB_FLT	S3C2410_GPG(10)	/* v3 + v4 only */
>  #define GTA02v3_GPIO_nGSM_OC	S3C2410_GPG(11)	/* v3 + v4 only */
> 
> -#define GTA02_GPIO_AMP_SHUT	S3C2440_GPJ1	/* v2 + v3 + v4 only */
> -#define GTA02v1_GPIO_WLAN_GPIO10	S3C2440_GPJ2
> -#define GTA02_GPIO_HP_IN	S3C2440_GPJ2	/* v2 + v3 + v4 only */
> -#define GTA02_GPIO_INT0		S3C2440_GPJ3	/* v2 + v3 + v4 only
*/
> -#define GTA02_GPIO_nGSM_EN	S3C2440_GPJ4
> -#define GTA02_GPIO_3D_RESET	S3C2440_GPJ5
> -#define GTA02_GPIO_nDL_GSM	S3C2440_GPJ6	/* v4 + v5 only */
> -#define GTA02_GPIO_WLAN_GPIO0	S3C2440_GPJ7
> -#define GTA02v1_GPIO_BAT_ID	S3C2440_GPJ8
> -#define GTA02_GPIO_KEEPACT	S3C2440_GPJ8
> -#define GTA02v1_GPIO_HP_IN	S3C2440_GPJ10
> -#define GTA02_CHIP_PWD		S3C2440_GPJ11	/* v2 + v3 + v4 only
*/
> -#define GTA02_GPIO_nWLAN_RESET	S3C2440_GPJ12	/* v2 + v3 + v4 only
*/
> +#define GTA02_GPIO_AMP_SHUT	S3C2410_GPJ(1)	/* v2 + v3 + v4 only */
> +#define GTA02v1_GPIO_WLAN_GPIO10	S3C2410_GPJ(2)
> +#define GTA02_GPIO_HP_IN	S3C2410_GPJ(2)	/* v2 + v3 + v4 only */
> +#define GTA02_GPIO_INT0		S3C2410_GPJ(3)	/* v2 + v3 + v4 only
*/
> +#define GTA02_GPIO_nGSM_EN	S3C2410_GPJ(4)
> +#define GTA02_GPIO_3D_RESET	S3C2410_GPJ(5)
> +#define GTA02_GPIO_nDL_GSM	S3C2410_GPJ(6)	/* v4 + v5 only */
> +#define GTA02_GPIO_WLAN_GPIO0	S3C2410_GPJ(7)
> +#define GTA02v1_GPIO_BAT_ID	S3C2410_GPJ(8)
> +#define GTA02_GPIO_KEEPACT	S3C2410_GPJ(8)
> +#define GTA02v1_GPIO_HP_IN	S3C2410_GPJ(10)
> +#define GTA02_CHIP_PWD		S3C2410_GPJ(11)	/* v2 + v3 + v4
> only */
> +#define GTA02_GPIO_nWLAN_RESET	S3C2410_GPJ(12)	/* v2 + v3 + v4
> only */
> 
>  #define GTA02_IRQ_GSENSOR_1	IRQ_EINT0
>  #define GTA02_IRQ_MODEM		IRQ_EINT1
> --
> 1.7.2.3

Yeah, old S3C2440_GPJx has removed.
Is the S3C2410_GPJ(1) right instead of S3C2440_GPJ1?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

