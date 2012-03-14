Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2CNHFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:05:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60087 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2CNHFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:05:19 -0400
Date: Wed, 14 Mar 2012 18:05:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20120314180508.e0fd932c329317ab078c140f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_18_05_08_+1100_p5VJVekR+/KKzG_S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_18_05_08_+1100_p5VJVekR+/KKzG_S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

sound/pci/hda/patch_sigmatel.c: In function 'stac92xx_update_led_status':
sound/pci/hda/patch_sigmatel.c:5075:3: error: implicit declaration of funct=
ion 'stac_vrefout_set' [-Werror=3Dimplicit-function-declaration]

Caused by commit 2faa3bf15ba6 ("ALSA: hda - Rewrite the mute-LED hook
with vmaster hook in patch_sigmatel.c").  CONFIG_SND_HDA_POWER_SAVE is
not set for this build.

I reverted that commit for today (and commits d2f344b5e0a9 "ALSA: hda -
Add "Mute-LED Mode" enum control" and f29735cbef4e "ALSA: hda - Add
expose_enum_ctl flag to snd_hda_add_vmaster_hook()" which conflict with
the revert).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Mar_2012_18_05_08_+1100_p5VJVekR+/KKzG_S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYEMkAAoJEECxmPOUX5FEKTAP/AxYHvTgmayMYpSOVGzec51+
UnLHNTxq1Tq/DU+sAfm0BU0HqhTSPyD/5R9GyUEd9tb2j8fINoK2YHwUo6IkgZDI
mpqwlCH7HCSf8CuWQAqXDHgnLuVKRKHnDgdZkwPFR1RFlwgGLVrAdBPMRqRWUYpA
UN+dmIQhFzF7Vhl/OyV8F8tbbCTeTZ4ixnCcl4WD1Ingo/IygEgj+4L/vgxLlJ4N
2TPckqfzCyIzV4YfiCWIgBH460mOBibEHPr4aStMKPWfi7uG4hwPB67gElTRNPNe
ePyEwoGFViWOwxQGtUDDsVj/VY6mYknPoqgpqUDccgfjMU3UxvJzLXPWH+LKg/NA
zb4utYfhC0l3gpCOKWilC5RQrZOADQ9wKKDsw1ySK49p94Y9516toLWi3/LiLCYd
JvXqB2yFUcQYz+4BIWZm1H3AGkCSteYOyuptDiQzgSEKPiniwC0Q+TZlnwl6oUPr
obu3HHUjgGRYART+3c7XC4r9769oCjhArspF77VY32uDvYCFRcK3teMvMuYm8P0f
d+iYlxJ0macEG/QCwAVh1zrDL0PV4Th++uGA+RJlrwFvVRcysj9bOYaz60nRVJah
1ZqCFASJDo28gZHk/U2c3LkXqZEWtl2+LPoU/6GMP5ovhtUoUNzplxqgPD+7kQvB
UFbymlqZ7rE7BJiEhMMU
=Imz+
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_18_05_08_+1100_p5VJVekR+/KKzG_S--
