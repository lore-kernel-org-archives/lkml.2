Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab1KXHT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:19:58 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40993 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab1KXHT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:19:57 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Peter Chen <hzpeterchen@gmail.com>, Greg KH <gregkh@suse.de>
CC: "balbi@ti.com" <balbi@ti.com>, Haojian Zhuang <hzhuang1@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 23:19:44 -0800
Subject: RE: [PATCH v1] USB: OTG should be linked before Host
Thread-Topic: [PATCH v1] USB: OTG should be linked before Host
Thread-Index: AcyqbzZNZ4ygTwksT6qUblW6NvY+NwACYvSg
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE19FD172883@SC-VEXCH4.marvell.com>
References: <1322044728-27080-1-git-send-email-zhangwm@marvell.com>
	<20111123161759.GA27000@suse.de>
 <CAL411-o0k_=HN+LH4Vx07=DTPOhs6iZuDXjdo1daBHov85Etaw@mail.gmail.com>
In-Reply-To: <CAL411-o0k_=HN+LH4Vx07=DTPOhs6iZuDXjdo1daBHov85Etaw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAO7K6PR012523

> -----Original Message-----
> From: Peter Chen [mailto:hzpeterchen@gmail.com]
> Sent: 2011å¹´11æœˆ24æ—¥ 14:06
> To: Greg KH
> Cc: Neil Zhang; balbi@ti.com; Haojian Zhuang; linux-usb@vger.kernel.org
> Subject: Re: [PATCH v1] USB: OTG should be linked before Host
> 
> On Thu, Nov 24, 2011 at 12:17 AM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Nov 23, 2011 at 06:38:48PM +0800, Neil Zhang wrote:
> >> For OTG controller, the host driver will call function
> >> otg_get_transceiver to get the otg transceiver, so we need to init
> the
> >> OTG driver before HOST.
> >
> I agree with it, at freescale i.mx platform, we also need to init otg
> first, then the host
> if otg function is enabled.
> 
> > How do you handle this if these drivers are built as modules?
> We require the user load module by order, and write it at UserGuide.
> 
> I find at older kernel version, like 2.6.38, the otg was built firstly
> at usb module.

Actually, it was changed by the following patch.

commit 4661ffc91befc8c5ee080720120da1d53851060a
Author: Felipe Balbi <balbi@ti.com>
Date:   Thu Apr 7 10:59:34 2011 +0300

    usb: don't enter usb subdirectories directly

    Instead, make we enter usb/ directory on all
    needed cases and enter the subdirectories from
    drivers/usb/Makefile.

    Signed-off-by: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Hi Balbi,
Do you have any concern to change it?

> >
> >> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> >> ---
> >> Â drivers/usb/Makefile | Â  Â 3 ++-
> >> Â 1 files changed, 2 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> >> index 75eca76..53a7bc0 100644
> >> --- a/drivers/usb/Makefile
> >> +++ b/drivers/usb/Makefile
> >> @@ -6,6 +6,8 @@
> >>
> >> Â obj-$(CONFIG_USB) Â  Â  Â  Â  Â  Â += core/
> >>
> >> +obj-$(CONFIG_USB_OTG_UTILS) Â += otg/
> >> +
> >> Â obj-$(CONFIG_USB_DWC3) Â  Â  Â  Â  Â  Â  Â  += dwc3/
> >>
> >> Â obj-$(CONFIG_USB_MON) Â  Â  Â  Â  Â  Â  Â  Â += mon/
> >> @@ -51,7 +53,6 @@ obj-$(CONFIG_USB_SPEEDTOUCH) Â  Â  Â  Â += atm/
> >>
> >> Â obj-$(CONFIG_USB_MUSB_HDRC) Â += musb/
> >> Â obj-$(CONFIG_USB_RENESAS_USBHS) Â  Â  Â += renesas_usbhs/
> >> -obj-$(CONFIG_USB_OTG_UTILS) Â += otg/
> >> Â obj-$(CONFIG_USB_GADGET) Â  Â  += gadget/
> >>
> >> Â obj-$(CONFIG_USB_COMMON) Â  Â  += usb-common.o
> >
> > This is a big change that I would like to get some acks by other
> people
> > before making, are you sure you didn't just break any other hardware
> > that needs the host driver initialized first?
> >
> > greg k-h
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at Â http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> BR,
> Peter Chen

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
