Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2IYLAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:00:03 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:49131 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503Ab2IYLAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:00:01 -0400
Date: Tue, 25 Sep 2012 13:55:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.zummo@towertech.it
Subject: Re: [PATCHv2 1/7] rtc: Convert struct i2c_msg initialization to C99
 format
Message-ID: <20120925105504.GQ9137@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348569224-4096-1-git-send-email-shubhrajyoti@ti.com>
 <1348569224-4096-2-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hnpg0BSo5EvPlUVi"
Content-Disposition: inline
In-Reply-To: <1348569224-4096-2-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hnpg0BSo5EvPlUVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 25, 2012 at 04:03:38PM +0530, Shubhrajyoti D wrote:
> Convert the struct i2c_msg initialization to C99 format. This makes
> maintaining and editing the code simpler. Also helps once other fields
> like transferred are added in future.
>=20
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
>  drivers/rtc/rtc-ds1672.c |   26 ++++++++++++++++++++++----
>  1 files changed, 22 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
> index 7fa67d0..577dbae 100644
> --- a/drivers/rtc/rtc-ds1672.c
> +++ b/drivers/rtc/rtc-ds1672.c
> @@ -37,8 +37,17 @@ static int ds1672_get_datetime(struct i2c_client *clie=
nt, struct rtc_time *tm)
>  	unsigned char buf[4];
> =20
>  	struct i2c_msg msgs[] =3D {
> -		{client->addr, 0, 1, &addr},	/* setup read ptr */
> -		{client->addr, I2C_M_RD, 4, buf},	/* read date */
> +		{/* setup read ptr */
> +			.addr =3D client->addr,
> +			.len =3D 1,
> +			.buf =3D &addr
> +		},
> +		{/* setup read ptr */

should this comment be /* read date */ ??

--=20
balbi

--Hnpg0BSo5EvPlUVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQYY2IAAoJEIaOsuA1yqRE67YP/0UkM6jHaUC7dL1VNlRJ2wVG
8SMro1xGPPyBsVyNPcvi0AU+KyZsQ0h7tGxnKtuklalANjixklNs/tBc4w4Eoyu+
FX2552GYLUNHL+rNNABVyZ/FLVccK3T90OSBzjuuuDwmSwdezk0ogN//6YLBF/Va
fbfT21JA0izNoS2TnjPp8LfIs+MXeHhnp9fgfUxeT0BwBFRO6YraJlKxMEranS7l
J3AqC19Q5LZXvUdjuzYezjylYEyqpBsoYGpOQKQ09INfFntyCqwRWQ/0k9A/Conv
FwW/a37YcuWnwJ0+LJ5gsRnIcgRbqMPu25L7y2a35So2RX51/d9uzQWlqffwoZ+u
Y4Z3TMEh0gzzGI612WbODdwgP0oDs0BDzSy+nHnxZHgZjBzs8U90KHzpTSwn7iiY
r3iji2+94CQOjU6lzXpQGzWcD3mlf9rRTcxEEJOeJJDkLC/sXSHiMoo0xo8751WU
qCbS4jY9ufqUw1mQBezzjCEpysZBeT1fhRFPBBa4y+NKNkhDWj+PrlYMW63D8b7i
WezZZtdl51ycYnb+lWAlZGUl+N8fNVRUIe+kEpa8reiZj8j/zdJPMNOtgHGs/epc
ns5V4UNYEUbHLsOZCm+giVuxsNxH22QvpuR7rzYo6gD1yh/NJPSH7/8/JKmhDENJ
E3NysZDih7xSSkdPWvWP
=E52J
-----END PGP SIGNATURE-----

--Hnpg0BSo5EvPlUVi--
