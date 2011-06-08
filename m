Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1FHHpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:45:41 -0400
Received: from smtp206.alice.it ([82.57.200.102]:59357 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab1FHHpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:45:39 -0400
Date: Wed, 8 Jun 2011 09:45:23 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Michael Bauer <michael@m-bauer.org>,
        Marcin Tolysz <tolysz@gmail.com>
Subject: Re: [PATCHv4 1/3] sony_ff_hid_descriptor
Message-Id: <20110608094523.c7232556.ospite@studenti.unina.it>
In-Reply-To: <1307179957-24458-1-git-send-email-simon@mungewell.org>
References: <1307179957-24458-1-git-send-email-simon@mungewell.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jun_2011_09_45_23_+0200_Vpzg/rSywJnD5wiS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jun_2011_09_45_23_+0200_Vpzg/rSywJnD5wiS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Jun 2011 02:32:35 -0700
Simon Wood <simon@mungewell.org> wrote:

> This patch modifies the HID descriptor of the Sixaxis controller
> to allow the reporting of the accelerometers and gyro via
> a joystick axis.
>=20
> rewrite section from offset 148

=46rom offset 83? Below I see rdesc[83] =3D=3D 0x75

> --
> 0x75, 0x08,         /*          Report Size (8),            */
> 0x95, 0x27,         /*          Report Count (39),          */ /* all the=
 other data
> lumped together */

I'd keep commit messages wrapped to 72/80 chars as well if possible.

[...]
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

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__8_Jun_2011_09_45_23_+0200_Vpzg/rSywJnD5wiS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3vKJQACgkQ5xr2akVTsAE3GACfZ9QAoMgTkLH7kwAy50y7TShl
xnsAnA/nO45oIhloSaV6SzClycP/I6p/
=adkr
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jun_2011_09_45_23_+0200_Vpzg/rSywJnD5wiS--
