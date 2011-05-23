Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1EWIcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:32:32 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45287 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab1EWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:32:30 -0400
Date: Mon, 23 May 2011 11:32:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110523083208.GM3095@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-8-git-send-email-tlinder@codeaurora.org>
 <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
 <00a301cc1919$f0e1fa00$d2a5ee00$@org>
 <20110523072142.GK3095@legolas.emea.dhcp.ti.com>
 <00cc01cc1922$0fb4ee80$2f1ecb80$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xtx0sNU5lZ46KfgK"
Content-Disposition: inline
In-Reply-To: <00cc01cc1922$0fb4ee80$2f1ecb80$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xtx0sNU5lZ46KfgK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Mon, May 23, 2011 at 11:18:53AM +0300, Tanya Brokhman wrote:
> > > > > +
> > > > > +static struct dummy_hcd_module_parameters mod_data =3D {
> > > > > +	.is_super_speed =3D false
> > > > > +};
> > > > > +module_param_named(is_super_speed, mod_data.is_super_speed,
> > bool,
> > > > > +S_IRUGO); MODULE_PARM_DESC(is_super_speed, "true to simulate
> > > > > +SuperSpeed connection");
> > > >
> > > > you shouldn't need this. You should always enable SuperSpeed for
> > > > this driver.
> > >
> > > You mean I don't need the module parameter? IMO it's the best way to
> > > enable HS connection. If driver->speed=3DUSB_SPEED_SUPER than dummy_h=
cd
> > > will try to enumerate the device on the SS root hub and if the gadget
> > > didn't provide SS descriptors - it will fail. Just as it happened
> > > before. Finding out from
> >=20
> > then it should hand the device over to the hs_hcd ;-) Meaning it would
> > disconnect the device, switch to hs_hcd and reconnect :-)
>=20
> Yes this will be the best solution :) But as I said, the enumeration occu=
rs
> not in dummy_hcd thus I'm not sure how dummy_hcd can find out that it fai=
led

take a look at xhci-ring.c for an example :-)

see that it check whether the attached device is a USB3.0 device or
USB2.0/1.1 device and chooses hcd or shared_hcd accordingly.

> in order to reconnect the device to hs_hcd. And I'm not sure that dummy_h=
cd
> should care whether the enumeration succeeds or fails. It seems to me that
> this should be handled by upper levels. Shouldn't it?

nope. If dummy_hcd was a SW xhci implementation then it should be taken
care by upper layers, but since this is a complete SW non-standard Host
interface, then we need to handle the whole thing.

> But we're discussing a more general issue; do you remember what the usb30
> spec sais about this? I mean when connecting a HS device to a SS port (ov=
er

not the exact wording of the Specs but it should work :-)

> SS cable), should it still enumerate as a HS device? It seems to me that =
the
> answer is no but I'm not sure...

the USB3 host shouldn't enumerate but it has the shared_hcd which is
USB2.0 compliant.

> > > dummy_hcd that the enumeration failed is very complicated (if even
> > > possible) and I'm not sure that is the right thing to do... If you
> > > connect a real device over SS port to xHCI and the device doesn't
> > > provide SS descriptors - the enumeration fails and it's ok. But if
> > you
> > > connect the same device to a HS port - it should work properly. This
> > > is what I tried to simulate with this parameter.
> >=20
> > it doesn't just fails, it gives the device over to the shared_hcd :-)
> >=20
>=20
> Hmmm.... I have v2.6.38 installed on my Linux-host at the moment and I ju=
st
> verified that when connecting a Gadget driver without SS descriptors over=
 SS
> connection - the enumeration fails. Was this fixed in v2.6.39? It will ta=
ke
> me some time to upgrade to v2.6.39  and verify but I have to do it any way
> so I'll give it a shot...

Maybe Sarah can give more details on this one. Sarah, what happens if we
attach USB2.0 device to USB3.0 roothub ?

--=20
balbi

--xtx0sNU5lZ46KfgK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2huIAAoJEAv8Txj19kN15OQH/jyc5FDyq/vJxrHtEDzYAr0S
CdaOtr5/5ffk7nIBdUUoMs4AUUirNvnOpSgya47lhph6nkGCRL/L0um51ZwBLQMW
clQh8wCabmbT8glAHrJtjYFFeJWNXfhEDi1V9ui4HOLOxSXNIpdx8gKIhecFX14e
+b3KL7Mccr/KJWb8NUiYvFtbDPC15eT7miOg9pq8YvpNtV9Ic6qRmOBEnOK9XYDm
0ZYyOzaO3/7sft+FPDiv1SLmQZRmudpM/AT5hJ6TH5UPYTlRhStwBBF3gXwWa3p+
tEDNlvtJOnTcwTzSlD7etsaWvK9ZJ3ZaBaGWnv4dOwYbq8Y8EOeEPj4ExsPwJSo=
=7Lir
-----END PGP SIGNATURE-----

--xtx0sNU5lZ46KfgK--
