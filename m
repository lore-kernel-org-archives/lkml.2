Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2ASJc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:32:56 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43432 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab2ASJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:32:39 -0500
Date: Thu, 19 Jan 2012 12:33:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] [media] ds3000: off by one in ds3000_read_snr()
Message-ID: <20120119093327.GI3356@mwanda>
References: <20120117073021.GB11358@elgon.mountain>
 <4F16FC26.80306@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgY/UHCnsaNnNXRx"
Content-Disposition: inline
In-Reply-To: <4F16FC26.80306@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F17E32E.007E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zgY/UHCnsaNnNXRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 18, 2012 at 06:06:46PM +0100, walter harms wrote:
>=20
>=20
> Am 17.01.2012 08:30, schrieb Dan Carpenter:
> > This is a static checker patch and I don't have the hardware to test
> > this, so please review it carefully.  The dvbs2_snr_tab[] array has 80
> > elements so when we cap it at 80, that's off by one.  I would have
> > assumed that the test was wrong but in the lines right before we have
> > the same test but use "snr_reading - 1" as the array offset.  I've done
> > the same thing here.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >=20
> > diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/f=
rontends/ds3000.c
> > index af65d01..3f5ae0a 100644
> > --- a/drivers/media/dvb/frontends/ds3000.c
> > +++ b/drivers/media/dvb/frontends/ds3000.c
> > @@ -681,7 +681,7 @@ static int ds3000_read_snr(struct dvb_frontend *fe,=
 u16 *snr)
> >  			snr_reading =3D dvbs2_noise_reading / tmp;
> >  			if (snr_reading > 80)
> >  				snr_reading =3D 80;
> > -			*snr =3D -(dvbs2_snr_tab[snr_reading] / 1000);
> > +			*snr =3D -(dvbs2_snr_tab[snr_reading - 1] / 1000);
> >  		}
> >  		dprintk("%s: raw / cooked =3D 0x%02x / 0x%04x\n", __func__,
> >  				snr_reading, *snr);
>=20
> hi dan,
>=20
> perhaps it is more useful to do it in the check above ?

It looks like the check is correct but we need to shift all the
values by one.  Again, I don't have this hardware, I'm just going by
the context.

> thinking about that why not replace the number (80) with ARRAY_SIZE() ?

That would be a cleanup, yes but it could go in a separate patch.

regards,
dan carpenter


--zgY/UHCnsaNnNXRx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPF+NnAAoJEOnZkXI/YHqRu4cQAIwegV2tAdtu3btAoEThma5Q
zPfEiGleuUk7r2fna9OaX3opVPKPzYIWQcWvKR8S0La9lmbzyTpljUlQJMhv4tx0
DpGdnjGvTwzh+3sVzudIdUad3f6Db1GDo4xeWZ17cXF91qkXTUYQwlE6+UeZIZod
UJgTSa0zUTM7FmfpnSsUIPjTMBDCjWhV0VqU6K7pArizGcMkDk5kbKY61tsNHmBe
R0i/WOdDRb3IPEcgZ7MQS3BhXMB8s96G1vI9ddSIqFSKOsY6ov2qBGE2a1KnTiRI
p2aalkI59jzCUrT3zAwP/Es2HsBfqrwih59yIoLetEOuTiq7mTTv4CXebIv/uH7K
RTlgyvULk0+PICTfLSlP18HAzoZxnIElesNdxvo5s/Ou4Fz2nVby0eUlbUblTa5l
6Q5Ki0laV4GEq7r4wl/llD0ozyKWcCD2IqHpTrObBS0MyI/G9IeSB0npCzmzugTu
orRM9Zt86UnPUNbNfCPGnTaeLjPR42qBX9+Ub8evB6ydDY94qKBs4if3e3kTNsGB
F5aCkPU9c9vPCJEvp7C2F84GQ8PayOeZApiavPJZjJBcQ3NPXf6ATE7T1+bZOXA/
IMGf59OBglCpWKfYMhLM1Hb5RjazcP3q06Jq19rACwYv5E49XLaOBOLac1+BF8Pp
AbdLt/eWQGDVqfz4b2SO
=k4bn
-----END PGP SIGNATURE-----

--zgY/UHCnsaNnNXRx--
