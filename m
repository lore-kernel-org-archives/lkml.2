Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab2IUGIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:08:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46523 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab2IUGIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:08:49 -0400
Date: Fri, 21 Sep 2012 16:08:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120921160838.8982586c26d1153a6763d7be@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Sep_2012_16_08_38_+1000_cDriZDAK6uk6frli"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Sep_2012_16_08_38_+1000_cDriZDAK6uk6frli
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/binfmt_elf.c: In function 'fill_files_note':
fs/binfmt_elf.c:1419:2: error: implicit declaration of function 'vmalloc' [=
-Werror=3Dimplicit-function-declaration]
fs/binfmt_elf.c:1419:7: warning: assignment makes pointer from integer with=
out a cast [enabled by default]
fs/binfmt_elf.c:1437:5: error: implicit declaration of function 'vfree' [-W=
error=3Dimplicit-function-declaration]

Caused by commit "coredump: extend core dump note section to contain file
names of mapped files".  Forgot to include vmalloc.h :-(

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 21 Sep 2012 16:06:18 +1000
Subject: [PATCH] coredump: using vmalloc requires the inclusion of vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/binfmt_elf.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0973943..5ac905f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -32,6 +32,7 @@
 #include <linux/elf.h>
 #include <linux/utsname.h>
 #include <linux/coredump.h>
+#include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Sep_2012_16_08_38_+1000_cDriZDAK6uk6frli
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQXARmAAoJEECxmPOUX5FE4joP/0hA9PavuhMQNc425MZ64IPD
oab9C5YP7RZlM0APbJSwlcPZnKwLWd+r1ORTlyXYO7ydYz78TkMgsq431RyqHZUN
2l5tcrOJpQH7Vl/OiUd4oiLBVqXANgcyNc/BtGJjEVr0WweCo1u524Ya8UEJ58mr
gMVZ7zEZ/Yjws0p0s81NUXqEFKGxU2U6lvkMwZJ2PnD7nsLvvNmXF8Mr8brfmnXd
jpD9kHPu/izzVoybmAQHGqE37YxZsQMHJLtzUz2tm3g4aUGMoEVaPTqAuQ/lKStB
s9UWZZDjypGBZo55nzZBpSBpKEfx0L0D5v1tXLrrcye02E52Y7s0VHgAo/73gtDi
E67nxDYSQJVH/O4JEiBnkdkJXCcFkOngLYiYAKe5yklFFsK9FdVbe3S9UF4stR7p
qfHbGkisFBYxb9TFHxy6cqPSSnh0b6z1PEpYE7I9xyyCcl289y1XCkwboDaiKBVF
xT0qK31pTdFeqTAR3hIiBm4+ePrcptpFO7yTtMLW5qRtNOEkIEmspd65W9gghV73
QqwXDU7VuJ5csVDed1K9lOUcjxdVsqGwPoVTnUwXmmLuRUrfqKiOBS6eem+ofXAv
4r/0Y/2mLcNEU54VoH5dFAXZQNf7fhQzfWgxUCnAJqdoNfRQlC0Ho6TnrXzpwLqI
ETVdQYfRjVXLb4e/lHoT
=VHdq
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Sep_2012_16_08_38_+1000_cDriZDAK6uk6frli--
