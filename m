Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1GDMxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 08:53:42 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:53124 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459Ab1GDMxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 08:53:40 -0400
Date: Mon, 4 Jul 2011 15:53:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Message-ID: <20110704125330.GI2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mFHiwr52TKrxpkjc"
Content-Disposition: inline
In-Reply-To: <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mFHiwr52TKrxpkjc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Tue, Jun 21, 2011 at 04:39:06PM +0300, Peter Ujfalusi wrote:
> +static int __devinit twl6040_probe(struct platform_device *pdev)
> +{
> +	struct twl4030_audio_data *pdata =3D pdev->dev.platform_data;
> +	struct twl6040 *twl6040;
> +	struct mfd_cell *cell =3D NULL;
> +	int ret, children =3D 0;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "Platform data is missing\n");
> +		return -EINVAL;
> +	}
> +
> +	twl6040 =3D kzalloc(sizeof(struct twl6040), GFP_KERNEL);
> +	if (!twl6040)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, twl6040);
> +
> +	twl6040_dev =3D pdev;
> +	twl6040->dev =3D &pdev->dev;
> +	twl6040->audpwron =3D pdata->audpwron_gpio;
> +	twl6040->irq =3D pdata->naudint_irq;
> +	twl6040->irq_base =3D pdata->irq_base;
> +
> +	mutex_init(&twl6040->mutex);
> +	mutex_init(&twl6040->io_mutex);
> +	init_completion(&twl6040->ready);
> +
> +	twl6040->rev =3D twl6040_reg_read(twl6040, TWL6040_REG_ASICREV);
> +
> +	if (gpio_is_valid(twl6040->audpwron)) {
> +		ret =3D gpio_request(twl6040->audpwron, "audpwron");
> +		if (ret)
> +			goto gpio1_err;
> +
> +		ret =3D gpio_direction_output(twl6040->audpwron, 0);
> +		if (ret)
> +			goto gpio2_err;
> +	}
> +
> +	/* ERRATA: Automatic power-up is not possible in ES1.0 */
> +	if (twl6040_get_rev(twl6040) =3D=3D TWL6040_REV_ES1_0)
> +		twl6040->audpwron =3D -EINVAL;
> +
> +	if (twl6040->irq) {
> +		/* codec interrupt */
> +		ret =3D twl6040_irq_init(twl6040);
> +		if (ret)
> +			goto gpio2_err;
> +
> +		ret =3D twl6040_request_irq(twl6040, TWL6040_IRQ_READY,
> +					  twl6040_naudint_handler, 0,
> +					  "twl6040_irq_ready", twl6040);

why don't you use the normal request_threaded_irq() ?? This is a bit of
obfuscation IMO.

--=20
balbi

--mFHiwr52TKrxpkjc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEbfKAAoJEAv8Txj19kN1tKwH/1hm5004W22i0x9tu4URmbI0
oYSfNTUPnJVT0JH+FomxuB6gD15G+Ve115x7yAy2lZIah3nX02jmiIzryou698p5
4HkKbcypkmOr82QIdwB0wteOAG+Gtzq5ixfC426g5Mz93mnr/hnyfOd/wRDby0ZJ
tNzjZWzk/LaxfDjtKHYxBkUvTJU4y880kqtS99DVzpJmBaLmQytPYhRsuMxqtVIE
sSdKZNFXtgzrVqeIHvWrri0LJ3CUmtKYMMXJzUomp8YRDTVuJEaGlenbr0svbpQS
x1refWkBPV2Xm0/61wNjxXm3glaT68PB+weEx6rLrnPuB/XQsasWbVCv9D9oww0=
=K/PW
-----END PGP SIGNATURE-----

--mFHiwr52TKrxpkjc--
