Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2GaMAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:00:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51223 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2GaMAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:00:41 -0400
Message-ID: <5017C8E4.4020003@pengutronix.de>
Date: Tue, 31 Jul 2012 14:00:36 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v3 1/2] can: add tx/rx LED trigger support
References: <1343676041-29572-1-git-send-email-fabio.baltieri@gmail.com> <5016FA01.5000109@pengutronix.de> <20120731065733.GA30267@gmail.com> <501784C8.9050803@pengutronix.de> <20120731115733.GB30417@gmail.com>
In-Reply-To: <20120731115733.GB30417@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig05D7B327D6C64F42C5EED01A"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig05D7B327D6C64F42C5EED01A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/31/2012 01:57 PM, Fabio Baltieri wrote:
[...]

>>>> Can you provide a devm implementation for can_led?
>>>
>>> Sounds reasonable, you mean like a devm_kasprintf implementation to
>>> remove kfree and unwinding code?
>>
>> IMHO it would be sufficient if you implement the devm cleanup function=
s
>> here.
>=20
> Uh - can you be more specific?  I mean, are you suggesting to just
> convert the code to something like:
>=20
> unsigned int len;
> char *p;
>=20
> len =3D snprintf(NULL, 0, "%s-tx", netdev->name);
> p =3D devm_kzalloc(&netdev->dev, len + 1, GFP_KERNEL);
> if (!p)
> return -ENOMEM;
> sprintf(p, len + 1, "%s-tx", netdev->name);

This would work, if you just have to free both names, but...

> or to implement something with devres_alloc() and a specific
> release function?

=2E..you have to call led_trigger_unregister_simple(), so we need a custo=
m
release function.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig05D7B327D6C64F42C5EED01A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAXyOQACgkQjTAFq1RaXHOrqgCfR1xP0itAC6UcfCW9B2FuNvQ+
0OQAn3lhSjV4AoKtOv8jB+q0AsHV+uSF
=WBxJ
-----END PGP SIGNATURE-----

--------------enig05D7B327D6C64F42C5EED01A--
