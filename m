Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2K0PIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:08:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296Ab2K0PIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:08:30 -0500
Message-ID: <1354028907.4266.56.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 061/270] timekeeping: Cast raw_interval to u64 to avoid
 shift overflow
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 15:08:27 +0000
In-Reply-To: <1353949160-26803-62-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-62-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ynHKSbGTJyXvruWRNfIO"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ynHKSbGTJyXvruWRNfIO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> commit 5b3900cd409466c0070b234d941650685ad0c791 upstream.
>=20
> We fixed a bunch of integer overflows in timekeeping code during the 3.6
> cycle.  I did an audit based on that and found this potential overflow.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: John Stultz <johnstul@us.ibm.com>
> Link: http://lkml.kernel.org/r/20121009071823.GA19159@elgon.mountain
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [ herton: adapt for 3.5, timekeeper instead of tk pointer ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

This is also missing from 3.4; looks like Herton's version is
applicable.

Ben.

> ---
>  kernel/time/timekeeping.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 63c88c1..8954990 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1012,7 +1012,7 @@ static cycle_t logarithmic_accumulation(cycle_t off=
set, int shift)
>  	}
> =20
>  	/* Accumulate raw time */
> -	raw_nsecs =3D timekeeper.raw_interval << shift;
> +	raw_nsecs =3D (u64)timekeeper.raw_interval << shift;
>  	raw_nsecs +=3D timekeeper.raw_time.tv_nsec;
>  	if (raw_nsecs >=3D NSEC_PER_SEC) {
>  		u64 raw_secs =3D raw_nsecs;

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-ynHKSbGTJyXvruWRNfIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULTXa+e/yOyVhhEJAQrJlw/9Evw6BTXwhGZ4vUomFfXwUU6Bz6tMDLTx
L1CcaPsdWA4RZDSN71Mj8AtWwH1DRwXpQ985G+OPyWUk2NDcAPBXOIDKp3yz3xpy
M/cZJKgI9ur6SIqvJdgVWo8Xc+EYzAzupcERvbgcSDhwASsqV0itXTdFc4L/z0Pu
u77eHs1ev6EaAKEISsvOw1Bq0kU6Cj3nUgdM7clNzzbR9VxVOzZRdSWR9txVKmEi
eQKX3daunx+E26QikUZsciHMN1M+Bgxnz0/JUml5k+NpiK+o+Jp1HlR3yPTaLY7Z
tfeiR9ik18nr9ieGY1x9vc8Dix7gN8G8CLlSR43llyqMIg/H2xFCIYdDbamGZjdo
d5rkjuBpfhYiUL3jcnh2AoxyHoTxaXIWKxnSjBa7VDnKAL77W6HtC2Ee73at9Te/
Y9gpmyJmV7r/I+bVJXSvZrZ7/Nha5z1vmh68vZ3c7wg3QvUK+DlrlbRSppDOPjcC
2/D+rgy9xe3JQueP4VL9jWV3EyU8RpHKkZdQXSdSkn4UWTSV1MtWBKpm9677xP1J
AyVDuDOM6D4Nr5SrGz9zsi12Let+zrWYQz5OqtTlWM2KGJ6Ve7FgWsS8mIclRIFt
FLP+yfWLJCiGO6xwUzBYUF509FXUsT9Kv9fURQx1pkYSi0U8kvjOpF/YJy+A0RZf
dgFyPVby7mQ=
=QxNN
-----END PGP SIGNATURE-----

--=-ynHKSbGTJyXvruWRNfIO--
