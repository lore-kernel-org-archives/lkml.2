Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2HAKHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:07:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37667 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2HAKHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:07:35 -0400
Message-ID: <5018FFE4.4010508@pengutronix.de>
Date: Wed, 01 Aug 2012 12:07:32 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v4] can: add tx/rx LED trigger support
References: <5017C8E4.4020003@pengutronix.de> <1343772338-1526-1-git-send-email-fabio.baltieri@gmail.com> <5018F8B3.6080404@pengutronix.de>
In-Reply-To: <5018F8B3.6080404@pengutronix.de>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1E15744235B95049B9CF044D"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E15744235B95049B9CF044D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/01/2012 11:36 AM, Marc Kleine-Budde wrote:
[...]

>> +/*
>> + * Register CAN LED triggers for a CAN device
>> + *
>> + * This is normally called from a driver's probe function
>> + */
>> +void can_led_init(struct net_device *netdev)
>> +{
>> +	struct can_priv *priv =3D netdev_priv(netdev);
>> +	void *res;
>> +
>> +	res =3D devres_alloc(can_led_release, 0, GFP_KERNEL);
>                                             ^
> I'm not really sure if this is working. For example, pinctrl [1]
> allocates a double pointer here. The res pointer here and in
> can_led_release simply points to invalid memory. But as long as you
> don't dereference it, it should work.
>=20
> [1] http://lxr.free-electrons.com/source/drivers/pinctrl/core.c#L862

The pinctrl usecase if different, pinctrl needs that extra memory
because they cannot get a reference to their pinctrl they have to put.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig1E15744235B95049B9CF044D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAY/+QACgkQjTAFq1RaXHMgqwCfbZzsGCrf76moLMToeQbYiZUb
j6oAniJqfHsMTVdbq5K7wLjl00iWCybI
=dz9U
-----END PGP SIGNATURE-----

--------------enig1E15744235B95049B9CF044D--
