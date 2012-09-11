Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab2IKLaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:30:04 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29789 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab2IKLaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:30:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsDAFcgT1BbdWObgWdsb2JhbABFhgetJ4giIgEBFiYngiABAQUjBEASEAsVAyoCAlcGE4gUqGOTOIsQhRSBEgOoYg
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="asc'?scan'208";a="564501308"
Message-ID: <1347363066.4539.112.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 08/20] Staging: ipack: Switch to 8MHz operation before
 reading ID.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Tue, 11 Sep 2012 13:31:06 +0200
In-Reply-To: <20120911084818.GP19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
	 <1347267118-9580-8-git-send-email-siglesias@igalia.com>
	 <20120911084818.GP19396@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qDTWk/qddxeIAKnSneq2"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qDTWk/qddxeIAKnSneq2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-11 at 11:48 +0300, Dan Carpenter wrote:
> On Mon, Sep 10, 2012 at 10:51:46AM +0200, Samuel Iglesias Gons=C3=A1lvez =
wrote:
> > From: Jens Taprogge <jens.taprogge@taprogge.org>
> >=20
> > Reading the ID space at 8 MHz is always supported.  Most carriers will
> > boot up in 8MHz mode.  Still, play it safe and ensure we are operating =
at
> > 8Mhz.
> >=20
> > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > Signed-off-by: Samuel Iglesias Gons=C3=A1lvez <siglesias@igalia.com>
> > ---
> >  drivers/staging/ipack/ipack.c |   11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipac=
k.c
> > index 4f3c945..95f56b8 100644
> > --- a/drivers/staging/ipack/ipack.c
> > +++ b/drivers/staging/ipack/ipack.c
> > @@ -376,6 +376,9 @@ struct ipack_device *ipack_device_register(struct i=
pack_bus_device *bus,
> >  	dev_set_name(&dev->dev,
> >  		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
> > =20
> > +	if (bus->ops->set_clockrate(dev, 8))
> > +		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading=
 of device ID.\n");
> > +
> >  	ret =3D ipack_device_read_id(dev);
> >  	if (ret < 0) {
> >  		dev_err(&dev->dev, "error reading device id section.\n");
> > @@ -384,9 +387,11 @@ struct ipack_device *ipack_device_register(struct =
ipack_bus_device *bus,
> >  	}
> > =20
> >  	/* if the device supports 32 MHz operation, use it. */
> > -	ret =3D bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
> > -	if (ret < 0)
> > -		dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> > +	if (dev->speed_32mhz) {
> > +		ret =3D bus->ops->set_clockrate(dev, 32);
> > +		if (ret < 0)
> > +			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> > +	}
>=20
> Ah.  Well done.  That's what I suggested earlier.  I think you
> should get rid of the ->speed_8mhz all together.

I will do it in a follow-up patch. The rest of suggestions have been
integrated in the patches. I will submit the patches very soon.

Thanks,

Sam=20


--=-qDTWk/qddxeIAKnSneq2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBPIPoACgkQWrfbyfmd9eJjpQCgrtG7im6FIJPVmpNaWRUZF8dW
9uAAn1efGBX3GjUkINtEjMwCdWIhYPB5
=cG4n
-----END PGP SIGNATURE-----

--=-qDTWk/qddxeIAKnSneq2--

