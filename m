Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1CRLtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:49:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48871 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1CRLtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:49:36 -0400
Date: Fri, 18 Mar 2011 12:49:32 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Cc: linux-i2c@vger.kernel.org, arnd@arndb.de, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110318114931.GA2155@pengutronix.de>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Waldemar,

On Fri, Mar 18, 2011 at 11:40:24AM +0100, Waldemar Rymarkiewicz wrote:
> Add new driver for MicroRead NFC chip connected to i2c bus.
>=20
> See Documentation/nfc/nfc-microread.txt.
>=20
> Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>

Besides the stuff Alan mentioned...

> +struct microread_nfc_platform_data {
> +	unsigned int rst_gpio;
> +	unsigned int irq_gpio;
> +	unsigned int ioh_gpio;

=2E.. you should request and setup the GPIOs before using them.


> +free_irq:
> +	free_irq(client->irq, info);
> +free_buf:
> +	kfree(info->buf);
> +free_info:
> +	kfree(info);
> +
> +	dev_info(&client->dev, "Not probed.");
> +	return ret;
> +}

When respinning, you could consider using managed devices (devm_*);
this error path could completely go then.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2DRssACgkQD27XaX1/VRuPcgCgsux9JZGU4YdKQxrO5VrQCCS5
v3gAoJiibsZy+ufsGGKqIrVmeU6TJTTt
=M1jq
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
