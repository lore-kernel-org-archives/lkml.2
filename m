Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab0E0LuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:50:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56347 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab0E0LuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:50:00 -0400
Date: Thu, 27 May 2010 13:49:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: sha@pengutronix.de, "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Richard Zhao <linuxzsc@gmail.com>,
       Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Arnaud Patard <apatard@mandriva.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-imx: do not allow interruptions when waiting for
	I2C to complete
Message-ID: <20100527114948.GC31253@pengutronix.de>
References: <1274960188-12601-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <1274960188-12601-1-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 27, 2010 at 01:36:27PM +0200, Marc Kleine-Budde wrote:
> The i2c_imx_trx_complete() function is using
> wait_event_interruptible_timeout() to wait for the I2C controller to
> signal that it has completed an I2C bus operation. If the process that
> causes the I2C operation receives a signal, the wait will be
> interrupted, returning an error. It is better to let the I2C operation
> finished before handling the signal (i.e. returning into userspace).
>=20
> It is safe to use wait_event_timeout() instead, because the timeout
> will allow the process to exit if the I2C bus hangs. It's also better
> to allow the I2C operation to finish, because unacknowledged I2C
> operations can cause the I2C bus to hang.
>=20
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/i2c/busses/i2c-imx.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index d1ff940..d7051fe 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -161,7 +161,7 @@ static int i2c_imx_trx_complete(struct imx_i2c_struct=
 *i2c_imx)
>  {
>  	int result;
> =20
> -	result =3D wait_event_interruptible_timeout(i2c_imx->queue,
> +	result =3D wait_event_timeout(i2c_imx->queue,
>  		i2c_imx->i2csr & I2SR_IIF, HZ / 10);
> =20
>  	if (unlikely(result < 0)) {

That 'if' can go, too. wait_event_timeout does not return neg values.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv+XFwACgkQD27XaX1/VRtH9ACgxswVYA+J2tkR62LsKz74f5tK
7loAn32AwnhlDwuNbu9wHOkZEXwTsRGC
=XmUv
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
