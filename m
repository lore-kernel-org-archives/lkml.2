Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2DTMKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:10:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46187 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab2DTMKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 08:10:11 -0400
Date: Fri, 20 Apr 2012 14:09:50 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, robherring2@gmail.com, vitalywool@gmail.com,
        khali@linux-fr.org, ben-linux@fluff.org, rob.herring@calxeda.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v5] i2c: Add device tree support to i2c-pnx.c
Message-ID: <20120420120950.GA15613@pengutronix.de>
References: <1334913755-10466-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1334913755-10466-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2012 at 11:22:35AM +0200, Roland Stigge wrote:
> This patch adds device tree support to the pnx-i2c driver by using platfo=
rm
> resources for memory region and irq and removing dependency on mach inclu=
des.
>=20
> The following platforms are affected:
>=20
> * PNX
> * LPC31xx (WIP)
> * LPC32xx
>=20
> The patch is based on a patch by Jon Smirl, working on lpc31xx integration
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>

NACK! I said the approach of dropping "timeout" is OK, but unless I say
"you may add my ack after changing this and that", please do not
automatically add my ack. Doesn't hurt here, since I have to pick it up
anyway.

> Changes since v4:
> * Removed OF timeout property (to be added later when there is consensus =
about
>   how to call and handle it)
> * Changed clock-frequency example to decimal

Thanks, I just noticed. Please drop (more precise: remove) the
"slave-addr" for the same reasons as "timeout". Doesn't make much sense
anyhow, pnx doesn't have any slave support.

>  	ret =3D request_irq(alg_data->irq, i2c_pnx_interrupt,
> -			0, pdev->name, alg_data);
> +			  0, pdev->name, alg_data);

I know that checkpatch complains about this, but I'd prefer to avoid
such changes unless the code before was really unreadable.

Regards,

    Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+RUg4ACgkQD27XaX1/VRszjQCfZ3I5d72a7N3aTncbjFrZyxtz
8CYAoJW01IRAID0JFnc9fZuRqKqpFzKQ
=qWMv
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
