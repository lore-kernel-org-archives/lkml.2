Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1EWHVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:21:54 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:38232 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab1EWHVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:21:53 -0400
Date: Mon, 23 May 2011 10:21:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110523072142.GK3095@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-8-git-send-email-tlinder@codeaurora.org>
 <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
 <00a301cc1919$f0e1fa00$d2a5ee00$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/+CTqSGWdiRg+8j"
Content-Disposition: inline
In-Reply-To: <00a301cc1919$f0e1fa00$d2a5ee00$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/+CTqSGWdiRg+8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 23, 2011 at 10:20:45AM +0300, Tanya Brokhman wrote:
> > > diff --git a/drivers/usb/gadget/dummy_hcd.c
> > > b/drivers/usb/gadget/dummy_hcd.c index bf7981d..c2731d3 100644
> > > --- a/drivers/usb/gadget/dummy_hcd.c
> > > +++ b/drivers/usb/gadget/dummy_hcd.c
> > > @@ -70,6 +70,15 @@ MODULE_DESCRIPTION (DRIVER_DESC);  MODULE_AUTHOR
> > > ("David Brownell");  MODULE_LICENSE ("GPL");
> > >
> > > +struct dummy_hcd_module_parameters {
> > > +	bool is_super_speed;
> > > +};
> > > +
> > > +static struct dummy_hcd_module_parameters mod_data =3D {
> > > +	.is_super_speed =3D false
> > > +};
> > > +module_param_named(is_super_speed, mod_data.is_super_speed, bool,
> > > +S_IRUGO); MODULE_PARM_DESC(is_super_speed, "true to simulate
> > > +SuperSpeed connection");
> >=20
> > you shouldn't need this. You should always enable SuperSpeed for this
> > driver.
>=20
> You mean I don't need the module parameter? IMO it's the best way to enab=
le
> HS connection. If driver->speed=3DUSB_SPEED_SUPER than dummy_hcd will try=
 to
> enumerate the device on the SS root hub and if the gadget didn't provide =
SS
> descriptors - it will fail. Just as it happened before. Finding out from

then it should hand the device over to the hs_hcd ;-) Meaning it would
disconnect the device, switch to hs_hcd and reconnect :-)

> dummy_hcd that the enumeration failed is very complicated (if even possib=
le)
> and I'm not sure that is the right thing to do... If you connect a real
> device over SS port to xHCI and the device doesn't provide SS descriptors=
 -
> the enumeration fails and it's ok. But if you connect the same device to a
> HS port - it should work properly. This is what I tried to simulate with
> this parameter.

it doesn't just fails, it gives the device over to the shared_hcd :-)

--=20
balbi

--W/+CTqSGWdiRg+8j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2gsGAAoJEAv8Txj19kN1ev4H/0Se7DrwyDGCEY7y55PGSnGm
EPTLLruY6/km+A5gg5TT4NbJmHEj2CR280wcv71/gfx4PPdL5/QHzwzIS8Amn2/Q
/EXk29rMolcZRewxt5S8+eGGuMHiNp44nTxjNHGzHyTDZyw3fZSj5Jmc7e++792C
JlxtlXHtND1mxRd7dV95F2NAfsWOghEKteB1/ZjTe1VvZaK4sfMU2AOxC3WAV5u7
1GzygmPnnjJ8+BQ3Tj4RCP8IOoVyhR9EGcNn8dihdxm+gT9Duy3A6xr2x1/uPP+W
XhhHBX0Qx2TK+dCkv/yXeIXdMl1MF82n+s0Buxp/yuYLbD+/R41rzpUszF1NpuM=
=mh+i
-----END PGP SIGNATURE-----

--W/+CTqSGWdiRg+8j--
