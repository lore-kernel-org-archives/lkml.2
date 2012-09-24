Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2IXJSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:18:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55434 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2IXJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:17:59 -0400
Date: Mon, 24 Sep 2012 19:17:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: linux-next: manual merge of the arm-soc tree with the fbdev tree
Message-Id: <20120924191757.4f7070abf6266308e70566f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_17_57_+1000_sqgt1Ra8F5TGyJLZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_17_57_+1000_sqgt1Ra8F5TGyJLZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-s3c64xx/mach-real6410.c between commit 5a213a55c6d3
("include/video: move fimd register headers from platform to
include/video") from the fbdev tree and commit 436d42c61c3e ("ARM:
samsung: move platform_data definitions") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/mach-real6410.c
index 76d3ffb,6daca20..0000000
--- a/arch/arm/mach-s3c64xx/mach-real6410.c
+++ b/arch/arm/mach-s3c64xx/mach-real6410.c
@@@ -39,12 -39,12 +39,12 @@@
  #include <plat/cpu.h>
  #include <plat/devs.h>
  #include <plat/fb.h>
- #include <plat/nand.h>
+ #include <linux/platform_data/mtd-nand-s3c2410.h>
  #include <plat/regs-serial.h>
- #include <plat/ts.h>
+ #include <linux/platform_data/touchscreen-s3c2410.h>
 -#include <plat/regs-fb-v4.h>
 =20
  #include <video/platform_lcd.h>
 +#include <video/samsung_fimd.h>
 =20
  #include "common.h"
 =20

--Signature=_Mon__24_Sep_2012_19_17_57_+1000_sqgt1Ra8F5TGyJLZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCVFAAoJEECxmPOUX5FEmqkP/2hE5r3jizUqQNbvZPl/4mH7
RcMk1+GP9WhCg08KJeXgSJRU6u5OndEhuPbSH4S/wJ4bO5UZBJ9hVBgQ6jk7rXtb
SDUux5R4PseCrtmDfTyKIjsJy2nLiuldmkPCm4SvGYKsitdFJD4jXcXf0dPQOwQx
dwbabvWl8+6P7WMaEPhBYwBzaQbe+ZysvXq+Ca26a99truFgU+yGxSsEYKAJgH75
OEHqrAq1oB+EnCeKX18u/R5Heed6LXhtZ5u670WRw0MSJVuB88V5WtLqP/Ha/HGy
GkZ1WboBPnVItsMWgrOYATrYuqrI4cU7PvvDM//WKMu27B2YNvYFUoTRQCe3wnFk
tsknvBV3seuIjqTvLvTOPZwaeIgWswaIczf8IIHfuFd4rYzsTicsPPR4zNJXU/F8
bBoilPszMI4SiDNQoL5q397reB7MoLxOPTs1zYttUk52/zO3HClaAbjum4XDOGQm
AoAy3z3NVWdg158slS4mBwPe/ZHzEN/wBud8pbgYmiWGdAodQGl3vNNZc4hzEBQ8
JsysfH9cSP68mk+VHnAcPwXJSwltwyaRBKqTMmPHINWmKEne7DjHe6QT2e5KQcs8
EeTXxej/BLg9lYvRu7YrnDo7Rfu80fPM0b/6EdIl8vNIqeojeSusvqWEPd1tTYNh
D3ce2yme49AYKUje9rm3
=s8y8
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_17_57_+1000_sqgt1Ra8F5TGyJLZ--
