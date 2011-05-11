Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab1EKWkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:40:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44667 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab1EKWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:40:18 -0400
Message-ID: <4DCB103B.30801@pengutronix.de>
Date: Thu, 12 May 2011 00:39:55 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <2BFFDAA0A0DE4820876E5549867938EC@subhasishg> <201105112331.47954.arnd@arndb.de> <201105112344.44171.arnd@arndb.de>
In-Reply-To: <201105112344.44171.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8EC241D29D6BBC8CC02C61B6"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8EC241D29D6BBC8CC02C61B6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/11/2011 11:44 PM, Arnd Bergmann wrote:
> On Wednesday 11 May 2011, Arnd Bergmann wrote:
>> If that interpretation is right, I would seriously recommend rethinkin=
g
>> the design of the CAN firmware for pruss, so you can start doing somet=
hing
>> useful with the offload engine that fits into the Socket CAN API, or t=
hat
>> would be a useful extension to Socket CAN that is also implementable i=
n
>> the kernel for all other drivers in a meaningful way.
>=20
> I've looked some more into the CAN socket implementation, and I suppose=
 that
> the idea of the pruss driver was really to help do the work from the
> can_rcv_filter function in hardware.
>=20
> Doing this right would really mean supporting both a mode where any new=

> filter that gets added to socket can ends up being added to the hardwar=
e
> as long as it fits, similar to how we can add additional unicast mac
> addresses to an ethernet NIC. However, when the filters from all user
> sockets combined can not be represented in the hardware driver, the har=
dware
> needs to be put into a less efficient mode where all packets are return=
ed
> to the kernel and processed in software.

I'm not sure if reprogramming hardware filters on the fly works on evey
can core. The more conservative solution would be to configure the
filter list globally (+when the interface is down) via netlink.

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig8EC241D29D6BBC8CC02C61B6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3LED8ACgkQjTAFq1RaXHNdxACeLwFT0xztVWoeMHIpY40qta9E
WWAAnRavlolwmhlGdIetboj9G/+BQzB3
=qo1G
-----END PGP SIGNATURE-----

--------------enig8EC241D29D6BBC8CC02C61B6--
