Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2CMI3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:29:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40276 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2CMI24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:28:56 -0400
Date: Tue, 13 Mar 2012 19:28:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Mircea Gherzan <mgherzan@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120313192844.34278a4baa0b475391191d40@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_19_28_44_+1100_Bio4Yh2lBQkV5Uj_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_19_28_44_+1100_Bio4Yh2lBQkV5Uj_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/board-omap4panda.c between commit 3c90c98a1ebb
("OMAP4: omap4panda: Enable audio support") from the sound tree and
commit 65f19159ddc4 ("ARM: OMAP: enable Bluetooth on the PandaBoard")
from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-omap4panda.c
index e441591,3f3055d..0000000
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@@ -92,34 -91,15 +92,40 @@@ static struct platform_device leds_gpi
  	},
  };
 =20
 +static struct omap_abe_twl6040_data panda_abe_audio_data =3D {
 +	/* Audio out */
 +	.has_hs		=3D ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
 +	/* HandsFree through expasion connector */
 +	.has_hf		=3D ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
 +	/* PandaBoard: FM TX, PandaBoardES: can be connected to audio out */
 +	.has_aux	=3D ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
 +	/* PandaBoard: FM RX, PandaBoardES: audio in */
 +	.has_afm	=3D ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
 +	/* No jack detection. */
 +	.jack_detection	=3D 0,
 +	/* MCLK input is 38.4MHz */
 +	.mclk_freq	=3D 38400000,
 +
 +};
 +
 +static struct platform_device panda_abe_audio =3D {
 +	.name		=3D "omap-abe-twl6040",
 +	.id		=3D -1,
 +	.dev =3D {
 +		.platform_data =3D &panda_abe_audio_data,
 +	},
 +};
 +
+ static struct platform_device btwilink_device =3D {
+ 	.name	=3D "btwilink",
+ 	.id	=3D -1,
+ };
+=20
  static struct platform_device *panda_devices[] __initdata =3D {
  	&leds_gpio,
  	&wl1271_device,
 +	&panda_abe_audio,
+ 	&btwilink_device,
  };
 =20
  static const struct usbhs_omap_board_data usbhs_bdata __initconst =3D {

--Signature=_Tue__13_Mar_2012_19_28_44_+1100_Bio4Yh2lBQkV5Uj_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXwU8AAoJEECxmPOUX5FEiosP/0hopjb9jjS1wW3ibhH8laCM
Ye7Rsxzxbh/MzD9FYdm3kEW12D/CTKpZGhHb/9sbdINp4ZyFUOLSgSnIK/w8f9zt
Xf3ez9iYPDedu8NI4AaiJb2iwAnm+NlVq1XVeimfYAsveAnQOldzJmvX4NP+8Lbm
PGDWOrBo9TjC9+9/yw0cyztFBPAW51D3XxkpS5nHZ/0j2Q8/Y0CQEZYwh/0kBPr3
JgZaYAn/KMmSZiwLZuZLTVD0eDF1k8wA5h43pbNNHvX4JCHpg54h2zsngXcIkVFn
S7vRO3MXzQj5gRbzIjoZ8r3LB1qKMZupFrpRuyD0S5luMjvIw1h6RtbIRNI8lQN+
lpN31osC1hV6R2rwQLcCOfjOTlXuSJUJSZgPWSBNRmNHezvgv37lP+b9UszCFN/G
wFe3CPJa5BrfOEAY5KVyhuRU3EsO41aowfgwcf2kciAjUxkq/6fR8i6uG9sgnjXJ
dFwU0kt+XDkE/IVHz3g9MU9btW3ENoOzwnE0WvI/15N84MBgFNSouGa8yXV06xBI
vkJwwvVAheQQ0i/AlyTVOjN4NBO9SVejpaUVs7rYJGXiGUQ3JN9yBxwdN0zEX2WC
zgD6T5xBOu+o4clkb9UMw4FhKOmVji4l2bWdBx/dUBBZdBYLnB2YEHM9Z7kO+xOL
m6r2I0brq/kOg6PwLM4c
=/Mpu
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_19_28_44_+1100_Bio4Yh2lBQkV5Uj_--
