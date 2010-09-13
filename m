Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0IMTiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:38:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53959 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0IMTiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:38:05 -0400
Date: Mon, 13 Sep 2010 21:37:28 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Luotao Fu <l.fu@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: stmpe: fix error path
Message-ID: <20100913193728.GA14993@pengutronix.de>
References: <1284317840-5131-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1284317840-5131-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 12, 2010 at 10:57:19PM +0400, Vasiliy Kulikov wrote:
> Free allocated memory.  Call stmpe_disable() if it was enabled.
>=20
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
>  Maybe It needs better error path.

What do you mean here? Looks good to me so far.

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

>=20
>  drivers/gpio/stmpe-gpio.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
> index 65b9960..6e28afa 100644
> --- a/drivers/gpio/stmpe-gpio.c
> +++ b/drivers/gpio/stmpe-gpio.c
> @@ -317,11 +317,11 @@ static int __devinit stmpe_gpio_probe(struct platfo=
rm_device *pdev)
> =20
>  	ret =3D stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
>  	if (ret)
> -		return ret;
> +		goto out_free;
> =20
>  	ret =3D stmpe_gpio_irq_init(stmpe_gpio);
>  	if (ret)
> -		goto out_free;
> +		goto out_disable;
> =20
>  	ret =3D request_threaded_irq(irq, NULL, stmpe_gpio_irq, IRQF_ONESHOT,
>  				   "stmpe-gpio", stmpe_gpio);
> @@ -347,6 +347,8 @@ out_freeirq:
>  	free_irq(irq, stmpe_gpio);
>  out_removeirq:
>  	stmpe_gpio_irq_remove(stmpe_gpio);
> +out_disable:
> +	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
>  out_free:
>  	kfree(stmpe_gpio);
>  	return ret;
> --=20
> 1.7.0.4
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkyOfXgACgkQD27XaX1/VRv0YQCgsVJLZtkMr4t4BwK3kMvRLkAg
oekAn2Ol9HckKn9Uh3u/Aw+eAuV/6zKS
=3h0p
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
