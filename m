Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1EXKS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:18:28 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:48423 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731Ab1EXKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:18:26 -0400
Date: Tue, 24 May 2011 13:18:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110524101817.GB14371@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BD27AEAC-1E6D-480C-9E18-A970B992AD75@ti.com>
 <Pine.LNX.4.44L0.1105231710590.2020-100000@iolanthe.rowland.org>
 <00ed01cc19d6$e1fef520$a5fcdf60$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <00ed01cc19d6$e1fef520$a5fcdf60$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 24, 2011 at 08:53:15AM +0300, Tanya Brokhman wrote:
> > >
> > > With Tatyana's patches, if we load a USB2 g_zero to dummy_hcd,
> > enumeration
> > > will fail where it shouldn't. This has been my whole point ;-) Maybe
> > I wasn't
> > > clear enough.
> >=20
> > I guess not.  I thought Tatyana said she was working to fix that bug...
>=20
> This bug is fixed with the module parameter. When dummy_hcd is loaded it
> registers 2 root hubs: HS & SS but unless the is_super_speed parameter is
> true, the device will be connected to the HS hub. This way when loading HS
> g_zero  it enumerates under HS root hub successfully.=20
> Note that if load SS gadget without setting is_super_speed=3Dtrue for dum=
my
> hcd, it will also enumerate under HS hub! This is basically a way to test
> that SS devices are backward compatible.

but you also need to make sure that HS gadget enumerates on SS host. I
don't agree that the module parameter is the only option.

> > > >> What about the case where SuperSpeed enumeration
> > > >> fails and you have to fall back to high speed?
> > > >
> > > > If SuperSpeed enumeration fails, say because the device doesn't
> > have
> > > > any SuperSpeed descriptors, xhci-hcd doesn't fall back to high
> > speed,
> > > > does it?  dummy-hcd should behave the same way.
> > >
> > > it should at least. Isn't that what happens between EHCI/OHCI ? HS
> > Chirp
> > > sequencing fails, then we fall back to FullSpeed.
> >=20
> > That's a failure in initialization, not a failure in enumeration.
> >=20
> > There are two reasons why the HS chirp might fail: the device doesn't
> > support high speed operation or hardware errors prevent the chirp from
> > working.  With dummy-hcd there are no hardware errors (because there's
> > no hardware).
> >=20
> > As for whether or not the device supports high-speed or SuperSpeed
> > operation, that's determined by the usb_gadget_driver->speed field.  If
> > the field doesn't specify SuperSpeed then dummy-hcd should connect the
> > gadget to the USB-2 root hub rather than the USB-3 root hub.  Isn't
> > that what Tatyana's patch does?  It contains a line saying:
> >=20
> > 		dum->gadget.speed =3D driver->speed;
>=20
> You're right. This is exactly what is done with a small update: if
> is_super_speed=3Dfalse the gadget will connect to a USB2 root hub even if=
=20
> driver->speed=3DUSB_SPEED_SUPER. In that case dum->gadget.speed will be s=
et to
> USB_SPEED_HIGH. The code that sets this now is:
> 	if (mod_data.is_super_speed)
> 		dum->gadget.speed =3D driver->speed;
> 	else
> 		dum->gadget.speed =3D min((u8)USB_SPEED_HIGH,

ok ok, I took a closer look at the original patches and you're changing
drivers->speed to super before converting the gadget drivers to
superspeed. That's what's making enumeration fail on all those guys.

> > > >> It seems like you really
> > > >> need to handle both speeds and the speed fall back parameter in
> > the same
> > > >> driver.  Isn't there some other gadget driver that has a fall back
> > to
> > > >> full or low speed when high speed enumeration fails?
> > > >
> > > > That's a property of the gadget driver, not the UDC driver.  dummy-
> > hcd
> > > > is a UDC driver (and an HCD too).
> > >
> > > USB3.0 dummy_hcd should still enumerate USB2.0 gadget drivers.
> >=20
> > Yes, certainly it should.  If it doesn't, that's a bug, not a design
> > error.
> >=20
>=20
> This version of dummy_hcd enumerates HS devices without any issues.

that's not what I saw, but then again, maybe you changed driver->speed
to super and didn't provide superspeed descriptors.

--=20
balbi

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN24XpAAoJEAv8Txj19kN1zvoH/00/pLwiNaVrq885GziGaALq
vCvS9F02UVbgk9/saXfy9EYW4zYz4lAtM7CnJSv3c8WvGBFjCLYTR9xu4KHV2KKd
UfixsbYcBgRGAE4yNGImD823ptw100yaSuAAvDHwSQCFaMFcvYM5NORBlMmhCsgh
zJF9nQR4V6fuTFMrgYAO8STPIkvMfUHW9nyWNfO0JP0Wbk4pWqOmAFM8h2dad0TS
ZXqKzFoABi28y1m3S5Ito4Xa2ol+GF+ztTAquNMq3vZEPgZUAKi2DKpBmfaWsu1b
r0YCoSQz7VqWwxETuCGaGFVhT3Pyf/dAFGlGVBjm/WFbq01uSg1PcQ/J/T3DHxQ=
=lRgX
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
