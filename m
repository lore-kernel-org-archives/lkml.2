Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2HAMSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:18:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47094 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2HAMSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:18:50 -0400
Message-ID: <50191EA5.1040303@pengutronix.de>
Date: Wed, 01 Aug 2012 14:18:45 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Oliver Hartkopp <socketcan@hartkopp.net>
CC: linux-can@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v5 1/2] can: add tx/rx LED trigger support
References: <5018F8B3.6080404@pengutronix.de> <1343821782-1346-1-git-send-email-fabio.baltieri@gmail.com> <1920193464.85058.1343822773242.JavaMail.open-xchange@webmail.strato.de>
In-Reply-To: <1920193464.85058.1343822773242.JavaMail.open-xchange@webmail.strato.de>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3C570057AD755E341A46A0A4"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3C570057AD755E341A46A0A4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/01/2012 02:06 PM, Oliver Hartkopp wrote:
> Sorry for this potentially mangled mail from my webmail access ...
>=20
> Fabio Baltieri <fabio.baltieri@gmail.com> hat am 1. August 2012 um 13:4=
9
> geschrieben:
>=20
>> +void devm_can_led_init(struct net_device *netdev)
>> +{
>> +  struct can_priv *priv =3D netdev_priv(netdev);
>> +  void *res;
>> +
>> +  res =3D devres_alloc(can_led_release, 0, GFP_KERNEL);
>> +  if (!res)
>> +          goto err_out;
>> +
>> +  priv->tx_led_trig_name =3D kasprintf(GFP_KERNEL, "%s-tx", netdev->n=
ame);
>=20
> IMO putting a string with 8 or 9 bytes into a separate kmalloc memory s=
niplet is
> pretty oversized.
> Ok - these functions provide to hide the complexitiy for allocating and=
 storing
> strings, which is
> definitely fine for path names and these kind of strings that are not k=
nown in
> length and probably
> more than 100 bytes long.
>=20
> But in this case i would suggest to allocate a fixed space in can_priv,=
 as we
> know the string length
> very good (IFNAMSZ + strlen("-tx")) and there's no reason to get all th=
e
> overhead from three kmallocs
> instead of one for that small memory allocations.
>=20
> So i would suggest:
>=20
>> @@ -52,6 +53,13 @@ struct can_priv {
>>
>>    unsigned int echo_skb_max;
>>    struct sk_buff **echo_skb;
>> +
>> +#ifdef CONFIG_CAN_LEDS
>> +  struct led_trigger *tx_led_trig;
>> +  char *tx_led_trig_name;
>=20
> char tx_led_trig_name[IFNAMSZ+4];
>=20
>> +  struct led_trigger *rx_led_trig;
>> +  char *rx_led_trig_name;
>=20
> char rx_led_trig_name[IFNAMSZ+4];
>=20
>> +#endif
>>  };

Sounds reasonable. Please Introduce a #define for "IFNAMSZ + 4" and
document where the 4 comes from. Send a v6 patch, I'll force update the
git repo, after you have Oliver's Acked-by.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig3C570057AD755E341A46A0A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAZHqYACgkQjTAFq1RaXHO0egCeJgHqkhU5BiBVPnBpR2UbQRHc
qYQAnit7W6KyadOyZDa8pHt+x3KG8kES
=qGOc
-----END PGP SIGNATURE-----

--------------enig3C570057AD755E341A46A0A4--
