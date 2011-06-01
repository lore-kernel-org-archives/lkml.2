Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809Ab1FATyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:54:52 -0400
Received: from smtp205.alice.it ([82.57.200.101]:42274 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759604Ab1FATyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:54:51 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 15:54:50 EDT
Date: Wed, 1 Jun 2011 21:49:24 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcin Tolysz <tolysz@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] sony_ff_hid_descriptor
Message-Id: <20110601214924.36ec42ad.ospite@studenti.unina.it>
In-Reply-To: <1306145999-15643-1-git-send-email-simon@mungewell.org>
References: <80b32cfd7dc9e8afee2c4d9e21d1a7e3.squirrel@host171.canaca.com>
	<1306145999-15643-1-git-send-email-simon@mungewell.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jun_2011_21_49_24_+0200_d4F4Y2iu+vvLfPuP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jun_2011_21_49_24_+0200_d4F4Y2iu+vvLfPuP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 23 May 2011 03:19:58 -0700
Simon Wood <simon@mungewell.org> wrote:

> This patch modifies the HID descriptor to allow the reporting of
> the accelerometers and gyro via a joystick axis.

I am going to test it tomorrow, but for now I notice that the
Signed-off-by is missing. Wait for the test before resending tho.

Plus, the short commit message can be improved a little bit, and the
long commit message could use the classic imperative form used in kernel
commit messages: "Modify the HID descriptor to...", but these are just
suggestions.

Same comments for patch 2/2.

Thanks,
   Antonio

> ---
>  drivers/hid/hid-sony.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
> index 936c911..5c930dc 100644
> --- a/drivers/hid/hid-sony.c
> +++ b/drivers/hid/hid-sony.c
> @@ -28,6 +28,12 @@
>  #define SIXAXIS_CONTROLLER_USB  (1 << 1)
>  #define SIXAXIS_CONTROLLER_BT   (1 << 2)
> =20
> +static const u8 sixaxis_rdesc_fixup[] =3D {
> +	0x95, 0x13, 0x09, 0x01, 0x81, 0x02, 0x95, 0x0C,
> +	0x81, 0x01, 0x75, 0x10, 0x95, 0x04, 0x26, 0xFF,=20
> +	0x03, 0x46, 0xFF, 0x03, 0x09, 0x01, 0x81, 0x02
> +	};
> +
>  struct sony_sc {
>  	unsigned long quirks;
>  };
> @@ -43,6 +49,11 @@ static __u8 *sony_report_fixup(struct hid_device *hdev=
, __u8 *rdesc,
>  		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
>  		rdesc[55] =3D 0x06;
>  	}
> +	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
> +			*rsize =3D=3D 148 && rdesc[83] =3D=3D 0x75) {
> +		hid_info(hdev, "Fixing up Sony Sixaxis report descriptor\n");
> +		memcpy((void *)&rdesc[83], (void *) &sixaxis_rdesc_fixup, sizeof(sixax=
is_rdesc_fixup));
> +	}
>  	return rdesc;
>  }
> =20
> --=20
> 1.7.4.1
>=20
>=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__1_Jun_2011_21_49_24_+0200_d4F4Y2iu+vvLfPuP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3ml8QACgkQ5xr2akVTsAFJEQCffPEyZ2/gaXifW1GEaq9x9ka4
MlIAnjFO0Os6SF34uK2Ryl1S3T3GHvLT
=7FoC
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jun_2011_21_49_24_+0200_d4F4Y2iu+vvLfPuP--
