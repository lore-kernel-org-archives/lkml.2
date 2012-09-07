Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2IGPmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:42:13 -0400
Received: from mail.anarazel.de ([217.115.131.40]:47245 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab2IGPmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:42:12 -0400
From: Andres Freund <andres@anarazel.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: regression 3.5->3.6: usb keyboard not working anymore
Date: Fri, 7 Sep 2012 17:39:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc4-andres-00001-ga7ab0ca; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Bernhard Seibold <mail@bernhard-seibold.de>
References: <201208301434.26195.andres@anarazel.de> <201208301507.26992.andres@anarazel.de> <alpine.LNX.2.00.1209071711221.21679@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1209071711221.21679@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071739.16869.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 07, 2012 05:12:18 PM Jiri Kosina wrote:
> On Thu, 30 Aug 2012, Andres Freund wrote:
> > > With a quick grep I just discovered that a new driver for this (or
> > > similar?) keyboards has been added. I have *not* compiled this in
> > > though: +# CONFIG_HID_LENOVO_TPKBD is not set
> > > 
> > > Is the new, unconditional, entry in the hid_have_special_driver struct
> > > the problem?
> > > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > > index 8e3a6b2..f695680 100644
> > > --- a/drivers/hid/hid-core.c
> > > +++ b/drivers/hid/hid-core.c
> > > @@ -1544,6 +1544,7 @@ static const struct hid_device_id
> > > hid_have_special_driver[] = {
> > > 
> > >     { HID_USB_DEVICE(USB_VENDOR_ID_KYE,
> > >     USB_DEVICE_ID_KYE_EASYPEN_M610X) }, {
> > >     HID_USB_DEVICE(USB_VENDOR_ID_LABTEC,
> > > 
> > > USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
> > > 
> > >     { HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER,
> > >     USB_DEVICE_ID_LCPOWER_LC1000 )
> > > 
> > > }, +   { HID_USB_DEVICE(USB_VENDOR_ID_LENOVO,
> > > USB_DEVICE_ID_LENOVO_TPKBD) }, {
> > > HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER)
> > > }, { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> > > USB_DEVICE_ID_S510_RECEIVER) }, {
> > > HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2)
> > > },
> > > 
> > > Other entries seem to be protected via things like:
> > > #if IS_ENABLED(CONFIG_HID_LOGITECH_DJ)
> > > 
> > > I have somewhat obsoleted my original line of thought in this email,
> > > but hell. Will try this and send a patch if it works.
> > 
> > Works.
> > 
> > Could somebody integrate the attached patch?
> 
> Ok, I am now applying it, and for 3.7, I'd like to actually go over the
> list of devices, and do the same (perhaps in some nicer way) for those
> which are able to function (without full support) even with the generic
> driver.
That sounds like a good idea. Thanks!

Greetings,

Andres
