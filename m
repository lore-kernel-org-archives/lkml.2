Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2BPNfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:35:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55392 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2BPNfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:35:14 -0500
Date: Thu, 16 Feb 2012 14:35:10 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Oskar Schirmer <oskar@scara.com>
Cc: wim@iguana.be, s.hauer@pengutronix.de, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: make imx2_wdt report boot status correctly
Message-ID: <20120216133510.GA2541@pengutronix.de>
References: <1329394665-7238-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1329394665-7238-1-git-send-email-oskar@scara.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oskar,

besides this minor thing (which may be just personal taste)...

> +	case WDIOC_GETBOOTSTATUS:
> +		val =3D __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
> +		new_value =3D 0;
> +		if (val & IMX2_WDT_WRSR_TOUT)
> +			new_value =3D WDIOF_CARDRESET;

I'd go for this to save some lines:
		new_value =3D val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;

But in general:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>


--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk89Bg4ACgkQD27XaX1/VRsM9gCdFfdADJ16jSw18O/vpHOEXvE+
y3EAn1ehBvEAIrkATsuOaevMQNQT61U7
=by6I
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
