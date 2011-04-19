Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1DSKUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:20:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51379 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1DSKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:20:48 -0400
Date: Tue, 19 Apr 2011 12:20:53 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/5] mmc: sdhci: eliminate sdhci_of_host and
 sdhci_of_data
Message-ID: <20110419102053.GC4164@pengutronix.de>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <1301042931-4869-3-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 25, 2011 at 04:48:48PM +0800, Shawn Guo wrote:
> The patch is to migrate the use of sdhci_of_host and sdhci_of_data
> to sdhci_pltfm_host and sdhci_pltfm_data, so that the former pair can
> be eliminated.
>=20
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---

[...]

> diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltf=
m.h
> index a3e4be0..12afe86 100644
> --- a/drivers/mmc/host/sdhci-pltfm.h
> +++ b/drivers/mmc/host/sdhci-pltfm.h
> @@ -19,6 +19,10 @@
>  struct sdhci_pltfm_host {
>  	struct clk *clk;
>  	u32 scratchpad; /* to handle quirks across io-accessor calls */
> +
> +	/* migrate from sdhci_of_host */
> +	unsigned int clock;
> +	u16 xfer_mode_shadow;

xfer_mode_shadow can be merged into scratchpad. They both fix the same
issue.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2tYgUACgkQD27XaX1/VRv17wCgxdmuW5VDkZKuUBVSpt6qOVzj
1bQAoKoUfi+HlAJW6nzdlRlHNYxEdvji
=Dc2i
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
