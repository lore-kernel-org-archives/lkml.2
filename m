Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2B0GVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:21:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39700 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2B0GVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:21:47 -0500
Date: Mon, 27 Feb 2012 17:21:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120227172139.726ddae85c910cee7b7e3a37@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_17_21_39_+1100_mo6.0N.b/4Rw1O9k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_17_21_39_+1100_mo6.0N.b/4Rw1O9k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/compat.h:18:0,
                 from arch/x86/include/asm/ia32.h:7,
                 from arch/x86/include/asm/sigframe.h:17,
                 from arch/x86/kernel/asm-offsets.c:16:
arch/x86/include/asm/compat.h: In function 'arch_compat_alloc_user_space':
arch/x86/include/asm/compat.h:232:3: error: implicit declaration of functio=
n 'percpu_read' [-Werror=3Dimplicit-function-declaration]

Caused by commit d1a797f388d6 ("x32: Handle process creation") from the
tip tree interacting with commit 30999a95d190 ("percpu: remove percpu_xxx()
functions") from the akpm tree.

I applied the following fix up patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Feb 2012 17:12:00 +1100
Subject: [PATCH] percpu: fix for removal of percpu_xxx function

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/compat.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index e7f68b4..b6a2a1c 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -229,7 +229,7 @@ static inline void __user *arch_compat_alloc_user_space=
(long len)
 		sp =3D task_pt_regs(current)->sp;
 	} else {
 		/* -128 for the x32 ABI redzone */
-		sp =3D percpu_read(old_rsp) - 128;
+		sp =3D __this_cpu_read(old_rsp) - 128;
 	}
=20
 	return (void __user *)round_down(sp - len, 16);
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_17_21_39_+1100_mo6.0N.b/4Rw1O9k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSyDzAAoJEECxmPOUX5FEWfgP/0HHCe+ItGQtGKdUmT4VQgVF
pPvmIt9r0IrV7ma8NVSGxi1QjSHP1y+RKtvt7Ja4vSlsecmpQHv5LO+MOWDaYUlm
kYnYLdMBph5D/L/MRHsYrwxeqxVNqP1B8JXEB8Tq4r/hfi0AuUoqHLLayILAEvEs
Zt5Qr9knkbyAQtGr+PzOCvRrD6CsdTrHeYsxVGAcvWwdSX7CLfD/aqT1S1kZFDMG
uVRhaXGxuIG4N1/FOspeVuapww/adWX3SpgVwZ+6G1xmCzZSXjdTmMjd5X4yYX1l
9TvkZhit4fuapVGH7aZBMljTpG1yE6uSJhkJxslGfHu3QnhgQ6BednUe03gcOYGb
h62mODrbsVwgpxM/pfkZSlLK7wma73tV4DMRUfN1ucE9DWVUGjEQVXbV6CIdgW9g
/wP2i4412V/NsESRg/D1gXjX8CTOPxXwN6bv3mtbpZTIXHI3vQL9r5bm6PQ2caAz
FC4pgbSDsc/pXgNFOUDhYhflbLtQtvfSuN8NvnkYtkfu2OI8UTeDHchJ1P36GEzX
2pnpLv8LuPXs/qqWXQ1yCwa6ReWaKkFXwMcSCe/qw7hjI6UNQ5W4Tm0C11bfTusF
/Oivxwu4NuvoKUNpuytE0o9aTpBjn2E6/QMcrbr/2ECNbW42c9u35eKLJIgTfq75
EJ+UTayFxcdiQMceFYNS
=SgpS
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_17_21_39_+1100_mo6.0N.b/4Rw1O9k--
