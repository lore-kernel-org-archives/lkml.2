Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2DRSJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:09:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60213 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2DRSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:09:44 -0400
Date: Wed, 18 Apr 2012 20:09:17 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be, jonsmirl@gmail.com,
        devicetree-discuss@ozlabs.org
Subject: Re: [PATCH v3 8/8] i2c: Add device tree support to i2c-pnx.c
Message-ID: <20120418180917.GD2548@pengutronix.de>
References: <1333528480-17134-1-git-send-email-stigge@antcom.de>
 <1333528480-17134-9-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <1333528480-17134-9-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2012 at 10:34:40AM +0200, Roland Stigge wrote:
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

I added devicetree-discuss to the (quite long) CC list. I am not sure
about all of the bindings.

>=20
> ---
>=20
>  Applies to v3.4-rc1
>=20
>  Documentation/devicetree/bindings/i2c/pnx.txt |   40 ++++++++++++++++
>  drivers/i2c/busses/i2c-pnx.c                  |   65 +++++++++++++++++++=
-------
>  include/linux/i2c-pnx.h                       |    1=20
>  3 files changed, 89 insertions(+), 17 deletions(-)
>=20
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/i2c/pnx.txt
> @@ -0,0 +1,40 @@
> +* NXP PNX I2C Controller
> +
> +Required properties:
> +
> + - reg: Offset and length of the register set for the device
> + - compatible: should be "nxp,pnx-i2c"
> + - interrupts: configure one interrupt line
> + - #address-cells: always 1 (for i2c addresses)
> + - #size-cells: always 0
> +
> +Optional properties:
> +
> + - interrupt-parent: the phandle for the interrupt controller that
> +   services interrupts for this device.

That one is not optional, or? You always need it but in most cases it
gets inherited as I understand.

> + - clock-frequency: desired I2C bus clock frequency in Hz, Default: 1000=
00 Hz
> + - pnx,timeout: I2C bus timeout in milliseconds, Default: 10 ms

To devicetree-folks: Can we argue this is a hardware property of the
bus? Then we could introduce a generic "timeout" property? I see, there
is already "fsl,timeout", and it won't make sense to have that per
vendor?

> + - slave-addr: Address used by the controller, Hardware default: 110

I'd prefer the hex value here, I2C addresses are mostly specified in
hex.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+PA00ACgkQD27XaX1/VRt/8QCgjlrbuHKQdptRbdHsIJm58tb8
GwUAnjN9z15pvmRNOqQFiJh9BRuaGGCm
=CaWN
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--
