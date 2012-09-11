Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab2IKOi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:38:28 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:60423 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2IKOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:38:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsDAIBLT1BbdWObgWdsb2JhbABFhgetJ4giIgEBFiYngiABAQQBIwRABwsFCwsVAyoCAlcGExuHbwqoP5M0ixCFFIESA6hi
X-IronPort-AV: E=Sophos;i="4.80,405,1344204000"; 
   d="asc'?scan'208";a="564687889"
Message-ID: <1347374377.4539.115.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 08/20] Staging: ipack: Switch to 8MHz operation before
 reading ID.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Date: Tue, 11 Sep 2012 16:39:37 +0200
In-Reply-To: <20120911113919.GA7174@endeavour.taprogge.org>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
	 <1347267118-9580-8-git-send-email-siglesias@igalia.com>
	 <20120911084818.GP19396@mwanda>
	 <1347363066.4539.112.camel@fourier.local.igalia.com>
	 <20120911113919.GA7174@endeavour.taprogge.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rzSt1dpzBlVgXwmodpIk"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rzSt1dpzBlVgXwmodpIk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-11 at 13:39 +0200, Jens Taprogge wrote:
> On Tue, Sep 11, 2012 at 01:31:06PM +0200, Samuel Iglesias Gons=C3=A1lvez =
wrote:
> > On Tue, 2012-09-11 at 11:48 +0300, Dan Carpenter wrote:
> > > On Mon, Sep 10, 2012 at 10:51:46AM +0200, Samuel Iglesias Gons=C3=A1l=
vez wrote:
> > > > From: Jens Taprogge <jens.taprogge@taprogge.org>
> > > >=20
> > > > Reading the ID space at 8 MHz is always supported.  Most carriers w=
ill
> > > > boot up in 8MHz mode.  Still, play it safe and ensure we are operat=
ing at
> > > > 8Mhz.
> > > >=20
> > > > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > > > Signed-off-by: Samuel Iglesias Gons=C3=A1lvez <siglesias@igalia.com=
>
> > > > ---
> > > >  drivers/staging/ipack/ipack.c |   11 ++++++++---
> > > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/=
ipack.c
> > > > index 4f3c945..95f56b8 100644
> > > > --- a/drivers/staging/ipack/ipack.c
> > > > +++ b/drivers/staging/ipack/ipack.c
> > > > @@ -376,6 +376,9 @@ struct ipack_device *ipack_device_register(stru=
ct ipack_bus_device *bus,
> > > >  	dev_set_name(&dev->dev,
> > > >  		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
> > > > =20
> > > > +	if (bus->ops->set_clockrate(dev, 8))
> > > > +		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for rea=
ding of device ID.\n");
> > > > +
> > > >  	ret =3D ipack_device_read_id(dev);
> > > >  	if (ret < 0) {
> > > >  		dev_err(&dev->dev, "error reading device id section.\n");
> > > > @@ -384,9 +387,11 @@ struct ipack_device *ipack_device_register(str=
uct ipack_bus_device *bus,
> > > >  	}
> > > > =20
> > > >  	/* if the device supports 32 MHz operation, use it. */
> > > > -	ret =3D bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
> > > > -	if (ret < 0)
> > > > -		dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> > > > +	if (dev->speed_32mhz) {
> > > > +		ret =3D bus->ops->set_clockrate(dev, 32);
> > > > +		if (ret < 0)
> > > > +			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> > > > +	}
> > >=20
> > > Ah.  Well done.  That's what I suggested earlier.  I think you
> > > should get rid of the ->speed_8mhz all together.
> >=20
> > I will do it in a follow-up patch. The rest of suggestions have been
> > integrated in the patches. I will submit the patches very soon.
>=20
> I have not seen any IPack V2 device yet.  But since the ID space
> provides the 8MHz flag, it might be useful.  On the other hand, we can
> still readd it when we see it.
>=20

If we have the flag, we should use it in some point. Not only save it in
the variable speed_8mhz and don't use it at all.

> When you remove the flag, you can perhaps leave a comment in the code so
> that it is easy to re-enable.
>=20

OK. I will send a patch in Industry Pack mailing list and we can discuss
there if this is a good solution or not before sending to staging ML.

Thanks,

Sam


--=-rzSt1dpzBlVgXwmodpIk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBPTSkACgkQWrfbyfmd9eIiTgCeKM6nHxtPpEc5iYnqXcFnEJUJ
12IAniMBuvuxUPTJBcjhoMsDcqCwoUJW
=5KHq
-----END PGP SIGNATURE-----

--=-rzSt1dpzBlVgXwmodpIk--

