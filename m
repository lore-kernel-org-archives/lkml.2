Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1KPPAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:00:48 -0500
Received: from smtp205.alice.it ([82.57.200.101]:46600 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1KPPAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:00:47 -0500
Date: Wed, 16 Nov 2011 16:00:07 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: leds-lp3944, fix "sparse" warning
 "mixing different enum types"
Message-Id: <20111116160007.5a834380ca396153931cc238@studenti.unina.it>
In-Reply-To: <1317936884-2320-1-git-send-email-ospite@studenti.unina.it>
References: <20111005222143.665f7a7e922dbb2b2541007a@studenti.unina.it>
	<1317936884-2320-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Nov_2011_16_00_07_+0100_Mm+_SY5KLZsr9B+3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Nov_2011_16_00_07_+0100_Mm+_SY5KLZsr9B+3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu,  6 Oct 2011 23:34:44 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Fix a warning from "sparse":
>=20
> drivers/leds/leds-lp3944.c:292:23: warning: mixing different enum types
> drivers/leds/leds-lp3944.c:292:23:     int enum led_brightness  versus
> drivers/leds/leds-lp3944.c:292:23:     int enum lp3944_status
>=20
> Keeping track of LP3944_LED_STATUS_OFF and LP3944_LED_STATUS_ON only in
> lp3944_led_set_brightness() is OK, as the handling of DIM (blinking)
> mode[s] is in lp3944_led_set_blink().
>=20
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Ping.
Dan, did you receive this one? I can't see it in 3.2-rc2.

Regards,
   Antonio.

> ---
>  drivers/leds/leds-lp3944.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
> index 9010c05..3cc01fb 100644
> --- a/drivers/leds/leds-lp3944.c
> +++ b/drivers/leds/leds-lp3944.c
> @@ -289,7 +289,7 @@ static void lp3944_led_set_brightness(struct led_clas=
sdev *led_cdev,
>  	dev_dbg(&led->client->dev, "%s: %s, %d\n",
>  		__func__, led_cdev->name, brightness);
> =20
> -	led->status =3D brightness;
> +	led->status =3D !!brightness;
>  	schedule_work(&led->work);
>  }
> =20
> --=20
> 1.7.6.3
>=20
>=20


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__16_Nov_2011_16_00_07_+0100_Mm+_SY5KLZsr9B+3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7Dz/cACgkQ5xr2akVTsAFEgQCfc227ezyYgmNPPrWjrPsZakU5
+t4AoIf2jsDxFevsL4KRfCZIVqn+oYD1
=agzn
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Nov_2011_16_00_07_+0100_Mm+_SY5KLZsr9B+3--
