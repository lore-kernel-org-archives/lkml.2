Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1ISIq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:46:29 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46295 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1ISIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:46:27 -0400
Date: Mon, 19 Sep 2011 18:46:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tobias Klauser <tklauser@distanz.ch>
Subject: linux-next: build failure after merge of the final tree (input tree
 related)
Message-Id: <20110919184621.ac27f3d519e397a82efc6d4a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Sep_2011_18_46_21_+1000_reM3ssjy13IlOo1j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Sep_2011_18_46_21_+1000_reM3ssjy13IlOo1j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/input/keyboard/gpio_keys.c: In function 'gpio_keys_get_devtree_pdat=
a':
drivers/input/keyboard/gpio_keys.c:500:3: warning: passing argument 3 of 'o=
f_property_read_u32' from incompatible pointer type
include/linux/of.h:268:19: note: expected 'u32 *' but argument is of type '=
const u32 **'
drivers/input/keyboard/gpio_keys.c:504:19: warning: assignment makes intege=
r from pointer without a cast
drivers/input/keyboard/gpio_keys.c:508:3: warning: passing argument 3 of 'o=
f_property_read_u32' from incompatible pointer type
include/linux/of.h:268:19: note: expected 'u32 *' but argument is of type '=
const u32 **'
drivers/input/keyboard/gpio_keys.c:509:20: warning: assignment makes intege=
r from pointer without a cast
drivers/input/keyboard/gpio_keys.c:515:3: warning: passing argument 3 of 'o=
f_property_read_u32' from incompatible pointer type
include/linux/of.h:268:19: note: expected 'u32 *' but argument is of type '=
const u32 **'
drivers/input/keyboard/gpio_keys.c:516:33: warning: assignment makes intege=
r from pointer without a cast
drivers/input/keyboard/gpio_keys.c:502:4: error: label 'out_fail' used but =
not defined
drivers/input/keyboard/gpio_keys.c: At top level:
drivers/input/keyboard/gpio_keys.c:523:7: error: expected '=3D', ',', ';', =
'asm' or '__attribute__' before '->' token
drivers/input/keyboard/gpio_keys.c:525:2: error: expected identifier or '('=
 before 'return'
drivers/input/keyboard/gpio_keys.c:527:9: error: expected '=3D', ',', ';', =
'asm' or '__attribute__' before ':' token
drivers/input/keyboard/gpio_keys.c:529:2: error: expected identifier or '('=
 before 'return'
drivers/input/keyboard/gpio_keys.c:530:1: error: expected identifier or '('=
 before '}' token
drivers/input/keyboard/gpio_keys.c: In function 'gpio_keys_get_devtree_pdat=
a':
drivers/input/keyboard/gpio_keys.c:521:2: warning: control reaches end of n=
on-void function

Caused by commit d6ba97c9806b ("Input: gpio_keys - use
of_property_read_u32()").  Mostly by a brace mismatch.


I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Sep_2011_18_46_21_+1000_reM3ssjy13IlOo1j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOdwFdAAoJEDMEi1NhKgbs5OkH/2mz7MZ9Qc5YDhi7t8Nv75+C
dCYB7euymgI8yN7izVd1JZvnzWvBEzDbGqtiOCMaVYWp/2suU7xZ+9C7woZgVo+a
9hPjgorMhWefrypE+wq4yzSkHGt1596UHDgSolmZ+SlHmjI4hoe8y7CCQhY+4H73
y7sFvh8bZJtIslx4gZiu/Yxo99wukt/mRE03s7HJpRQuPAnnV/n+BwEL/NfNhJAJ
6/P0WLia/5MmkJnw2DZUAkvYz//sLJLqjMW6MRDazQyyB/935yFzlVbh3KxR3CoY
daPlXHEbqwj2gAXxfOMcsjT501mSK7m6NQaipwHxuAHAAKc4WupzEVD50T5QR9Q=
=Uf68
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Sep_2011_18_46_21_+1000_reM3ssjy13IlOo1j--
