Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391Ab2DMJaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:30:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51987 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932720Ab2DMJaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:30:16 -0400
Date: Fri, 13 Apr 2012 10:30:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120413093012.GK3168@opensource.wolfsonmicro.com>
References: <1334122120.3991.13.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQ77YLfPrO/qF/pM"
Content-Disposition: inline
In-Reply-To: <1334122120.3991.13.camel@matrix>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQ77YLfPrO/qF/pM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 10:58:40AM +0530, Ashish Chavan wrote:

> +/* PLL dividers table */
> +static const struct pll_div da7210_pll_div[] = {
> +	/* for MASTER mode, fs = 44.1Khz */
> +	{ 12000000, 0xE8, 0x6C, 0x2, },		/* MCLK=12Mhz */
> +	{ 13000000, 0xDF, 0x28, 0xC, },		/* MCLK=13Mhz */
> +	{ 13500000, 0xDB, 0x0A, 0xD, },		/* MCLK=13.5Mhz */
> +	{ 14400000, 0xD4, 0x5A, 0x2, },		/* MCLK=14.4Mhz */
> +	{ 19200000, 0xBB, 0x43, 0x9, },		/* MCLK=19.2Mhz */
> +	{ 19680000, 0xB9, 0x6D, 0xA, },		/* MCLK=19.68Mhz */
> +	{ 19800000, 0xB8, 0xFB, 0xB, },		/* MCLK=19.8Mhz */
> +	/* for MASTER mode, fs = 48Khz */
> +	{ 12000000, 0xF3, 0x12, 0x7, },		/* MCLK=12Mhz */

This *still* has magic number problems.

> +	if (da7210->master) {
> +		/* In PLL master mode, use master mode PLL dividers */
> +		switch (fout) {
> +		case 2822400:
> +			row_idx = MASTER_2822400_DIV_OFFSET;
> +			break;
> +		case 3072000:
> +			row_idx = MASTER_3072000_DIV_OFFSET;
> +			break;

These defines now need to be kept in sync with the table and are going
to be *very* painful to review.

--LQ77YLfPrO/qF/pM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPh/IdAAoJEBus8iNuMP3dvlAP/RKBeQUgUQ8tKXI6tTrVvbMN
WuyH4ow1dykipoTKll+KJENFv7RroqaJGYfcbq4ExPOdk8+Zy12AbGUILVsBV+yt
uQR/Iixet1wjWXWYseinl61wQh0iYppVHOZVnJUZnaHt+c9bILbmmT5h37EvBchI
ai6MI4QrX42cWp2OFjglagkEdLquDICqrhykY+Nh0eD6RwdoPpyaLVhzE2J+oUFJ
iswQEO8LNf/bzdMimCEw4Jvwv0X1feyWIrdBFYqrZUMlwGpJZN4PdbfOvvULHrkh
sKG0aZRGspj/Xm0BbIqYVnylAH7l5Hn5D0VEH9nxjFv9KUacuOkoAcWzj3kmBdNJ
KqBa2REBiT8e0h7JnWXfeKtQZvVobiWNHbV6fB3ROKN8ToAZGV4lngaBC5VIloTF
Uo3Y7Whs53gyBWKGEt8ICBoEaG7GlESUi7LTg2cGeFEtUuQvEUSRSNTTIaqJX3qQ
7aqRnMY/9OS/0c3NRnj0V/uUH3k/RlVyjxwirbf0CP3Iu6ezN4Hbx2OLzAEwp9jB
XGMKhFfeURmWvGgNXPdD9+1SnG+Embe/iIJE7NJuIWIBp60ocunOB8cxREmX/laO
439H9c8n7cbd9iWL1T9vL7EiYiHQNmZ/AVkmFCtedv9ufgB/7CNVgIdDbuUU6Hv+
RKxQPZKqwRr/uR5oCdUi
=EIze
-----END PGP SIGNATURE-----

--LQ77YLfPrO/qF/pM--
