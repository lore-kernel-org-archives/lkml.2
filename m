Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1JXIMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:12:50 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54275 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727Ab1JXIMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:12:48 -0400
Date: Mon, 24 Oct 2011 11:12:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: balbi@ti.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: DeviceTree and children devices
Message-ID: <20111024081244.GD15288@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111024064227.GW5453@legolas.emea.dhcp.ti.com>
 <20111024074124.GB8708@ponder.secretlab.ca>
 <20111024074957.GB15288@legolas.emea.dhcp.ti.com>
 <CACxGe6v0kHNyO81XapR=jGEa8ZgJrUxN2EEiqW7c18NdurGNkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
Content-Disposition: inline
In-Reply-To: <CACxGe6v0kHNyO81XapR=jGEa8ZgJrUxN2EEiqW7c18NdurGNkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ey/N+yb7u/X9mFhi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2011 at 09:58:39AM +0200, Grant Likely wrote:
> On Mon, Oct 24, 2011 at 9:49 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Mon, Oct 24, 2011 at 09:41:24AM +0200, Grant Likely wrote:
> >> On Mon, Oct 24, 2011 at 09:42:28AM +0300, Felipe Balbi wrote:
> >> > then I can drop the dwc3 platform_device allocation and all of that
> >> > resource copying, etc.
> >> >
> >> > What do you think ?
> >>
> >> Looks reasonable to me. =A0of_platform_populate() should be able to
> >> handle the device generation for you here.
> >
> > Ok cool I looking into that and it handles everything I need. There are
> > only three issues which I see:
> >
> > a) it hardcoded DMA mask to 32-bit. Right ?
> > b) it's not using dma_set_coherent_mask()
> > c) in case parent is a valid pointer, shouldn't it copy DMA mask from
> > =A0 =A0 =A0 =A0parent ?
> >
> > I mean (doesn't solve (a) above):
> >
> > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > index ed5a6d3..172d4a9 100644
> > --- a/drivers/of/platform.c
> > +++ b/drivers/of/platform.c
> > @@ -204,7 +204,12 @@ struct platform_device *of_platform_device_create_=
pdata(
> > =A0#if defined(CONFIG_MICROBLAZE)
> > =A0 =A0 =A0 =A0dev->archdata.dma_mask =3D 0xffffffffUL;
> > =A0#endif
> > - =A0 =A0 =A0 dev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32);
> > +
> > + =A0 =A0 =A0 if (parent)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_set_coherent_mask(&dev->dev, parent->=
coherent_dma_mask);
> > + =A0 =A0 =A0 else
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_set_coherent_mask(&dev->dev, DMA_BIT_=
MASK(32));
> > +
>=20
> Right, this does need to be fixed.  The existing code just matched
> what the historical powerpc code did, but it is certainly not correct.

should I send patch above correctly ? Or do you want to also solve
32-bit coherent mask altogether ? What are your plans for that ? Add a
separate property to pass coherent_mask size (32-bit, 64-bit, etc) ?

--=20
balbi

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpR38AAoJEIaOsuA1yqREpyoP/Ra08Rlx0X4G8MkWR4r/Warf
0/b+tcs8nzUIFWgYN6Tz6t8CkrV3IqBi2cGW4ZosCkFmmxHXui5BgHsLTgapZ9Lc
cYvTla2He4maN8zLsOsAPbFhJ38ZrMQUZwMPik1uzTpbprUSU38i2fAKIn52n1yF
cf5GwmpDXBvHKMVUJcqUUx1DTBRVuzk7wLZoX3tUoLY4XCzgJwBvDpi9xNbdayXy
9b5e5ALubzsHGXUg9NRHWKGXn8czG7ThhQvfkC+5sCpfhesKAPBAZ5T66Z4CQjcO
mwrfBIHc84u9gXC3t2Xq/q9kUhSs/HyP04TPPahZX8kB/H9Yp1KIW54AoFXV2Owg
+AmAh+R5QLwm1fKlH3jA3DhQwjJYLS4Ooe0OzRWLrS1eoLNWW9fD9XGdvNMOwtQk
RnVM8TPvx60ZBFPr2sp8LOtOITOBbFqdcVTBQ+jI0Lw9F/mjvIfq48C1CFD7qjx4
EWRtI/HaetcM7Dy/MAH+xZWL0gvTlLSUjZ9w7p3GmIZmAWXiL1FOBrkrCUmDeyZc
rgTX6S/Vtp9/CjRE1j7rDTZPTrWditgVv7LwJ+p5A7vnQFj6FugG5jn91LeHnEbu
QALGjzj/y1EUX7hWQFw2k3fU+RCF4qmAat1dnApnMUbg88dTaucLSq/M/vqQ5eT4
I4Oc90iLgIozDtlaoSWv
=iVII
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
