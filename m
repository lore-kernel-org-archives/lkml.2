Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab0JQUQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:16:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:50221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab0JQUQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:16:09 -0400
Message-ID: <4CBB5974.8060907@infradead.org>
Date: Sun, 17 Oct 2010 18:15:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
CC: Andy Walls <awalls@md.metrocast.net>, Steven Toth <stoth@kernellabs.com>,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        "David T. L. Wong" <davidtlwong@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cx23885: Use enum for board type definitions.
References: <20100816123012.9C5FC62C03A@msa106.auone-net.jp>
In-Reply-To: <20100816123012.9C5FC62C03A@msa106.auone-net.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-08-2010 09:30, Kusanagi Kouichi escreveu:
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
> ---
>  drivers/media/video/cx23885/cx23885.h |   62 +++++++++++++++++----------------
>  1 files changed, 32 insertions(+), 30 deletions(-)

There's not much gain on converting it to enum. In a matter of fact, keeping the
numbers is the way we do on other drivers, since, for some broken hardware without
eeprom, we may need to force the usage of a certain device number, and we don't want
that such number would change from kernel version to kernel version.

I'm not sure if we have any case on cx23885, but it is better to keep the same 
philosophy, as this may be needed in some future, if not needed currently.

> 
> diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
> index ed94b17..55dc282 100644
> --- a/drivers/media/video/cx23885/cx23885.h
> +++ b/drivers/media/video/cx23885/cx23885.h
> @@ -54,36 +54,38 @@
>  
>  #define BUFFER_TIMEOUT     (HZ)  /* 0.5 seconds */
>  
> -#define CX23885_BOARD_NOAUTO               UNSET
> -#define CX23885_BOARD_UNKNOWN                  0
> -#define CX23885_BOARD_HAUPPAUGE_HVR1800lp      1
> -#define CX23885_BOARD_HAUPPAUGE_HVR1800        2
> -#define CX23885_BOARD_HAUPPAUGE_HVR1250        3
> -#define CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP   4
> -#define CX23885_BOARD_HAUPPAUGE_HVR1500Q       5
> -#define CX23885_BOARD_HAUPPAUGE_HVR1500        6
> -#define CX23885_BOARD_HAUPPAUGE_HVR1200        7
> -#define CX23885_BOARD_HAUPPAUGE_HVR1700        8
> -#define CX23885_BOARD_HAUPPAUGE_HVR1400        9
> -#define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
> -#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
> -#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12
> -#define CX23885_BOARD_COMPRO_VIDEOMATE_E650F   13
> -#define CX23885_BOARD_TBS_6920                 14
> -#define CX23885_BOARD_TEVII_S470               15
> -#define CX23885_BOARD_DVBWORLD_2005            16
> -#define CX23885_BOARD_NETUP_DUAL_DVBS2_CI      17
> -#define CX23885_BOARD_HAUPPAUGE_HVR1270        18
> -#define CX23885_BOARD_HAUPPAUGE_HVR1275        19
> -#define CX23885_BOARD_HAUPPAUGE_HVR1255        20
> -#define CX23885_BOARD_HAUPPAUGE_HVR1210        21
> -#define CX23885_BOARD_MYGICA_X8506             22
> -#define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
> -#define CX23885_BOARD_HAUPPAUGE_HVR1850        24
> -#define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
> -#define CX23885_BOARD_HAUPPAUGE_HVR1290        26
> -#define CX23885_BOARD_MYGICA_X8558PRO          27
> -#define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
> +enum {
> +	CX23885_BOARD_NOAUTO = UNSET,
> +	CX23885_BOARD_UNKNOWN = 0,
> +	CX23885_BOARD_HAUPPAUGE_HVR1800lp,
> +	CX23885_BOARD_HAUPPAUGE_HVR1800,
> +	CX23885_BOARD_HAUPPAUGE_HVR1250,
> +	CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP,
> +	CX23885_BOARD_HAUPPAUGE_HVR1500Q,
> +	CX23885_BOARD_HAUPPAUGE_HVR1500,
> +	CX23885_BOARD_HAUPPAUGE_HVR1200,
> +	CX23885_BOARD_HAUPPAUGE_HVR1700,
> +	CX23885_BOARD_HAUPPAUGE_HVR1400,
> +	CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,
> +	CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
> +	CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
> +	CX23885_BOARD_COMPRO_VIDEOMATE_E650F,
> +	CX23885_BOARD_TBS_6920,
> +	CX23885_BOARD_TEVII_S470,
> +	CX23885_BOARD_DVBWORLD_2005,
> +	CX23885_BOARD_NETUP_DUAL_DVBS2_CI,
> +	CX23885_BOARD_HAUPPAUGE_HVR1270,
> +	CX23885_BOARD_HAUPPAUGE_HVR1275,
> +	CX23885_BOARD_HAUPPAUGE_HVR1255,
> +	CX23885_BOARD_HAUPPAUGE_HVR1210,
> +	CX23885_BOARD_MYGICA_X8506,
> +	CX23885_BOARD_MAGICPRO_PROHDTVE2,
> +	CX23885_BOARD_HAUPPAUGE_HVR1850,
> +	CX23885_BOARD_COMPRO_VIDEOMATE_E800,
> +	CX23885_BOARD_HAUPPAUGE_HVR1290,
> +	CX23885_BOARD_MYGICA_X8558PRO,
> +	CX23885_BOARD_LEADTEK_WINFAST_PXTV1200
> +};
>  
>  #define GPIO_0 0x00000001
>  #define GPIO_1 0x00000002

