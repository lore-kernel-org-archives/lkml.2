Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2IRLrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:47:23 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:49069 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757537Ab2IRLrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:47:21 -0400
Date: Tue, 18 Sep 2012 14:42:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCHv3 5/6] media: Convert struct i2c_msg initialization to
 C99 format
Message-ID: <20120918114224.GH24047@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347968672-10803-1-git-send-email-shubhrajyoti@ti.com>
 <1347968672-10803-6-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nOM8ykUjac0mNN89"
Content-Disposition: inline
In-Reply-To: <1347968672-10803-6-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nOM8ykUjac0mNN89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 05:14:31PM +0530, Shubhrajyoti D wrote:
>         Convert the struct i2c_msg initialization to C99 format. This mak=
es
>         maintaining and editing the code simpler. Also helps once other f=
ields
>         like transferred are added in future.

no need for these tabs here.

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

>=20
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
>  drivers/media/radio/saa7706h.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706=
h.c
> index bb953ef..54db36c 100644
> --- a/drivers/media/radio/saa7706h.c
> +++ b/drivers/media/radio/saa7706h.c
> @@ -199,8 +199,19 @@ static int saa7706h_get_reg16(struct v4l2_subdev *sd=
, u16 reg)
>  	u8 buf[2];
>  	int err;
>  	u8 regaddr[] =3D {reg >> 8, reg};
> -	struct i2c_msg msg[] =3D { {client->addr, 0, sizeof(regaddr), regaddr},
> -				{client->addr, I2C_M_RD, sizeof(buf), buf} };
> +	struct i2c_msg msg[] =3D {
> +					{
> +						.addr =3D client->addr,
> +						.len =3D sizeof(regaddr),
> +						.buf =3D regaddr
> +					},
> +					{
> +						.addr =3D client->addr,
> +						.flags =3D I2C_M_RD,
> +						.len =3D sizeof(buf),
> +						.buf =3D buf
> +					}
> +				};
> =20
>  	err =3D saa7706h_i2c_transfer(client, msg, ARRAY_SIZE(msg));
>  	if (err)
> --=20
> 1.7.5.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--nOM8ykUjac0mNN89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWF4gAAoJEIaOsuA1yqREOwsP/0VNvKgy/2AJeoCEkQY/Qcwz
RaU3OlWPCtFy8SJpwn1cxWW49sftySXUzSM+ndZOoKJfwh1ccEgEqyjH9l+Pbm54
FYku1m5B3j6LJhKN2Yv0uLSyoaJJavXaXtqc66PrCRdpWC+KGOAT4rM4NAclMvh5
Omw1nV9SE8CvoXzJro3wGKcKrbiDzlt/g1uqNwQ8Hnj1LL3cBjkF5tlDKFzdUnPW
eI2PILqzGxcV5EwUP/ykPJdk6F/7OIYJkVNhaUocZYQJAppw6RUYg9D8GSG2aVPn
A6Y/oyJhdlKdS59WgAmIgU17R0MApUNZaxDCBf4u42HL4Yz3SZ9Ppw36qWEK14OA
LwZEuCJVOYleY1lqolyanDkDlLLPNknSAtXJj4zlhuwrfq9IEc2qa4EiQAvYaSJR
U7colorvQ5eclV0DNDTE+5F5Dh862YAWX+kCj2SI3g7U5lQCQMxwCyEtA67THjhg
UeNxzS7qZdibBoe9BjCKspeajBsegraQTMwnFhqi8mC7TRxRtiyAk4LY41YWh9zX
ChNngy3MgnteHmJbTEV1fki9DyLn4+bbQrQYr9ZPceF0CxVl0mtdRjulw/vcLsFR
30yP+Z4OJ3C1c2ZVCSPjgaF1lDDW0W++7i+FD4PYA5QfQ4X2NsPaNgSUBGSux4cf
GlkIMATagO2wttq/vb4E
=etEM
-----END PGP SIGNATURE-----

--nOM8ykUjac0mNN89--
