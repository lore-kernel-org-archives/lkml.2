Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2FFODV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:03:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2FFODT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:03:19 -0400
Date: Wed, 6 Jun 2012 16:03:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Austin Hendrix <ahendrix@willowgarage.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Support for Novatek Touchscreen
In-Reply-To: <CAN+gG=FSTxE9d8o4O6+kQHmyg9PdJK28x6=Gjpgr+_xppiRVbQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1206061601460.12208@pobox.suse.cz>
References: <CAOY97VZN2a36OBsacQS21P8G70L2tbtbWK5OMWhZYa=D74XO+w@mail.gmail.com> <alpine.LNX.2.00.1206051134020.5478@pobox.suse.cz> <CAN+gG=FSTxE9d8o4O6+kQHmyg9PdJK28x6=Gjpgr+_xppiRVbQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Benjamin Tissoires wrote:

> >> Add support for a Novatek touchscreen panel as a generic HID multitouch
> >> panel.
> >>
> >> Signed-off-by: Austin Hendrix <ahendrix@willowgarage.com>
> >> ---
> >>  hid-core.c       |    1 +
> >>  hid-ids.h        |    3 +++
> >>  hid-multitouch.c |    5 +++++
> >>  3 files changed, 9 insertions(+)
> >>
> >> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> >> index 8e3a6b2..0d6dde1 100644
> >> --- a/drivers/hid/hid-core.c
> >> +++ b/drivers/hid/hid-core.c
> >> @@ -1605,6 +1605,7 @@ static const struct hid_device_id
> >> hid_have_special_driver[] = {
> >
> > Austin,
> >
> > thanks for the patch. Your mail client is corrupting (line-wrapping)
> > patches. Please fix that for your future submissions.
> >
> > I have now fixed that up manually and applied.
> >
> >>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16) },
> >>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17) },
> >>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
> >> +     { HID_USB_DEVICE(USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_PCT) },
> 
> I don't think this should be included in 3.5-rc+ (the whole MT-related
> devices has been removed from this list).

Yeah, I have noticed this and fixed it in 3.5-rc+ branch.

> 
> >>       { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
> >>       { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
> >>       { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX,
> >> USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
> >> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> >> index 9373f53..734a2b9 100644
> >> --- a/drivers/hid/hid-ids.h
> >> +++ b/drivers/hid/hid-ids.h
> >> @@ -564,6 +564,9 @@
> >>  #define USB_VENDOR_ID_NINTENDO               0x057e
> >>  #define USB_DEVICE_ID_NINTENDO_WIIMOTE       0x0306
> >>
> >> +#define USB_VENDOR_ID_NOVATEK                0x0603
> >> +#define USB_DEVICE_ID_NOVATK_PCT    0x0600
> >> +
> >>  #define USB_VENDOR_ID_NTRIG          0x1b96
> >>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
> >>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1   0x0003
> >> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> >> index 6e3332a..fae08df 100644
> >> --- a/drivers/hid/hid-multitouch.c
> >> +++ b/drivers/hid/hid-multitouch.c
> >> @@ -951,6 +951,11 @@ static const struct hid_device_id mt_devices[] = {
> >>               MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
> >>                       USB_DEVICE_ID_PANABOARD_UBT880) },
> >>
> >> +     /* Novatek Panel */
> >> +     { .driver_data = MT_CLS_DEFAULT,
> >> +             HID_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
> >> +                     USB_DEVICE_ID_NOVATEK_PCT) },
> 
> Shouldn't we use MT_USB_DEVICE instead?

We should, I have missed this and will fix this up with your Reported-by:, 
ok?

Thanks!

-- 
Jiri Kosina
SUSE Labs
