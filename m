Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1K3Gf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:35:28 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61644 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1K3Gf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:35:27 -0500
Date: Wed, 30 Nov 2011 09:35:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: gregkh@suse.de, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:iio: Use kcalloc instead of kzalloc to allocate
 array
Message-ID: <20111130063523.GS3195@mwanda>
References: <1322600880.1534.334.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpljlC28XhFjURzf"
Content-Disposition: inline
In-Reply-To: <1322600880.1534.334.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4ED5CE91.007E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IpljlC28XhFjURzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2011 at 10:08:00PM +0100, Thomas Meyer wrote:
> The advantage of kcalloc is, that will prevent integer overflows which co=
uld
> result from the multiplication of number of elements and size and it is a=
lso
> a bit nicer to read.
>=20
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
>=20
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>=20
> diff -u -p a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging=
/iio/accel/lis3l02dq_ring.c
> --- a/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-13 11:07:47.9338=
26988 +0100
> +++ b/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-28 20:00:44.7044=
46880 +0100
> @@ -93,8 +93,7 @@ static int lis3l02dq_read_all(struct iio
>  	struct spi_message msg;
>  	int ret, i, j =3D 0;
> =20
> -	xfers =3D kzalloc((buffer->scan_count) * 2
> -			* sizeof(*xfers), GFP_KERNEL);
> +	xfers =3D kcalloc((buffer->scan_count) * 2, sizeof(*xfers), GFP_KERNEL);

I've looked at these and none of them can actually overflow.

But if they could then there would still be the potential for
overflow here.  If buffer->scan_count were a negative number then
the first for loop could cause memory corruption.

Still it's a cleanup and the patch is fine.

regards,
dan carpenter

--IpljlC28XhFjURzf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO1c6rAAoJEOnZkXI/YHqRWLgQAIi7qxtNK76PMUYSjgm6mWza
bcl43c3ISrtPJmSQmQ/DMIaAOLzsmX//bLSIWfDxfKXUNWJduFDnmOg/AKDK+/VX
EWYeAMlQNc2aBiT3hVE2cVmcxTm9rYuRpSrDYaHvg7/V28sRDNVjWaW2KrOsK99J
+bTRVRJxS0Ts0mRfjasr1Vhb7X+l3MBtC0HrjrvYgMRvmqHU5QEtNoheCNBqebmw
GO8Qg7P3R0ZkacQDfLCI+gy1jkTkc7cAxKgGyl+VHX4xPNuGX9/6tWpB+O+O0ACl
kYwPhpuO0PF1oqivWZLDUlONHG5FSi8ZawxCxKF6F1riYmdo/fdGFA52iRPzmQtv
QmC3w9stbFDZHwrFPb6N8FfTqHl3tIf7Ulto11NaY735YfF2Zfv5Nd8Oghk89x85
TL+JYTMt8zPtCbbUmFqUsbjmvwMAKYMbdlON8uOGazoQ3hVervzGgBkSH1tW/gqe
zNYZA1zT6mnr59lWr1uVoUOXV1lEuUix4/uljaxwZJdgSdiNV9u0Pgc89SdaVabm
ecrmu14/1AQkQWH1G/n6vpAxr+Yvv3lq7g5Q5apGxOpm+Vv0iApXEHTEl9jeHm3Z
AbYmJz7NHYtyxC4IKivKHG864Ws90wn0orRRB9xMR7a5od9EduzcjBx5Uw/QFP+J
zXnlkNGoU9nzsKd/dxbA
=o/YP
-----END PGP SIGNATURE-----

--IpljlC28XhFjURzf--
