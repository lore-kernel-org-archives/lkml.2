Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2APC2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 21:28:50 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:32945 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab2APC2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 21:28:48 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Chao Xie <cxie4@marvell.com>,
        Felipe Balbi <balbi@ti.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 15 Jan 2012 18:28:29 -0800
Subject: RE: [PATCH] usb: mv-otg - Fix build if CONFIG_USB is not set
Thread-Topic: [PATCH] usb: mv-otg - Fix build if CONFIG_USB is not set
Thread-Index: AczTeej7sZv1ae43R2SdZIGZO0+CmwAfAFOA
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1A17284091@SC-VEXCH4.marvell.com>
References: <1326627376-12883-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1326627376-12883-1-git-send-email-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0G2SsUU008401

Hi Geert,

> -----Original Message-----
> From: Geert Uytterhoeven [mailto:geert@linux-m68k.org]
> Sent: 2012Äê1ÔÂ15ÈÕ 19:36
> To: Neil Zhang; Chao Xie; Felipe Balbi
> Cc: Randy Dunlap; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Geert Uytterhoeven
> Subject: [PATCH] usb: mv-otg - Fix build if CONFIG_USB is not set
> 
> ERROR: "usb_remove_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
> ERROR: "usb_add_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> --
> Inpired by drivers/usb/otg/msm_otg.c. Is this correct?
> 
>  drivers/usb/otg/mv_otg.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/otg/mv_otg.c b/drivers/usb/otg/mv_otg.c
> index db0d4fc..b5fbe14 100644
> --- a/drivers/usb/otg/mv_otg.c
> +++ b/drivers/usb/otg/mv_otg.c
> @@ -202,6 +202,7 @@ static void mv_otg_init_irq(struct mv_otg *mvotg)
> 
>  static void mv_otg_start_host(struct mv_otg *mvotg, int on)
>  {
> +#ifdef CONFIG_USB
>  	struct otg_transceiver *otg = &mvotg->otg;
>  	struct usb_hcd *hcd;
> 
> @@ -216,6 +217,7 @@ static void mv_otg_start_host(struct mv_otg *mvotg,
> int on)
>  		usb_add_hcd(hcd, hcd->irq, IRQF_SHARED);
>  	else
>  		usb_remove_hcd(hcd);
> +#endif /* CONFIG_USB */
>  }
> 
>  static void mv_otg_start_periphrals(struct mv_otg *mvotg, int on)
> --
> 1.7.0.4

Thanks for your information.
I think it would be better to add a dependency on USB_EHCI_MV since there is no need to use the OTG driver without enable host.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
