Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2FFNe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:34:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:4489 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab2FFNe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:34:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="175492019"
Message-ID: <1338989921.6875.50.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v6] MTD: LPC32xx SLC NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roland Stigge <stigge@antcom.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Date: Wed, 06 Jun 2012 16:38:41 +0300
In-Reply-To: <1338974414-5308-1-git-send-email-stigge@antcom.de>
References: <1338974414-5308-1-git-send-email-stigge@antcom.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BV9XYac1pt6IiyWn8trZ"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BV9XYac1pt6IiyWn8trZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-06 at 11:20 +0200, Roland Stigge wrote:
> +#ifdef CONFIG_PM
> +static int lpc32xx_nand_resume(struct platform_device *pdev)
> +{
> +	struct lpc32xx_nand_host *host =3D platform_get_drvdata(pdev);
> +
> +	/* Re-enable NAND clock */
> +	clk_enable(host->clk);
> +
> +	/* Fresh init of NAND controller */
> +	lpc32xx_nand_setup(host);
> +
> +	/* Disable write protect */
> +	lpc32xx_wp_disable(host);
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_nand_suspend(struct platform_device *pdev, pm_message=
_t pm)
> +{
> +	u32 tmp;
> +	struct lpc32xx_nand_host *host =3D platform_get_drvdata(pdev);
> +
> +	/* Force CE high */
> +	tmp =3D readl(SLC_CTRL(host->io_base));
> +	tmp &=3D ~SLCCFG_CE_LOW;
> +	writel(tmp, SLC_CTRL(host->io_base));
> +
> +	/* Enable write protect for safety */
> +	lpc32xx_wp_enable(host);
> +
> +	/* Disable clock */
> +	clk_disable(host->clk);
> +
> +	return 0;
> +}
> +
> +#else
> +#define lpc32xx_nand_resume NULL
> +#define lpc32xx_nand_suspend NULL
> +#endif

0, not NULL.

--=20
Best Regards,
Artem Bityutskiy

--=-BV9XYac1pt6IiyWn8trZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPz11hAAoJECmIfjd9wqK0zXYP/0XeKxiYFsgdBuLZs9y8rmLD
LvIIjTjmN4cQC8OmTwX57RHVxxCPc3ZmOxNc0mzxMrsbArpONPOX66M2cmM23OS/
tjh2pup1kRzZCEqDIOIv6cnCo+VpTrGW0dopmLMjkUGNCFzcvk59evkJIadbZQCy
uYcmzl13B7hrcHLL0s5gDOVIkDuFpCTbYl382+5JO9Xgc1UZCfgcatfEAyvzBTvA
Qpgk9flf6hYYJAy0wrckPl/hTXT8doeZSBT21cyL3AbKn+H1gqMcc/yzYRw5qcBD
5BpqBIsMY3aQvcEW9gJcUpR5xCuh6dCLDfGdux68G7GhSOgpiFE5pI/gT3wZQrOh
kqb91Mss3jUK//w9VjvOeAaRXWdCMZYpuSCpeu/dgNEJLDtD0ol+47DyC7WTqG3H
6bddJok3Fz72WulaLfcbfExF4TxwisyKSkPtuhE6qIWyByBg0Gd8L7TZqqjwRSfN
S6FDCgyWYjxty+7wSWbYN2Y1QsX40sTEbzb9dGr0ufagwDoagrcquq3wqkklaBUS
g75mcbcWgwRl2YueT88ZQbaWRJtBHsx6mmXMYGA2n+jYxvn1ypes5L6Rfdldd1pA
KxQ5KwD3oI+QCuprCQ3IAsM+kS0WLbOExD+sX28mnqbU6p9FkkJuTpI4D1yfMV3m
rADYN3Sx+yXk9rhzunPn
=y6sL
-----END PGP SIGNATURE-----

--=-BV9XYac1pt6IiyWn8trZ--

