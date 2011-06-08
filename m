Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1FHHrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:47:23 -0400
Received: from smtp209.alice.it ([82.57.200.105]:43641 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab1FHHrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:47:21 -0400
Date: Wed, 8 Jun 2011 09:47:14 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Michael Bauer <michael@m-bauer.org>,
        Marcin Tolysz <tolysz@gmail.com>
Subject: Re: [PATCHv4 3/3] sony_ff_bluetooth
Message-Id: <20110608094714.9291d5e8.ospite@studenti.unina.it>
In-Reply-To: <1307179957-24458-3-git-send-email-simon@mungewell.org>
References: <1307179957-24458-1-git-send-email-simon@mungewell.org>
	<1307179957-24458-3-git-send-email-simon@mungewell.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jun_2011_09_47_14_+0200_9Cktdaz7TIgWW7cW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jun_2011_09_47_14_+0200_9Cktdaz7TIgWW7cW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Jun 2011 02:32:37 -0700
Simon Wood <simon@mungewell.org> wrote:

> Add support for patching the HID descriptor when Sixaxis is connect
> via Bluetooth. In this mode the desciptor contains a trailing '0x00'.
>=20
> Patch suggested by Antonio
>

Simon I think this one can be split and the first hunk can be merged
with 1/2 and the second hunk with 2/2.

Also the short commit messages still need to be fixed for all the
patches to be more descriptive, if you don't want to spend any more
time on that just tell and I'll do it :)

Thanks,
   Antonio

> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> Signed-off-by: Simon Wood <simon@mungewell.org>
> ---
>  drivers/hid/hid-sony.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
> index f219746..5d37f97 100644
> --- a/drivers/hid/hid-sony.c
> +++ b/drivers/hid/hid-sony.c
> @@ -49,8 +49,11 @@ static __u8 *sony_report_fixup(struct hid_device *hdev=
, __u8 *rdesc,
>  		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
>  		rdesc[55] =3D 0x06;
>  	}
> -	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
> -			*rsize =3D=3D 148 && rdesc[83] =3D=3D 0x75) {
> +
> +	/* The HID descriptor exposed over BT has a trailing zero byte */
> +	if ((((sc->quirks & SIXAXIS_CONTROLLER_USB) && *rsize =3D=3D 148) ||
> +			((sc->quirks & SIXAXIS_CONTROLLER_BT)  && *rsize =3D=3D 149 )) &&
> +			rdesc[83] =3D=3D 0x75) {
>  		hid_info(hdev, "Fixing up Sony Sixaxis report descriptor\n");
>  		memcpy((void *)&rdesc[83], (void *) &sixaxis_rdesc_fixup, sizeof(sixax=
is_rdesc_fixup));
>  	}
> @@ -64,7 +67,7 @@ static int sony_raw_event(struct hid_device *hdev, stru=
ct hid_report *report, __
>  {
>  	struct sony_sc *sc =3D hid_get_drvdata(hdev);
> =20
> -	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
> +	if ((sc->quirks & (SIXAXIS_CONTROLLER_USB | SIXAXIS_CONTROLLER_BT)) &&
>  			rd[0] =3D=3D 0x01 && size =3D=3D 49) {
>  		swap(rd[41], rd[42]);
>  		swap(rd[43], rd[44]);
> --=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__8_Jun_2011_09_47_14_+0200_9Cktdaz7TIgWW7cW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3vKQIACgkQ5xr2akVTsAFiLwCglJHHPFg6uU4hfzcMsrSgBEFE
mVAAn1H9dR0xymD57CLYFdwQF5Nt2K/2
=HhSW
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jun_2011_09_47_14_+0200_9Cktdaz7TIgWW7cW--
