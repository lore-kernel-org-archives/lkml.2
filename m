Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2IBJxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 05:53:51 -0400
Received: from mail.anarazel.de ([217.115.131.40]:45736 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab2IBJxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 05:53:08 -0400
From: Andres Freund <andres@anarazel.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: regression 3.5->3.6: usb keyboard not working anymore
Date: Sun, 2 Sep 2012 11:53:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc3-andres-00231-g002b758; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Bernhard Seibold <mail@bernhard-seibold.de>
References: <201208301434.26195.andres@anarazel.de> <201208301507.26992.andres@anarazel.de> <alpine.LNX.2.00.1209021030040.20709@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1209021030040.20709@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209021153.05364.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, September 02, 2012 10:33:20 AM Jiri Kosina wrote:
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
> Hmm ... you are right, that this is a regression in a sense that if you
> have a working kernel, do oldconfig with the default settings, and then
> you lose your keyboard.
> 
> I don't like the aproach you used in your patch though ... we are not
> doing this for other devices either. For those, which were previously
> supported by core driver and then a new driver with enhanced support was
> spinned of, we rather make different default config option.
I don't find my approach elegant either. It has the big advantage though that 
you can still walk up to some random computer and be pretty sure the keyboard 
just works without needing to recompile the kernel. Until now it worked on 
every kernel with just CONFIG_USB_HID. Its somewhat harder to recompile a 
kernel without a keyboard...

Greetings,

Andres
