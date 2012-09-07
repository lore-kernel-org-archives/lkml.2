Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2IGPM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:12:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab2IGPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:12:26 -0400
Date: Fri, 7 Sep 2012 17:12:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andres Freund <andres@anarazel.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Bernhard Seibold <mail@bernhard-seibold.de>
Subject: Re: regression 3.5->3.6: usb keyboard not working anymore
In-Reply-To: <201208301507.26992.andres@anarazel.de>
Message-ID: <alpine.LNX.2.00.1209071711221.21679@pobox.suse.cz>
References: <201208301434.26195.andres@anarazel.de> <201208301507.26992.andres@anarazel.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2012, Andres Freund wrote:

> > With a quick grep I just discovered that a new driver for this (or
> > similar?) keyboards has been added. I have *not* compiled this in though:
> > +# CONFIG_HID_LENOVO_TPKBD is not set
> > 
> > Is the new, unconditional, entry in the hid_have_special_driver struct the
> > problem?
> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 8e3a6b2..f695680 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -1544,6 +1544,7 @@ static const struct hid_device_id
> > hid_have_special_driver[] = {
> >     { HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X) },
> >     { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC,
> > USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
> >     { HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 )
> > }, +   { HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD)
> > }, { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER)
> > }, { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER)
> > }, { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2)
> > },
> > 
> > Other entries seem to be protected via things like:
> > #if IS_ENABLED(CONFIG_HID_LOGITECH_DJ)
> > 
> > I have somewhat obsoleted my original line of thought in this email, but
> > hell. Will try this and send a patch if it works.
> Works.
> 
> Could somebody integrate the attached patch?

Ok, I am now applying it, and for 3.7, I'd like to actually go over the 
list of devices, and do the same (perhaps in some nicer way) for those 
which are able to function (without full support) even with the generic 
driver.

Thanks,

-- 
Jiri Kosina
SUSE Labs
