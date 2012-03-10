Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2CJUx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 15:53:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51763 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab2CJUxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 15:53:54 -0500
Date: Sat, 10 Mar 2012 21:53:51 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v5 3/3] USB: ohci-nxp: Support for LPC32xx
Message-ID: <20120310205351.GB14564@pengutronix.de>
References: <1331408166-11607-1-git-send-email-stigge@antcom.de>
 <1331408166-11607-4-git-send-email-stigge@antcom.de>
 <20120310204955.GA14564@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <20120310204955.GA14564@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 10, 2012 at 09:49:55PM +0100, Wolfram Sang wrote:
>=20
> > -static void isp1301_configure(void)
> > +static u16 i2c_read16(u8 subaddr)
> > +{
> > +	u16 data;
> > +
> > +	i2c_master_send(isp1301_i2c_client, &subaddr, 1);
> > +	i2c_master_recv(isp1301_i2c_client, (u8 *) &data, 2);
> > +
> > +	return data;
> > +}
>=20
> Won't i2c_smbus_read_word_data(isp1301_i2c_client, reg) do?
>=20
> And while we are at it: Could you also try replacing i2c_write() with
> i2c_smbus_write_byte_data(isp1301_i2c_client, reg, val)?
>=20
> No need to recode it (and in general, those solutions will also work with=
 SMBus
> for free)

"no need to recode it" means "no need to recode these already existing func=
tions"

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9bv18ACgkQD27XaX1/VRu83gCgpXYXarsKIanacmL4SWRwFLiH
E0IAnRaNXqi0f8eALkavuWC1/CF13Mo8
=p770
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
