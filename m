Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0DNGe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:34:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34095 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0DNGeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:34:25 -0400
Date: Wed, 14 Apr 2010 08:34:23 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux@arm.linux.org.uk, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       bryan.wu@canonical.com, amit.kucheria@canonical.com
Subject: Re: [PATCH 2.6.34-rc4 2/8] mxc: Update GPIO for USB support on
	Freescale MX51 Babbage HW
Message-ID: <20100414063423.GC7882@pengutronix.de>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:30:30 up 24 days, 19:20, 25 users,  load average: 3.03, 3.31,
	2.57
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:10:25AM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> This patch is part of enabling USB for Freescale MX51 Babbage HW. This
> patch updates the iomux pins for USB, and gpio line for reset the
> USB hub on the MX51 Babbage HW.
> 
> This patch applies to 2.6.34-rc4.
> 
>  /*
>   * The naming convention for the pad modes is MX51_PAD_<padname>__<padmode>
> @@ -208,18 +214,19 @@ typedef enum iomux_config {
>  #define MX51_PAD_KEY_COL3__KEY_COL3	IOMUX_PAD(0x658, 0x268, 0, 0x0, 0, NO_PAD_CTRL)
>  #define MX51_PAD_KEY_COL4__KEY_COL4	IOMUX_PAD(0x65C, 0x26C, 0, 0x0, 0, NO_PAD_CTRL)
>  #define MX51_PAD_KEY_COL5__KEY_COL5	IOMUX_PAD(0x660, 0x270, 0, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_25__USBH1_CLK	IOMUX_PAD(0x678, 0x278, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_26__USBH1_DIR	IOMUX_PAD(0x67C, 0x27C, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_27__USBH1_STP	IOMUX_PAD(0x680, 0x280, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_28__USBH1_NXT	IOMUX_PAD(0x684, 0x284, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_11__USBH1_DATA0	IOMUX_PAD(0x688, 0x288, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_12__USBH1_DATA1	IOMUX_PAD(0x68C, 0x28C, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_13__USBH1_DATA2	IOMUX_PAD(0x690, 0x290, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_14__USBH1_DATA3	IOMUX_PAD(0x694, 0x294, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_15__USBH1_DATA4	IOMUX_PAD(0x698, 0x298, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_16__USBH1_DATA5	IOMUX_PAD(0x69C, 0x29C, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_17__USBH1_DATA6	IOMUX_PAD(0x6A0, 0x2A0, 2, 0x0, 0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_18__USBH1_DATA7	IOMUX_PAD(0x6A4, 0x2A4, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_25__USBH1_CLK	IOMUX_PAD(0x678, 0x278, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)

The naming convention is MX51_PAD_<padname>__<function> with padname
being the name in the datasheet, so this pad should be named
MX51_PAD_USBH1_CLK__USBH1_CLK, or if used as gpio
MX51_PAD_USBH1_CLK__GPIO_1_25. This is not your fault, it was wrong
before and I haven't recognized it. We should fix this before these
definitions actually get used.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
