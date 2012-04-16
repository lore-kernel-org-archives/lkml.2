Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab2DPFwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:52:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56718 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2DPFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:52:46 -0400
Date: Mon, 16 Apr 2012 15:52:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Subject: linux-next: build failure after merge of the final tree (regulator
 tree related)
Message-Id: <20120416155237.ad4c5d89bb869226faac4a60@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Apr_2012_15_52_37_+1000_vNhwyEiEDjwUrEd="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Apr_2012_15_52_37_+1000_vNhwyEiEDjwUrEd=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/regulator/da9052-regulator.c: In function 'da9052_regulator_probe':
drivers/regulator/da9052-regulator.c:442:3: error: implicit declaration of =
function 'of_find_node_by_name' [-Werror=3Dimplicit-function-declaration]
drivers/regulator/da9052-regulator.c:442:10: warning: assignment makes poin=
ter from integer without a cast [enabled by default]
drivers/regulator/da9052-regulator.c:446:3: error: implicit declaration of =
function 'of_get_next_child' [-Werror=3Dimplicit-function-declaration]
drivers/regulator/da9052-regulator.c:446:11: warning: assignment makes poin=
ter from integer without a cast [enabled by default]
drivers/regulator/da9052-regulator.c:447:11: warning: assignment makes poin=
ter from integer without a cast [enabled by default]
drivers/regulator/da9052-regulator.c:448:4: error: implicit declaration of =
function 'of_node_cmp' [-Werror=3Dimplicit-function-declaration]
drivers/regulator/da9052-regulator.c:448:23: error: dereferencing pointer t=
o incomplete type
cc1: some warnings being treated as errors

Caused by commit 88c84c14cca4 ("regulator: da9052: add device tree support"=
).

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Apr_2012_15_52_37_+1000_vNhwyEiEDjwUrEd=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPi7OlAAoJEECxmPOUX5FEn4MP/R/bflS+hlPLeOtN6kqZ5/qB
Do0JT2mxY4jxKhF+6KCFrIJPX+Lr1K/V8w/Cz9NUO2Cnog2/ie66U8XfKc3UFnGj
EjEjKDD0/FccRuJ+72fwbEWP1jzElB4/Cks/Jz3+X/Rqs1Tpfi8e2LfKdmHWUO9C
f1hJx44a1TqRJCVLSDoaDOJBl5/J2/9myR5bUkWcMy+hLSJQcKMsdra7OLQmAlU5
R36PxxY84sn7KanIg69VyKCPd+r7bxFOwZjxQmzbJHblaea+IszogBf4vZd7mGfO
X/ULv/RMFlAmZCvVG2WGTYvBybgN0tEC9+GffCkpkEolTOPas1KZJaI34omvoZ4O
HHzl8npvjA6r1eKvz6XaCDpkq5N/veGh/OqKIgX1BiFf2T62XpyRSFTD1JIahdol
Pw3gEjZTLUnm5cVgU1Wl7cjUePgOFthrzeCavBhr3y8LJDYROSa5Tmc3l7Y/8rb3
uXKsvkPcyfgW+HF7oKtzo+KjLFdOEfiSKIvf8lTlhrUYWpugCU/R5/d5UNgm3cJ1
1uNpja4AqhEGFuMD4514iTk5Uvxv5FYeTb2mefkzt0a5k8l7g8USLTm7vnsQJCmX
a5zEG/DJ7SHJM2DDbQlyKxgYT5gcJbVglCe0r/yfzQwi/0YUkd2rK2ev06Q3kkb3
bT7P9taldYdn1cGPk7LL
=Cn2d
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Apr_2012_15_52_37_+1000_vNhwyEiEDjwUrEd=--
