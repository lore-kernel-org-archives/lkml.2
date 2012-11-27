Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2K0PAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:00:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43354 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab2K0PAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:00:23 -0500
Message-ID: <1354028413.4266.53.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 053/270] mmc: sdhci-s3c: fix the wrong number of max bus
 clocks
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Chris Ball <cjb@laptop.org>
Date: Tue, 27 Nov 2012 15:00:13 +0000
In-Reply-To: <1353949160-26803-54-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-54-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TNMabX/afI0DBmyz17Er"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TNMabX/afI0DBmyz17Er
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Jaehoon Chung <jh80.chung@samsung.com>
>=20
> commit 5feb54a1ab91a237e247c013b8c4fb100ea347b1 upstream.
>=20
> We can use up to four bus-clocks; but on module remove, we didn't
> disable the fourth bus clock.
>=20
> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chris Ball <cjb@laptop.org>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

This is missing from 3.4 and 3.6 (but not 3.2); it apparently needed its
context adjusted.

Ben.

> ---
>  drivers/mmc/host/sdhci-s3c.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
> index a50c205..02b7a4a 100644
> --- a/drivers/mmc/host/sdhci-s3c.c
> +++ b/drivers/mmc/host/sdhci-s3c.c
> @@ -656,7 +656,7 @@ static int __devexit sdhci_s3c_remove(struct platform=
_device *pdev)
> =20
>  	pm_runtime_disable(&pdev->dev);
> =20
> -	for (ptr =3D 0; ptr < 3; ptr++) {
> +	for (ptr =3D 0; ptr < MAX_BUS_CLK; ptr++) {
>  		if (sc->clk_bus[ptr]) {
>  			clk_disable(sc->clk_bus[ptr]);
>  			clk_put(sc->clk_bus[ptr]);

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-TNMabX/afI0DBmyz17Er
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULTVfee/yOyVhhEJAQqKFw/7B+NTLRnugSBk7APQ6Srpso9M4nJ8GQuY
pQm6SMfzbdWoXEwXTjTf96/DV49ShGLUm4ZYAA3MzYTbm7gUP9t8mBV428IE/B0C
l2DxM7R1d1j/ELaFLx8wmxv+6wIQiUeS+YvChZztEJxnqpen/h4uskD8BUK4CSTU
+eMVyucMKVQn7D2mPyrvlwlM0gG/dSAkkLLdPr060ePSUoI0Fd0uKee1e4+kLn6s
Qew/NrtV9Myf/UNN2SnuykXcMYOftr5dQ8AzXLfKcBIgwOjVZTdeApLkWFACpLO2
3sSGVnGsDn83p1FuXPpAVk1IV5u2X2goM4CvvUwIL7fXUNgnyJm4acP0n5qTYrlY
3bwDnB6l9sfZ2OSBnniWF5WLHpuX9/Jvn7BrRUFs/1ni4ICQxc/VILpf7o0ab+Kd
cn0jwJITuWwC8CCbok61Jh2/raT4SpxI6e3S6W/TIPcsB91KLiotjajd1zkHsdvB
lP+8UZPaimYSev/v76iGbupVijgIo0vap2oMsBssYiFmX8Y/RKgkF3SGc5wOJXVK
YU/4jSnLXdaJGG+rUbaBcO6f2ccsxJ1YEH4KBgQXOKXT9rvm7leaK70ZKzhYPb3q
bhMDUAE2vFfVPDPDimOwGKboAxuXQebQbTu5OwlOOEaIgkk6dt4HenS2Un/8xodo
m2KSGM0vQ/s=
=6W1l
-----END PGP SIGNATURE-----

--=-TNMabX/afI0DBmyz17Er--
