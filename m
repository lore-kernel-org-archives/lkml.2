Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2ATCCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:02:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42888 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2ATCCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:02:23 -0500
Date: Fri, 20 Jan 2012 13:02:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@intel.com>, Christoph Lameter <cl@gentwo.org>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20120120130202.acc1f68cd3162293aebdfa96@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jan_2012_13_02_02_+1100_csOa.yDSX_P_/G.1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jan_2012_13_02_02_+1100_csOa.yDSX_P_/G.1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

In file included from arch/x86/include/asm/elf.h:90:0,
                 from include/linux/elf.h:7,
                 from arch/x86/kernel/cpu/amd.c:4:
arch/x86/include/asm/desc.h: In function 'native_set_ldt':
arch/x86/include/asm/desc.h:199:3: error: implicit declaration of function =
'this_cpu_read' [-Werror=3Dimplicit-function-declaration]

Caused by commit a65a3870c856 ("x86: use this_cpu_xxx to replace percpu_xxx=
 funcs").

I tried changing the include of asm/percpu.h to linux/percpu.h in
arch/x86/include/asm/smp.h (the above is caused by smp_processor_id()
using this_cpu_read()), but that made things worse.  So I added an
include of linux/percpu.h to arch/x86/include/asm/desc.h (but this seems
a bit fragile).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 Jan 2012 12:51:40 +1100
Subject: [PATCH] percpu: x86: fix smp_processor_id's need for this_cpu_read

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/desc.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index e95822d..3072a2d 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -6,6 +6,7 @@
 #include <asm/mmu.h>
=20
 #include <linux/smp.h>
+#include <linux/percpu.h>
=20
 static inline void fill_ldt(struct desc_struct *desc, const struct user_de=
sc *info)
 {
--=20
1.7.9.rc0.23.g7e521

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jan_2012_13_02_02_+1100_csOa.yDSX_P_/G.1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPGMsaAAoJEECxmPOUX5FEo0YP/jHDO8KiIHlXIDpAznA4SUC7
8Pmdn7NI4y133gjW4qrrqKNnGzVoUpuo5qLSPp5bM3wYgmwPJ/yoizSSOqt4A5+F
scBsNCiLKEE6KLOZQHDjHRQkk+vA3sQ+i73qCacMyIg9Mv/N5yvgVo4IUUW9AbH/
QNnCP5CzEx1aJXVClruMaD42l0o4P/x26af68wJv0g0fTxJ1dPsEE+cjipMHudUb
kJM1ZYLNsl3c4WJtPOdW/WBDGyKTViUSHRvVv+971IolBSu1TfuVWvL9hDuuKjKD
z5C8M8W39MoGFEr/aUrOBkQ4im/JAOyo5KtPVM5Mll/ZgVU6YXE9FXEa/u1zT3r6
125F/mRTri5e+IDSZKtzsxVEk0EvZSfEm9YOw/YFxDAfpRlHD9bobItnIE0+pCEu
lRcQsMWf5osrEfYHs7vQ8fx85hvRsQ4D8bPyU/X3tWsfw+w6L0L4LXWv0zlL82kz
hP9LKYe92PL4OzpLGJwKeDBtuBu64ksuIbs99EcIWCk0NqRhTzxKW6extZIPyHu1
yJNp/bgDZyPl8opg00lVsyirL9sImd6y9scqJ33nY0S8G0hvEICirB3xbQ9WQKXo
NYUPsqb8Uq4L1aDpkiqBIV67BEUKAZTwbBfA87EkSBkc+GDYIiVOqTURY1B6WzdV
BCCkIEAdYBqNOogjHgMf
=Tp1r
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jan_2012_13_02_02_+1100_csOa.yDSX_P_/G.1--
