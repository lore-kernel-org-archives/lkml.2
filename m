Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2FKQY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:24:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47531 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2FKQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:24:54 -0400
Date: Mon, 11 Jun 2012 18:24:47 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/8] i2c: i2c-bfin-twi: Illegal i2c bus lock upon certain
 transfer scenarios.
Message-ID: <20120611162447.GB3887@pengutronix.de>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 16, 2012 at 03:20:19PM +0800, sonic.zhang@analog.com wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>=20
> For transfer counts > 255 bytes i2c-bfin-twi sets the data
> transfer counter DCNT to 0xFF indicating unlimited transfers.
> It then uses a flag iface->manual_stop to manually issue the STOP
> condition, once the required amount of bytes are received.
>=20
> We found that on I2C receive operation issuing the STOP condition
> together with a FULL RCV FIFO (2bytes) will cause SDA and SCL be
> constantly driven low.
>=20
> Temporary workaround until further investigation:
> Discard the RCV FIFO before issuing the STOP condition.
>=20
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>=20
> git-svn-id: svn://localhost/svn/linux-kernel/trunk@9011 526b6c2d-f592-453=
2-a319-5dd88ccb003d

Please remove this line.

> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-b=
fin-twi.c
> index cdb59e5..e6dd3c9 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -131,6 +131,10 @@ static void bfin_twi_handle_interrupt(struct bfin_tw=
i_iface *iface,
>  			iface->transPtr++;
>  			iface->readNum--;
>  		} else if (iface->manual_stop) {
> +			/* Avoid possible bus stall -
> +			 * Flush FIFO before issuing the STOP condition
> +			 */
> +			read_RCV_DATA16(iface);

Please mention that this is currently only a workaround, so people know
there could be still a proper solution.

>  			write_MASTER_CTL(iface,
>  				read_MASTER_CTL(iface) | STOP);
>  		} else if (iface->cur_mode =3D=3D TWI_I2C_MODE_REPEAT &&
> --=20
> 1.7.0.4
>=20
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WG88ACgkQD27XaX1/VRtUggCfTdPcT9NNQkneRXNLMJU5rYef
LsUAoKO+c1Cjm26cxgQhoYrheYA0xvIh
=Q/8S
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
