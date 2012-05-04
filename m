Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2EDMGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:06:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab2EDMGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:06:41 -0400
Date: Fri, 4 May 2012 14:06:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH] HID: hid-multitouch: Only match MT interfaces
In-Reply-To: <CAN+gG=FSg+eZxGUY1BU0k_mkxiPZQ9BHuqUb00NTij_JWbDUcA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1205041405520.14613@pobox.suse.cz>
References: <1336056176-2508-1-git-send-email-rydberg@euromail.se> <CAN+gG=FSg+eZxGUY1BU0k_mkxiPZQ9BHuqUb00NTij_JWbDUcA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012, Benjamin Tissoires wrote:

> > All known hid-multitouch devices currently match any device group.
> > However, some devices present interfaces belonging to different groups,
> > resulting in a race between the hid-generic and hid-multitouch modules.
> > This patch narrows the MT device list to match only HID_GROUP_MULTITOUCH,
> > which solves the problem.
> >
> > Reported-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> >  drivers/hid/hid-multitouch.c |  145 +++++++++++++++++++++---------------------
> >  1 file changed, 74 insertions(+), 71 deletions(-)
> >
> > diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> > index ea465f1..20e9552 100644
> > --- a/drivers/hid/hid-multitouch.c
> > +++ b/drivers/hid/hid-multitouch.c
> > @@ -110,6 +110,9 @@ struct mt_device {
> >
> >  #define MT_DEFAULT_MAXCONTACT  10
> >
> > +#define MT_USB_DEVICE(v, p)    HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH, v, p)
> > +#define MT_BT_DEVICE(v, p)     HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH, v, p)
> > +
> >  /*
> >  * these device-dependent functions determine what slot corresponds
> >  * to a valid contact that was just read.
> > @@ -735,276 +738,276 @@ static const struct hid_device_id mt_devices[] = {
> >
> >        /* 3M panels */
> >        { .driver_data = MT_CLS_3M,
> > -               HID_USB_DEVICE(USB_VENDOR_ID_3M,
> > +               MT_USB_DEVICE(USB_VENDOR_ID_3M,
> >                        USB_DEVICE_ID_3M1968) },
> >        { .driver_data = MT_CLS_3M,
> > -               HID_USB_DEVICE(USB_VENDOR_ID_3M,
> > +               MT_USB_DEVICE(USB_VENDOR_ID_3M,
> >                        USB_DEVICE_ID_3M2256) },
> >        { .driver_data = MT_CLS_3M,
> > -               HID_USB_DEVICE(USB_VENDOR_ID_3M,
> > +               MT_USB_DEVICE(USB_VENDOR_ID_3M,
> >                        USB_DEVICE_ID_3M3266) },
> >
> >        /* ActionStar panels */
> >        { .driver_data = MT_CLS_DEFAULT,
> > -               HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
> > +               MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
> >                        USB_DEVICE_ID_ACTIONSTAR_1011) },
> >
> >        /* Atmel panels */
> >        { .driver_data = MT_CLS_SERIAL,
> > -               HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
> > +               MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
> >                        USB_DEVICE_ID_ATMEL_MULTITOUCH) },
> >        { .driver_data = MT_CLS_SERIAL,
> > -               HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
> > +               MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
> >                        USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
> >
> 
> You are missing /* Baanto multitouch devices */ here. Please use the
> branch for-next of Jiri....

This is not necessary ... I will have to fix the merge conflict one way or 
another anyway, that's fine.

Thanks,

-- 
Jiri Kosina
SUSE Labs
