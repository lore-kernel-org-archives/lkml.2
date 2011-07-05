Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab1GEMMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:12:25 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:48518 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147Ab1GEMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:12:24 -0400
Date: Tue, 5 Jul 2011 15:12:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH 1/5] MFD: twl6040: Add irq variable for slave devices
Message-ID: <20110705121218.GD2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309857266-3663-1-git-send-email-peter.ujfalusi@ti.com>
 <1309857266-3663-2-git-send-email-peter.ujfalusi@ti.com>
 <20110705112245.GA2820@legolas.emea.dhcp.ti.com>
 <3328261.Ltcx4CEcHA@barack>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ExIO7AL6tcaLjJBF"
Content-Disposition: inline
In-Reply-To: <3328261.Ltcx4CEcHA@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ExIO7AL6tcaLjJBF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 03:09:06PM +0300, P=E9ter Ujfalusi wrote:
> On Tuesday 05 July 2011 13:22:46 Balbi, Felipe wrote:
> > Hi,
> >=20
> > On Tue, Jul 05, 2011 at 12:14:22PM +0300, Peter Ujfalusi wrote:
> > > Add new variable to pass the irq number for the slaves
> > > devices of twl6040.
> > > The irq number configuration is done in the twl6040-core
> > > at probe time, so machine drivers do not need to be
> > > modified.
> > >=20
> > > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > > ---
> > >=20
> > >  drivers/mfd/twl6040-core.c |    2 ++
> > >  include/linux/i2c/twl.h    |    2 ++
> > >  2 files changed, 4 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
> > > index cfaedb5..8607793 100644
> > > --- a/drivers/mfd/twl6040-core.c
> > > +++ b/drivers/mfd/twl6040-core.c
> > > @@ -501,6 +501,7 @@ static int __devinit twl6040_probe(struct
> > > platform_device *pdev)
> > >=20
> > >  	if (pdata->codec) {
> > >  =09
> > >  		cell =3D &twl6040->cells[children];
> > >  		cell->name =3D "twl6040-codec";
> > >=20
> > > +		pdata->codec->plug_irq =3D twl6040->irq_base + TWL6040_IRQ_PLUG;
> >=20
> > are the slave devices platform_devices ?? If so, you could use struct
> > resource to pass IRQs as that's the "approved" way to do so. Then, on
> > child driver, you could either rely on a particular order of the
> > resources or assign them names and use platform_get_irq_byname() to
> > fetch the correct one (if you have more than one, that is).
>=20
> You mean something like this:
>=20
> static struct resource twl6040_codec_rsrc[] =3D {
> 	{
> 		.flags =3D IORESOURCE_IRQ,
> 	},
> };
>=20
> ...
>=20
> @@ -501,6 +501,7 @@ static int __devinit twl6040_probe(struct platform_de=
vice=20
> *pdev)
> 		if (pdata->codec) {
> 			cell =3D &twl6040->cells[children];
> 			cell->name =3D "twl6040-codec";
> +			twl6040_codec_rsrc[0].start =3D twl6040->irq_base + TWL6040_IRQ_PLUG;
> +			twl6040_codec_rsrc[0].end =3D twl6040->irq_base + TWL6040_IRQ_PLUG;
> +			cell->resource =3D twl6040_codec_rsrc;
> +			cell->num_resources =3D ARRAY_SIZE(twl6040_codec_rsrc);
> 			cell->platform_data =3D pdata->codec;
> 			cell->pdata_size =3D sizeof(*pdata->codec);
> 			children++;
>=20

yes, that's what I meant :-)

--=20
balbi

--ExIO7AL6tcaLjJBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEv+iAAoJEAv8Txj19kN1fm4H/3KBklcX0XHcPSxBaJu1jE9r
lwUX86BlJkcnD+OcbV7IplL7vJMS9m/tbWJCpnX75gyBGQeOgM1RPerfdRk+EkzO
wWyNO1ZHIr6jxa0p2dHuDmIIR36Lhew6p5Eb/deimD2vVIs0lBEums8nCIlq9kwi
fLPPn8bc4P9j0EHkThPNTpEI5oLeKRriILUvZD3o2uaLFW8jXk3eJk8DsIjYtxxS
sIxlIPT18tj7Q5sHtiL72bKeI55xcbLmluZRTvd5qvcW1FXi4qO6DGZgQTGgn/zp
7ZE+j9rgWbSY/Lwq8eAwl8shmmiazutlnSFptyfC/czEbhJJDxVKJdHO8DKXT5c=
=TT7L
-----END PGP SIGNATURE-----

--ExIO7AL6tcaLjJBF--
