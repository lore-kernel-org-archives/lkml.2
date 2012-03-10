Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2CJUuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 15:50:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44671 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2CJUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 15:50:04 -0500
Date: Sat, 10 Mar 2012 21:49:55 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v5 3/3] USB: ohci-nxp: Support for LPC32xx
Message-ID: <20120310204955.GA14564@pengutronix.de>
References: <1331408166-11607-1-git-send-email-stigge@antcom.de>
 <1331408166-11607-4-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1331408166-11607-4-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> -static void isp1301_configure(void)
> +static u16 i2c_read16(u8 subaddr)
> +{
> +	u16 data;
> +
> +	i2c_master_send(isp1301_i2c_client, &subaddr, 1);
> +	i2c_master_recv(isp1301_i2c_client, (u8 *) &data, 2);
> +
> +	return data;
> +}

Won't i2c_smbus_read_word_data(isp1301_i2c_client, reg) do?

And while we are at it: Could you also try replacing i2c_write() with
i2c_smbus_write_byte_data(isp1301_i2c_client, reg, val)?

No need to recode it (and in general, those solutions will also work with S=
MBus
for free)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9bvnMACgkQD27XaX1/VRuwwACgi6YhDbPMPOJM1VEW/HDQqDS8
slAAoMA61/vwqL+EtgOo/H61fVaA0b03
=rN2h
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
