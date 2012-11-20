Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2KTBF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:05:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51407 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685Ab2KTBF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:05:58 -0500
Date: Tue, 20 Nov 2012 10:05:49 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: DVS regulator drivers
Message-ID: <20121120010547.GD4483@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1211191213380.11024@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211191213380.11024@axis700.grange>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2012 at 12:52:09PM +0100, Guennadi Liakhovetski wrote:
> As I mentioned in an earlier mail today [1] I have a difficulty seeing ho=
w=20
> the current regulator API can efficiently be used for DVS-type regulators=
=2E=20

Please don't invent terminology or repurpose existing terminology like
this, it's just confusing - obvious essentially all regulators covered
by the regulator API support voltage scaling which is the usual meaning
of DVS.

> wm831x-dcdc.c handles 2 voltages: "DVS" and "ON." If the new voltage in=
=20
> .set_voltage_sel() is equal to one of them, it is just used. If it is a=
=20
> new voltage, there's a comment in the driver in=20
> wm831x_buckv_set_voltage_sel():

> 	/* Always set the ON status to the minimum voltage */

> but I actually don't see, where the minimum is selected. It seems instead=
=20
> in this case the "ON" value is just set:

> 	ret =3D wm831x_set_bits(wm831x, on_reg, WM831X_DC1_ON_VSEL_MASK, vsel);
> 	if (ret < 0)
> 		return ret;
> 	dcdc->on_vsel =3D vsel;

Can you be more specific about your concern here?  The above code does
exactly what the comment says, it will set the selector it just picked.

You did spot one bug (I think due to bitrot) which I just fixed but in
general I've just TLDRed this as it's a bit unclear what you're trying
to say here, can you be a bit more concise here?  I'm not sure if
there's a general point or if it's specific code issues?

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqtdFAAoJELSic+t+oim9HfsQAIeFtKm5XIxe/QM3V9yxyT09
eB4i8hJGIPKqteMNPA1iJS8Q/IVKodcxczovJL5loD5zqSId29gj+GGzwz0tLN9/
VbXcZM/cMv56s5G/lq3igjl132Rt1DwfOGeNPtbm33KMqd/AKxu9a6yjAGCxeLGS
gq05yVVAg3o60XHYIwKksiKLwePpMls9ThRX/H4F0J38Vhi2EP51/794YSAp9tQH
PqXAN/2RQREV3yVF+MnA/hs8v+w4ci4o8E0f4wIOU4nLn1mTntHjprdAFAP89w2t
+rwnRhXcrH/4zQOtlB1vi+gX0V3Ol6XpHfAk6JkJzxRr5tVeqcrLjUWXO9upGzQ6
7KhzHO8jp/R2kJmE3XLTs2edMwQuPlAeY3Qm4etAsCk+Ck6QMMwkrFP31nZxi5ha
amqfFyKdcaDSRwvW8GSKHfe2YX7YZEbOgdXzOPd/AMoRX9PxFzYFxYCLY5g5kDWf
N1dJS2P764M86UR34zC2ZmTRF0C2Wmim8e+rK72Gyf/LIC+tJMArVhZFbxURq2ir
X1Q7yo7BXhrta0pIouBK52TSeQBElSDBAbILkSuRL5f6NetMU+rpor4gXViVZQxj
XS8G0hbSaf4WYoOoQB3N5dk/lmuCS1nqsq75AAJNZeSKQHx/RKrAvyT5/zWmw6Rw
cxhLK2Hju3MlzdiRnyys
=RtPa
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
