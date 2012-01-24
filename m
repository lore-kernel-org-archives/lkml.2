Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2AXTrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:47:12 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55316 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2AXTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:47:11 -0500
Date: Tue, 24 Jan 2012 20:47:03 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Lars-Peter Clausen <lars@metafoo.de>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: Convert jz4740_wdt driver to watchdog core
Message-ID: <20120124194703.GC8502@pengutronix.de>
References: <1327371705.11828.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <1327371705.11828.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Tue, Jan 24, 2012 at 10:21:45AM +0800, Axel Lin wrote:
> This patch converts jz4740_wdt driver to use watchdog core APIs.
> Also use devm_* APIs to save a few error handling code.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Paul Cercueil <paul@crapouillou.net>
> ---
> v2: Address all the comments by Wolfram.
>     - Remove unneeded header file inclusion
>     - Drop 'heartbeat' usage in jz4740_wdt_set_heartbeat and jz4740_wdt_s=
tart
>     - Init wdt_dev->timeout in probe using the global 'heartbeat'
>     - Remove unneeded pointer check for drvdata->mem

The code still has those:

 41 #define WDT_IN_USE        0
 42 #define WDT_OK_TO_CLOSE   1

> +struct jz4740_wdt_drvdata {
> +	struct watchdog_device wdt;
> +	void __iomem *base;
> +	struct resource	*mem;

mem can go, too.

> +	struct clk *rtc_clk;
> +};

Rest looks fine.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8fCrcACgkQD27XaX1/VRvYGACgij32UDkM+OW5tf+sPhESpP9D
VZoAn3iIarvnoijnk/qORrzm9O2aIRbc
=Tibm
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
