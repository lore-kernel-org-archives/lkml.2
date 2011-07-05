Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1GELZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:25:06 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43607 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932165Ab1GELZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:25:05 -0400
Date: Tue, 5 Jul 2011 14:24:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 2/5] input: twl6040-vibra: Do not use wrapper for irq
 request
Message-ID: <20110705112455.GB2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309857266-3663-1-git-send-email-peter.ujfalusi@ti.com>
 <1309857266-3663-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1C2QhcYtVTlNtC1j"
Content-Disposition: inline
In-Reply-To: <1309857266-3663-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1C2QhcYtVTlNtC1j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 12:14:23PM +0300, Peter Ujfalusi wrote:
> diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6=
040-vibra.c
> index dbf745d..1178c97 100644
> --- a/drivers/input/misc/twl6040-vibra.c
> +++ b/drivers/input/misc/twl6040-vibra.c
> @@ -47,6 +47,7 @@ struct vibra_info {
>  	struct workqueue_struct *workqueue;
>  	struct work_struct play_work;
>  	struct mutex mutex;
> +	int irq;
> =20
>  	bool enabled;
>  	int weak_speed;
> @@ -277,6 +278,13 @@ static int __devinit twl6040_vibra_probe(struct plat=
form_device *pdev)
>  		goto err_kzalloc;
>  	}
> =20
> +	info->irq =3D pdata->irq;
> +	if (!info->irq) {
> +		dev_err(info->dev, "invalid irq for vibra\n");
> +		ret =3D -EINVAL;
> +		goto err_kzalloc;
> +	}

ok, they are platform drivers, so you could be using:

	info->irq =3D platform_get_irq(pdev, 0);

	if (info->irq < 0) {
		dev_err();
		ret =3D info->irq;
		goto err_kzalloc;
	}

--=20
balbi

--1C2QhcYtVTlNtC1j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEvSHAAoJEAv8Txj19kN1B64H/2cbH80kQe3oM295jzIkT0jL
gYc/2CvUgyFFI3RctJwjkIvRecg0mEc7Qtc1sB0ElSWmfm2DRlAyJ2+XBa6MMcpW
icgCVeQkAOrrecPiiW7l9KR3Ej6I34hctm+nuU1vG5CqvxayizAl4hvR/zQullqR
O+3zXE3fvGyoQo80dnA2oO4/ptDXNToDpmJMZgXzMTtiVAqNUspHh2bBypdnmGxP
KIclaOvt7E9His2H+VNw7E+AFQzlne1G10KHtLAVwpawXSiODBtz23UmIQY6V365
lgbkDQKbiHUBtH2Es9SED8FwP0CHt8QYpihxYYIRiNrCkUwWTLTg6Prgh022aFc=
=AK3H
-----END PGP SIGNATURE-----

--1C2QhcYtVTlNtC1j--
