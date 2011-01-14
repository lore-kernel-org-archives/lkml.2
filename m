Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1ANMdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:33:09 -0500
Received: from zucker.schokokeks.org ([178.63.68.96]:38457 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1ANMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:32:59 -0500
Date: Fri, 14 Jan 2011 13:32:53 +0100
From: Hanno =?ISO-8859-1?B?QvZjaw==?= <hanno@hboeck.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, alsa-devel@alsa-project.org,
        perex@perex.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: constify functions in ac97
Message-ID: <20110114133253.3f843678@laverne>
In-Reply-To: <s5hei8i838t.wl%tiwai@suse.de>
References: <201101121203.55901.hanno@hboeck.de>
	<AANLkTi=SJpxh5h774shB+MW=xM8cyfunyJYO0deU9mCT@mail.gmail.com>
	<s5hei8i838t.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-26107-1295008376-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-26107-1295008376-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Wed, 12 Jan 2011 18:02:10 +0100
schrieb Takashi Iwai <tiwai@suse.de>:

> Yes.  Hanno, could you fix and resubmit?

Here it comes:


Signed-off-by: Hanno Boeck <hanno@hboeck.de>
---
diff -Naurp linux-2.6.37-vanilla//include/sound/ac97_codec.h linux-2.6.37-c=
onst//include/sound/ac97_codec.h
--- linux-2.6.37-vanilla//include/sound/ac97_codec.h	2011-01-05 01:50:19.00=
0000000 +0100
+++ linux-2.6.37-const//include/sound/ac97_codec.h	2011-01-14 13:24:32.9059=
56806 +0100
@@ -477,7 +477,7 @@ struct snd_ac97_template {
=20
 struct snd_ac97 {
 	/* -- lowlevel (hardware) driver specific -- */
-	struct snd_ac97_build_ops * build_ops;
+	const struct snd_ac97_build_ops *build_ops;
 	void *private_data;
 	void (*private_free) (struct snd_ac97 *ac97);
 	/* --- */
diff -Naurp linux-2.6.37-vanilla//sound/pci/ac97/ac97_codec.c linux-2.6.37-=
const//sound/pci/ac97/ac97_codec.c
--- linux-2.6.37-vanilla//sound/pci/ac97/ac97_codec.c	2011-01-05 01:50:19.0=
00000000 +0100
+++ linux-2.6.37-const//sound/pci/ac97/ac97_codec.c	2011-01-14 13:24:32.906=
956799 +0100
@@ -1962,7 +1962,7 @@ static int snd_ac97_dev_disconnect(struc
 }
=20
 /* build_ops to do nothing */
-static struct snd_ac97_build_ops null_build_ops;
+static const struct snd_ac97_build_ops null_build_ops;
=20
 #ifdef CONFIG_SND_AC97_POWER_SAVE
 static void do_update_power(struct work_struct *work)
diff -Naurp linux-2.6.37-vanilla//sound/pci/ac97/ac97_patch.c linux-2.6.37-=
const//sound/pci/ac97/ac97_patch.c
--- linux-2.6.37-vanilla//sound/pci/ac97/ac97_patch.c	2011-01-05 01:50:19.0=
00000000 +0100
+++ linux-2.6.37-const//sound/pci/ac97/ac97_patch.c	2011-01-14 13:24:32.917=
956733 +0100
@@ -371,7 +371,7 @@ static int patch_yamaha_ymf743_build_spd
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_yamaha_ymf743_ops =3D {
+static const struct snd_ac97_build_ops patch_yamaha_ymf743_ops =3D {
 	.build_spdif	=3D patch_yamaha_ymf743_build_spdif,
 	.build_3d	=3D patch_yamaha_ymf7x3_3d,
 };
@@ -455,7 +455,7 @@ static int patch_yamaha_ymf753_post_spdi
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_yamaha_ymf753_ops =3D {
+static const struct snd_ac97_build_ops patch_yamaha_ymf753_ops =3D {
 	.build_3d	=3D patch_yamaha_ymf7x3_3d,
 	.build_post_spdif =3D patch_yamaha_ymf753_post_spdif
 };
@@ -502,7 +502,7 @@ static int patch_wolfson_wm9703_specific
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_wolfson_wm9703_ops =3D {
+static const struct snd_ac97_build_ops patch_wolfson_wm9703_ops =3D {
 	.build_specific =3D patch_wolfson_wm9703_specific,
 };
=20
@@ -533,7 +533,7 @@ static int patch_wolfson_wm9704_specific
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_wolfson_wm9704_ops =3D {
+static const struct snd_ac97_build_ops patch_wolfson_wm9704_ops =3D {
 	.build_specific =3D patch_wolfson_wm9704_specific,
 };
=20
@@ -677,7 +677,7 @@ static int patch_wolfson_wm9711_specific
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_wolfson_wm9711_ops =3D {
+static const struct snd_ac97_build_ops patch_wolfson_wm9711_ops =3D {
 	.build_specific =3D patch_wolfson_wm9711_specific,
 };
=20
@@ -871,7 +871,7 @@ static void patch_wolfson_wm9713_resume
 }
 #endif
=20
-static struct snd_ac97_build_ops patch_wolfson_wm9713_ops =3D {
+static const struct snd_ac97_build_ops patch_wolfson_wm9713_ops =3D {
 	.build_specific =3D patch_wolfson_wm9713_specific,
 	.build_3d =3D patch_wolfson_wm9713_3d,
 #ifdef CONFIG_PM=09
@@ -976,7 +976,7 @@ static int patch_sigmatel_stac97xx_speci
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_sigmatel_stac9700_ops =3D {
+static const struct snd_ac97_build_ops patch_sigmatel_stac9700_ops =3D {
 	.build_3d	=3D patch_sigmatel_stac9700_3d,
 	.build_specific	=3D patch_sigmatel_stac97xx_specific
 };
@@ -1023,7 +1023,7 @@ static int patch_sigmatel_stac9708_speci
 	return patch_sigmatel_stac97xx_specific(ac97);
 }
=20
-static struct snd_ac97_build_ops patch_sigmatel_stac9708_ops =3D {
+static const struct snd_ac97_build_ops patch_sigmatel_stac9708_ops =3D {
 	.build_3d	=3D patch_sigmatel_stac9708_3d,
 	.build_specific	=3D patch_sigmatel_stac9708_specific
 };
@@ -1252,7 +1252,7 @@ static int patch_sigmatel_stac9758_speci
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_sigmatel_stac9758_ops =3D {
+static const struct snd_ac97_build_ops patch_sigmatel_stac9758_ops =3D {
 	.build_3d	=3D patch_sigmatel_stac9700_3d,
 	.build_specific	=3D patch_sigmatel_stac9758_specific
 };
@@ -1327,7 +1327,7 @@ static int patch_cirrus_build_spdif(stru
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_cirrus_ops =3D {
+static const struct snd_ac97_build_ops patch_cirrus_ops =3D {
 	.build_spdif =3D patch_cirrus_build_spdif
 };
=20
@@ -1384,7 +1384,7 @@ static int patch_conexant_build_spdif(st
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_conexant_ops =3D {
+static const struct snd_ac97_build_ops patch_conexant_ops =3D {
 	.build_spdif =3D patch_conexant_build_spdif
 };
=20
@@ -1560,7 +1560,7 @@ static void patch_ad1881_chained(struct
 	}
 }
=20
-static struct snd_ac97_build_ops patch_ad1881_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1881_build_ops =3D {
 #ifdef CONFIG_PM
 	.resume =3D ad18xx_resume
 #endif
@@ -1647,7 +1647,7 @@ static int patch_ad1885_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_ad1885_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1885_build_ops =3D {
 	.build_specific =3D &patch_ad1885_specific,
 #ifdef CONFIG_PM
 	.resume =3D ad18xx_resume
@@ -1674,7 +1674,7 @@ static int patch_ad1886_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_ad1886_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1886_build_ops =3D {
 	.build_specific =3D &patch_ad1886_specific,
 #ifdef CONFIG_PM
 	.resume =3D ad18xx_resume
@@ -1881,7 +1881,7 @@ static int patch_ad1981a_specific(struct
 				    ARRAY_SIZE(snd_ac97_ad1981x_jack_sense));
 }
=20
-static struct snd_ac97_build_ops patch_ad1981a_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1981a_build_ops =3D {
 	.build_post_spdif =3D patch_ad198x_post_spdif,
 	.build_specific =3D patch_ad1981a_specific,
 #ifdef CONFIG_PM
@@ -1936,7 +1936,7 @@ static int patch_ad1981b_specific(struct
 				    ARRAY_SIZE(snd_ac97_ad1981x_jack_sense));
 }
=20
-static struct snd_ac97_build_ops patch_ad1981b_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1981b_build_ops =3D {
 	.build_post_spdif =3D patch_ad198x_post_spdif,
 	.build_specific =3D patch_ad1981b_specific,
 #ifdef CONFIG_PM
@@ -2075,7 +2075,7 @@ static int patch_ad1888_specific(struct
 	return patch_build_controls(ac97, snd_ac97_ad1888_controls, ARRAY_SIZE(sn=
d_ac97_ad1888_controls));
 }
=20
-static struct snd_ac97_build_ops patch_ad1888_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1888_build_ops =3D {
 	.build_post_spdif =3D patch_ad198x_post_spdif,
 	.build_specific =3D patch_ad1888_specific,
 #ifdef CONFIG_PM
@@ -2124,7 +2124,7 @@ static int patch_ad1980_specific(struct
 	return patch_build_controls(ac97, &snd_ac97_ad198x_2cmic, 1);
 }
=20
-static struct snd_ac97_build_ops patch_ad1980_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1980_build_ops =3D {
 	.build_post_spdif =3D patch_ad198x_post_spdif,
 	.build_specific =3D patch_ad1980_specific,
 #ifdef CONFIG_PM
@@ -2239,7 +2239,7 @@ static int patch_ad1985_specific(struct
 				    ARRAY_SIZE(snd_ac97_ad1985_controls));
 }
=20
-static struct snd_ac97_build_ops patch_ad1985_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1985_build_ops =3D {
 	.build_post_spdif =3D patch_ad198x_post_spdif,
 	.build_specific =3D patch_ad1985_specific,
 #ifdef CONFIG_PM
@@ -2531,7 +2531,7 @@ static int patch_ad1986_specific(struct
 				    ARRAY_SIZE(snd_ac97_ad1985_controls));
 }
=20
-static struct snd_ac97_build_ops patch_ad1986_build_ops =3D {
+static const struct snd_ac97_build_ops patch_ad1986_build_ops =3D {
 	.build_post_spdif =3D patch_ad198x_post_spdif,
 	.build_specific =3D patch_ad1986_specific,
 #ifdef CONFIG_PM
@@ -2636,7 +2636,7 @@ static int patch_alc650_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_alc650_ops =3D {
+static const struct snd_ac97_build_ops patch_alc650_ops =3D {
 	.build_specific	=3D patch_alc650_specific,
 	.update_jacks =3D alc650_update_jacks
 };
@@ -2788,7 +2788,7 @@ static int patch_alc655_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_alc655_ops =3D {
+static const struct snd_ac97_build_ops patch_alc655_ops =3D {
 	.build_specific	=3D patch_alc655_specific,
 	.update_jacks =3D alc655_update_jacks
 };
@@ -2900,7 +2900,7 @@ static int patch_alc850_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_alc850_ops =3D {
+static const struct snd_ac97_build_ops patch_alc850_ops =3D {
 	.build_specific	=3D patch_alc850_specific,
 	.update_jacks =3D alc850_update_jacks
 };
@@ -2962,7 +2962,7 @@ static int patch_cm9738_specific(struct
 	return patch_build_controls(ac97, snd_ac97_cm9738_controls, ARRAY_SIZE(sn=
d_ac97_cm9738_controls));
 }
=20
-static struct snd_ac97_build_ops patch_cm9738_ops =3D {
+static const struct snd_ac97_build_ops patch_cm9738_ops =3D {
 	.build_specific	=3D patch_cm9738_specific,
 	.update_jacks =3D cm9738_update_jacks
 };
@@ -3053,7 +3053,7 @@ static int patch_cm9739_post_spdif(struc
 	return patch_build_controls(ac97, snd_ac97_cm9739_controls_spdif, ARRAY_S=
IZE(snd_ac97_cm9739_controls_spdif));
 }
=20
-static struct snd_ac97_build_ops patch_cm9739_ops =3D {
+static const struct snd_ac97_build_ops patch_cm9739_ops =3D {
 	.build_specific	=3D patch_cm9739_specific,
 	.build_post_spdif =3D patch_cm9739_post_spdif,
 	.update_jacks =3D cm9739_update_jacks
@@ -3227,7 +3227,7 @@ static int patch_cm9761_specific(struct
 	return patch_build_controls(ac97, snd_ac97_cm9761_controls, ARRAY_SIZE(sn=
d_ac97_cm9761_controls));
 }
=20
-static struct snd_ac97_build_ops patch_cm9761_ops =3D {
+static const struct snd_ac97_build_ops patch_cm9761_ops =3D {
 	.build_specific	=3D patch_cm9761_specific,
 	.build_post_spdif =3D patch_cm9761_post_spdif,
 	.update_jacks =3D cm9761_update_jacks
@@ -3323,7 +3323,7 @@ static int patch_cm9780_specific(struct
 	return patch_build_controls(ac97, cm9780_controls, ARRAY_SIZE(cm9780_cont=
rols));
 }
=20
-static struct snd_ac97_build_ops patch_cm9780_ops =3D {
+static const struct snd_ac97_build_ops patch_cm9780_ops =3D {
 	.build_specific	=3D patch_cm9780_specific,
 	.build_post_spdif =3D patch_cm9761_post_spdif	/* identical with CM9761 */
 };
@@ -3443,7 +3443,7 @@ static int patch_vt1616_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_vt1616_ops =3D {
+static const struct snd_ac97_build_ops patch_vt1616_ops =3D {
 	.build_specific	=3D patch_vt1616_specific
 };
=20
@@ -3797,7 +3797,7 @@ static int patch_it2646_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_it2646_ops =3D {
+static const struct snd_ac97_build_ops patch_it2646_ops =3D {
 	.build_specific	=3D patch_it2646_specific,
 	.update_jacks =3D it2646_update_jacks
 };
@@ -3831,7 +3831,7 @@ static int patch_si3036_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_si3036_ops =3D {
+static const struct snd_ac97_build_ops patch_si3036_ops =3D {
 	.build_specific	=3D patch_si3036_specific,
 };
=20
@@ -3898,7 +3898,7 @@ static int patch_ucb1400_specific(struct
 	return 0;
 }
=20
-static struct snd_ac97_build_ops patch_ucb1400_ops =3D {
+static const struct snd_ac97_build_ops patch_ucb1400_ops =3D {
 	.build_specific	=3D patch_ucb1400_specific,
 };
=20

--=_zucker.schokokeks.org-26107-1295008376-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAEBCAAGBQJNMEJ1AAoJEKWIAHK7tR5CfFQP/Rf4Zqfc6QWlQO6D0PjmIpbS
1yzoTt53qYIEVEqfuBF32OQA1qEW9KGaKp8e7d8kLeFmXkwKq9X7x6jguSaS8AZ4
LFE5K5Ryg7dma7N7tNTvRwGtAV6DiOoHD1/PlNIGh78TR6p+kMxbU93xTVCyXPUg
C/qLpmJ8r1c1K2ZYSd7wOtvdM2eqbOrMIFzNSHj4JxqTxkjO6+4kN/9KUOh79qgi
R4ExaWS4TiCp5GA4i7P8SlPdIIqDROxMlC5HS+8WTWAVvCJZlAQEkg85wUwpP6Ca
vSsnznnuZkN4ZLKvMyvzTEIw0K2uWubNfpRcgbxOHYKvFrDeBK5wlwvjdrYUBwGc
c98j93oM9DLLJitCk9/OCKQfQvXEKvatxddSG+w1RaawaQJ8JXlDCOi2WYk6D/jr
UmgHPkKkAPhfEBs6duvQ4zqCAVNiTWqo+GK9xTCUw3Ia0K8xJze/cZk19t9DVjgH
8MM9A4pCLzoCLV7k9hpqMIOgJyYiYUuUs1+wvB4aCOL+ah3LXweXrJHpo+ks5h/3
BeEDuZpB2uGMlAi3F/r7jqI+uqeWboYo3PCXV0dVziM149jDaZVRurNNQvSJ3uHE
iK3J/yPJRvCNYXotDnGAHMAQ4wDaF2aI5a7r+iX2k8KFBMWFFSyEqvoQ1d1UgDGD
qYistNV3u/Q+e0Rbpzk/
=UfHD
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-26107-1295008376-0001-2--
