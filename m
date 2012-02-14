Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911Ab2BNPDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:03:24 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:35577 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2BNPDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:03:21 -0500
Date: Tue, 14 Feb 2012 18:04:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] adis16080: fix compiler -Wuninitialized
Message-ID: <20120214150455.GN4141@mwanda>
References: <1329230136-26576-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2+jOUFLb7N+7fooZ"
Content-Disposition: inline
In-Reply-To: <1329230136-26576-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F3A77A9.0066,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2+jOUFLb7N+7fooZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 14, 2012 at 03:35:36PM +0100, Danny Kukawka wrote:
> Fix for:
> drivers/staging/iio/gyro/adis16080_core.c: In function
>   =E2=80=98adis16080_read_raw=E2=80=99:
> drivers/staging/iio/gyro/adis16080_core.c:99:8: warning: =E2=80=98ut=E2=
=80=99
>   may be used uninitialized in this function [-Wuninitialized]
>=20
> Initialize ut and change error handling from adis16080_read_raw().
>=20
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/staging/iio/gyro/adis16080_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/iio/gyro/adis16080_core.c b/drivers/staging/=
iio/gyro/adis16080_core.c
> index 1815490..e0b2a29 100644
> --- a/drivers/staging/iio/gyro/adis16080_core.c
> +++ b/drivers/staging/iio/gyro/adis16080_core.c
> @@ -82,7 +82,7 @@ static int adis16080_read_raw(struct iio_dev *indio_dev,
>  			     long mask)
>  {
>  	int ret =3D -EINVAL;
> -	u16 ut;
> +	u16 ut =3D 0;
>  	/* Take the iio_dev status lock */
> =20
>  	mutex_lock(&indio_dev->mlock);
> @@ -94,7 +94,7 @@ static int adis16080_read_raw(struct iio_dev *indio_dev,
>  		if (ret < 0)
>  			break;
>  		ret =3D adis16080_spi_read(indio_dev, &ut);
> -		if (ret < 0)
> +		if (ret)
>  			break;

Either one of these changes would silence the warning from gcc
(which is a false positive).  I would keep the "ut =3D 0;" change and
leave the error handling the same.  That way we check for less than
zero consistently instead of checking some for non-zero and some for
less than zero.

I normally wouldn't have commented on this if the changelog had said
whether it was a gcc false positive or if the code changes the
behavior.  It really should be mentioned.

If you could put a "Staging:" and an "iio" in the subject, that
would be grand as well.  Everyone seems to be using the prefix
"staging:iio:gyro:adis16080" for that file...  I don't know why they
don't just use slashes if they're going to specify the whole file...

regards,
dan carpenter

--2+jOUFLb7N+7fooZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOngWAAoJEOnZkXI/YHqRxKYP/0OCSSGu04qSlMk7aAPh4rLF
oNov1v/glG7wJ4K66rkX9pUSON2jzv3Zpjdth4pzw7sKOpNgxxR9DSx97Sgp2IKO
D0poK4JCN/xVDf5awfgl42KjCKOo3A7O5nT452ijfvzKzddoheP96aT8EzikrLnl
SkM9NIcx1tfNjoPqSTkhCaCw0pE5NlN/9X/3yZALrclWz2OikFh0y6RISGzQ6IT7
wTdQ1nkZafGb+ch8Cqt6JE2cxiSV5zTxd5qk/MlrWVjz3FFsEZzMRMtzuIjf6XdN
+tb1lUwzzqA5dud/4b87wRrMVVucLUtvaL6FaHtgux5oloNk4vwtmBAM1Vv5u65C
az+LpDOaG6ZhxEKQlEtfKA1Ur3xPQXK+Zn65B2p/3hpJmp/zE43P1n9VUlPPhm7y
SPJEQnQr53FybxzV5zKKuibF+F2nBIAPOosFU5xMiFnZqdOil8YaHnjBJrnIghkC
08ehZ1WDAhEZD2ZpxWWyB0Hr+J5tN6AF1O61wEmimdbliXV5y7kCsLjuFBOlwEt+
fPb5TR4z+zL+OD19bQiP6geCQdK3EtwR0aohJ6vjNFZEeaSYE95SKFfPbWaiWyZU
EUlSiUz47gDE/VunJm+yaIov8jCC9mnE5ldviUE7ba1jjyh1yVLa8OWdwG4FPxpB
eew5XZY0JoKNeUgNCf6L
=txan
-----END PGP SIGNATURE-----

--2+jOUFLb7N+7fooZ--
