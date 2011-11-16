Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1KPVVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:21:50 -0500
Received: from smtp207.alice.it ([82.57.200.103]:49090 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1KPVVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:21:49 -0500
Date: Wed, 16 Nov 2011 22:21:00 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Johan Hovold <jhovold@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Purdie <rpurdie@rpsys.net>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert
 "leds: save the delay values after a successful call to blink_set()"
Message-Id: <20111116222100.323aa751b8a19c0fc2e08a97@studenti.unina.it>
In-Reply-To: <1320662197-21471-1-git-send-email-jhovold@gmail.com>
References: <1317973118.3988.2.camel@jlt3.sipsolutions.net>
	<1320662197-21471-1-git-send-email-jhovold@gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Nov_2011_22_21_00_+0100_g1Zqb_MuqmoQfoGU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Nov_2011_22_21_00_+0100_g1Zqb_MuqmoQfoGU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon,  7 Nov 2011 11:36:37 +0100
Johan Hovold <jhovold@gmail.com> wrote:

> This reverts commit 6123b0e274503a0d3588e84fbe07c9aa01bfaf5d.
>=20
> The problem this patch intends to solve has already been fixed by commit
> 7a5caabd090b8f7 (drivers/leds/ledtrig-timer.c: fix broken sysfs delay
> handling).
>=20
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Sorry for not replying earlier, I was on vacation.

Thanks Johan, I've just verified the timer trigger works fine on 3.1
indeed even without my changes. But keep reading, please.

> ---
>=20
> Hi,=20
>=20
> A fix for the problem with the delay parameters not being stored is alrea=
dy in
> 3.1 (and stable). Rather than storing both values at every call to
> led_blink_set only the updated value is stored in led_delay_{on,off}_stor=
e in
> ledtrig-timer.c.
>

I thought that this was better fixed in the led_blink_set() directly,
as delay_on and delay_off are led_cdev fields after all, not
necessarily specific to ledtrig-timer, what about other users of them?
For example I can see led_blink_set() used in: net/mac80211/led.c
and led_trigger_blink(), which uses led_blink_set() in:
drivers/power/power_supply_leds.c

Maybe I am missing something.

Regards,
   Antonio

> Thanks,
> Johan
>=20
>  drivers/leds/led-class.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 661b692..6d5628b 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -270,11 +270,8 @@ void led_blink_set(struct led_classdev *led_cdev,
>  	del_timer_sync(&led_cdev->blink_timer);
> =20
>  	if (led_cdev->blink_set &&
> -	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
> -		led_cdev->blink_delay_on =3D *delay_on;
> -		led_cdev->blink_delay_off =3D *delay_off;
> +	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
>  		return;
> -	}
> =20
>  	/* blink with 1 Hz as default if nothing specified */
>  	if (!*delay_on && !*delay_off)
> --=20
> 1.7.6
>=20
>=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__16_Nov_2011_22_21_00_+0100_g1Zqb_MuqmoQfoGU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7EKTwACgkQ5xr2akVTsAF+kgCfcH+5CBBaTSx0MYASnHDxDUEF
tcwAn086J90I2Ru3eLHjfCd9tkNfjH7+
=indn
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Nov_2011_22_21_00_+0100_g1Zqb_MuqmoQfoGU--
