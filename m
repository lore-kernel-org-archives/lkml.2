Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2EJCiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:38:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab2EJCiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:38:11 -0400
Date: Thu, 10 May 2012 12:37:54 +1000
From: NeilBrown <neilb@suse.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
Message-ID: <20120510123754.6a6d95b9@notabene.brown>
In-Reply-To: <20120510012422.GA32077@nchen-desktop>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<20120510012422.GA32077@nchen-desktop>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xjof8a7xTXExD4Ww5GXamV="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xjof8a7xTXExD4Ww5GXamV=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2012 09:24:23 +0800 Peter Chen <peter.chen@freescale.com>
wrote:

> On Wed, Apr 25, 2012 at 05:33:10PM +1000, NeilBrown wrote:
> > Following are a collection of patches that I've need using for a while
> > to make sure the charge-from-usb on my GTA04 works.
> > Hopefully I've included the right people in the recipient list :-)
> >=20
> > The issues are:
> >  - charge the backup battery as well as the main battery
> >  - charge from a charger which ties ID to ground via a resistor
> >  - charge while device is suspended, or when no gadget module is
> >    loaded (i.e. when the USB side thinks the phy should be powered
> >    down).
> According to USB Spec, when the USB bus goes to suspend, the device
> should not draw more than 2.5mA. So when the device is suspended,
> it should notify the battery driver do NOT charge any more.

Hi Peter,
 thanks for your input.

 Would you be able to help me understand exactly what it means for the USB
 bus to go to suspend?  Is this something that the host initiates or
 something that the gadget initiates?
 How does this relate to a simple charger?  It that considered to have a
 non-suspended bus, or is it considered as a separate case?

 Maybe we need to not suspend the USB OTG interface when the device as a
 whole enters suspend-to-RAM.  Maybe we need to register a dummy gadget to
 the bus active while in suspend?
 Does the gadget have to be responsive while-ever the bus is not suspended?
 Maybe we can arrange for any USB activity to trigger a resume?

 Entering suspend while still charging really should be possible - at least
 with a dump charger and hopefully from a host port as well.  I'll like to
 find the best way to achieve that, and any help you can provide would be
 greatly appreciated.

Thanks,
NeilBrown


> >=20
> > Questions and comments more welcome.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > ---
> >=20
> > NeilBrown (6):
> >       twl4030-usb: Don't report EVENT_ID when there is VBUS.
> >       twl4030-usb: Don't power down phy when it is in-use by charger.
> >       twl4030_charger: Allow charger to control the regulator that feed=
s it.
> >       twl4030_charger: allow charging whenever VBUS is present.
> >       twl4030_charger: add backup-battery charging.
> >       twl4030_charger: Fix some typos
> >=20
> >=20
> >  drivers/mfd/twl-core.c          |    9 ++--
> >  drivers/power/twl4030_charger.c |   86 +++++++++++++++++++++++++++++++=
++++----
> >  drivers/usb/otg/twl4030-usb.c   |   27 ++++++++----
> >  include/linux/i2c/twl.h         |    2 +
> >  4 files changed, 102 insertions(+), 22 deletions(-)
> >=20
> > --=20
> > Signature
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20


--Sig_/xjof8a7xTXExD4Ww5GXamV=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6sqAjnsnt1WYoG5AQLHwRAAvVMS9UzWVbhGdiAfhf53lLJbq/AtUuUG
2h1ayuM39PCZ+zWjqUgB1T4rK++KE3pcnI2hUD1OyFlPN63/RiGIE3SAp3auRBsm
N+r4EwYwrcLGvnswQ1P2NVuwaGejRCzPb8PgGeRdLHFGghwCBlR59w3/OWRGZ3gV
77uSSr9nspp7Rg1x2mUKr8S/ZxEtn4p1BvXWXdjzXPVJtZU6oPSEpgh+yQL6SplF
3cs/4kje/Mu/6VTx4g/V/dUXuFUES/8Gb4+mwJ5qr4/Yz0RitEKjjkOVtrZ3a/w5
Gj+VzgpGLzYRmslgvP9WwFnSkjvowdIOLACjmgHQ9PajMcojcp20eZpld2ibc2B/
A9svNs4vHak82Xu+t591Hr9sLC5UVO9zG9cYeMmi8hmcK2qUIS4abfftXEwE6E9d
YMIKCw3uJjCMp4GsTcZ75QCndP+oApIIdiLpdH305dxMwxawVPY3QKmRpGgJ9BNC
eR9aKj5yW3EzGRxHSAzFnO+4VvfTc8akeMxjpY6wdtWIVeZ37vhPH7uzMBVfbZ4z
SulFWMxfkT9bTXu+TEtrOOO1usqPd33cRh4sFzMu8TQmam9vfQa9h+NyzzYs/gV1
HpTN8Fn2KMbwazRjBGeQYZOsnN/zMq9kSfxzwME2fYW7RMKgSTEvhLG+xPEaV5V1
3/kqllebkJM=
=JgN8
-----END PGP SIGNATURE-----

--Sig_/xjof8a7xTXExD4Ww5GXamV=--
