Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1EWIX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:23:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36376 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1EWIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:23:25 -0400
Message-ID: <4DDA1973.4090309@pengutronix.de>
Date: Mon, 23 May 2011 10:23:15 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oliver Hartkopp <socketcan@hartkopp.net>
CC: Arnd Bergmann <arnd@arndb.de>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Wolfgang Grandegger <wg@grandegger.com>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        linux-arm-kernel@lists.infradead.org, Netdev@vger.kernel.org,
        m-watkins@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <4DCB88A4.2010901@grandegger.com> <4DCBF1B6.6000104@hartkopp.net> <201105221230.56243.arnd@arndb.de> <4DD9FCFC.10803@hartkopp.net>
In-Reply-To: <4DD9FCFC.10803@hartkopp.net>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC295372533A9F99782DE402D"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC295372533A9F99782DE402D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/23/2011 08:21 AM, Oliver Hartkopp wrote:

[...]

> In 'real world' CAN setups you'll never see 21.000 CAN frames per secon=
d (and
> therefore 21.000 irqs/s) - you are usually designing CAN network traffi=
c with
> less than 60% busload. So interrupt rates somewhere below 1000 irqs/s c=
an be
> assumed.
>=20
> From what i've seen so far a 3-4 messages rx FIFO and NAPI support just=
 make it.
>=20
> @Marc/Wolfgang: Would this be also your recommendation for a CAN contro=
ller
> design that supports SocketCAN in the best way?

If you have a rx FIFO NAPI is the way to go. For a single mailbox it
adds overhead, if you can read the CAN frame in the interrupt handler.
The error messages should probably generated from NAPI, too. Especially
the I'm-the-only-CAN-node-on-the-net-and-get-no-ACK error message.

However IIRC David said that every new driver should implement NAPI.

> As the Linux network stack supports hardware timestamps too, this could=
 be an
> additional (optional!) feature.

regards, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC295372533A9F99782DE402D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3aGXYACgkQjTAFq1RaXHOi6ACfQ4kY0ukWKfqwYANq0x5mV3gD
lt8AoJjkRhJ0UWdPQ/dpzOA6WC4zJk6w
=v0Gq
-----END PGP SIGNATURE-----

--------------enigC295372533A9F99782DE402D--
