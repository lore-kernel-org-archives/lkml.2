Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2HALiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 07:38:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2HALiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 07:38:01 -0400
Message-ID: <50191509.8030404@pengutronix.de>
Date: Wed, 01 Aug 2012 13:37:45 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v4] can: add tx/rx LED trigger support
References: <5017C8E4.4020003@pengutronix.de> <1343772338-1526-1-git-send-email-fabio.baltieri@gmail.com> <5018F8B3.6080404@pengutronix.de> <20120801103032.GA1385@gmail.com>
In-Reply-To: <20120801103032.GA1385@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC03E5205E9B19DD1A9AEE815"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC03E5205E9B19DD1A9AEE815
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/01/2012 12:30 PM, Fabio Baltieri wrote:
[...]
>>> +void can_led_init(struct net_device *netdev)
>>> +{
>>> +	struct can_priv *priv =3D netdev_priv(netdev);
>>> +	void *res;
>>> +
>>> +	res =3D devres_alloc(can_led_release, 0, GFP_KERNEL);
>>                                             ^
>> I'm not really sure if this is working. For example, pinctrl [1]
>> allocates a double pointer here. The res pointer here and in
>> can_led_release simply points to invalid memory. But as long as you
>> don't dereference it, it should work.
>>
>> [1] http://lxr.free-electrons.com/source/drivers/pinctrl/core.c#L862
>=20
> Actually that's also used by libata-core (not in lxr yet) and dma-mappi=
ng:
>=20
> http://lxr.free-electrons.com/source/drivers/base/dma-mapping.c#L193
>=20
> actually, res should point at the end of some internal devres structure=
,
> and is only used as return value in this case.
>=20
> Of course, in this case the release function can only use the struct
> device pointer.
>=20
> I've run some fail test and ftraced the whole thing and it seems to wor=
k
> pretty good!  I'll send a v5 with the rename later.

Thanks for checking. I just noticed, the pinctrl usecase is a bit differe=
nt.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC03E5205E9B19DD1A9AEE815
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAZFRAACgkQjTAFq1RaXHOrAQCgj/wB/GbHM032ywRp9JzCXWaS
qywAnROqiNlNFCHFUc54uwgV+fzeYl/a
=v+6P
-----END PGP SIGNATURE-----

--------------enigC03E5205E9B19DD1A9AEE815--
