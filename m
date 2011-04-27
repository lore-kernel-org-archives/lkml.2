Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab1D0Nur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:50:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44628 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab1D0Nup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:50:45 -0400
Message-ID: <4DB81F2E.4050802@pengutronix.de>
Date: Wed, 27 Apr 2011 15:50:38 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
CC: "'Wolfgang Grandegger'" <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, toshiharu-linux@dsn.okisemi.com
Subject: Re: Question for canutils
References: <02D6556ECE7A41859777EB7300D12394@hacdom.okisemi.com>
In-Reply-To: <02D6556ECE7A41859777EB7300D12394@hacdom.okisemi.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2B978E32A41305D15BB0F9E9"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2B978E32A41305D15BB0F9E9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/27/2011 10:36 AM, Tomoya MORINAGA wrote:
> I have 2 questions for canutils.
>=20
> 1) Build issue
> I downloaded the latest canutils and libsocketcan.
>    - canutils-4.0.6
>    - libsocketcan-0.0.8
>=20
> Firstly, I installed libsocketcan-0.0.8

Into which location?

Please send me the output of:

ls -l /usr/local/lib
ls -l /usr/local/lib/pkgconfig

> Secondly, I tried to install canutils-4.0.6.
> But it failed like below.
>=20
> [root@localhost canutils-4.0.6]# ./configure
> ...snip...
> checking whether lstat correctly handles trailing slash... yes
> checking whether stat accepts an empty string... no
> checking for socket... yes
> checking for strchr... yes
> checking for strtoul... yes
> checking for pkg-config... /usr/bin/pkg-config
> checking pkg-config is at least version 0.9.0... yes
> checking for libsocketcan... no
> configure: error: *** libsocketcan version above 0.0.8 not found on you=
r system
> [root@localhost canutils-4.0.6]#=20
>=20
> Do you have any information about the fail?

> BTW, Using canutils-3.0.2, I could confirm build becomes success.

3.x doesn't work with the mainline configuration interface.

> 2) How to use
> Executing candump like following, I see the following message.(Of cours=
e, pch_can have already installed)
> [root@localhost morinaga]# candump can0
> interface =3D can0, family =3D 29, type =3D 3, proto =3D 1
> read: Network is down
> [root@localhost morinaga]#
>=20
> Would you tell me how to active can0 interface.

First build the canutils, then configure the bitrate, e.g. 250 kbit/s:
    $ canconfig can0 bitrate 250000
    $ ifconfig can0 up

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig2B978E32A41305D15BB0F9E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk24HzIACgkQjTAFq1RaXHNjrgCdHOdfKWsLdbJtdm7nmFcOiQiq
5MYAoIdidwYj1JBB44NmLTYjUtCfs9Yv
=2jry
-----END PGP SIGNATURE-----

--------------enig2B978E32A41305D15BB0F9E9--
