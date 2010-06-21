Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0FUHH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:07:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59905 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0FUHHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:07:54 -0400
Message-ID: <4C1F0FC7.60605@pengutronix.de>
Date: Mon, 21 Jun 2010 09:07:51 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Sascha Hauer <sha@pengutronix.de>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c-imx: do not allow interruptions when waiting for
 I2C to complete (resend)
References: <4C1753F6.3080106@pengutronix.de> <20100620223321.GA12387@fluff.org.uk>
In-Reply-To: <20100620223321.GA12387@fluff.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7072FBC9D1E67B198A894472"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7072FBC9D1E67B198A894472
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ben Dooks wrote:
> On Tue, Jun 15, 2010 at 12:20:38PM +0200, Marc Kleine-Budde wrote:
>> The i2c_imx_trx_complete() function is using
>> wait_event_interruptible_timeout() to wait for the I2C controller to
>> signal that it has completed an I2C bus operation. If the process that=

>> causes the I2C operation receives a signal, the wait will be
>> interrupted, returning an error. It is better to let the I2C operation=

>> finished before handling the signal (i.e. returning into userspace).
>>
>> It is safe to use wait_event_timeout() instead, because the timeout
>> will allow the process to exit if the I2C bus hangs. It's also better
>> to allow the I2C operation to finish, because unacknowledged I2C
>> operations can cause the I2C bus to hang.
>=20
> Hmm, if it times out, do you need to at-least try sending a stop
> on the bus? or does the caller do that for you?

The caller of the caller does this. "i2c_imx_xfer" will call
"i2c_imx_stop", and this function will generate the stop condition if
not already done so.

I'm sending a V3 version of the patch, which removes the only written to
variable "result".

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig7072FBC9D1E67B198A894472
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkwfD8cACgkQjTAFq1RaXHM3YwCeNOvOp//8wiMzVn/PjyKYUyuD
bVkAni/gy3Af53vPYBxtglikMy0mX7RY
=5+S7
-----END PGP SIGNATURE-----

--------------enig7072FBC9D1E67B198A894472--
