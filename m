Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2G0Dul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:50:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35401 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2G0Duj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:50:39 -0400
Date: Fri, 27 Jul 2012 13:50:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120727135029.396efc08bc34e376376d251b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Jul_2012_13_50_29_+1000_FqANtVRejT40ibkR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jul_2012_13_50_29_+1000_FqANtVRejT40ibkR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/kernel/cpu/perf_event_intel_uncore.h between commit 254298c726b9
("perf/x86: Add Intel Nehalem-EX uncore support") from the tip tree and
commit "arch/x86/kernel/cpu/perf_event_intel_uncore.h: make
UNCORE_PMU_HRTIMER_INTERVAL 64-bit" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/perf_event_intel_uncore.h
index f385189,d85c25d..0000000
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@@ -5,7 -5,9 +5,7 @@@
  #include "perf_event.h"
 =20
  #define UNCORE_PMU_NAME_LEN		32
- #define UNCORE_PMU_HRTIMER_INTERVAL	(60 * NSEC_PER_SEC)
 -#define UNCORE_BOX_HASH_SIZE		8
 -
+ #define UNCORE_PMU_HRTIMER_INTERVAL	(60LL * NSEC_PER_SEC)
 =20
  #define UNCORE_FIXED_EVENT		0xff
  #define UNCORE_PMC_IDX_MAX_GENERIC	8

--Signature=_Fri__27_Jul_2012_13_50_29_+1000_FqANtVRejT40ibkR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQEhAFAAoJEECxmPOUX5FEOnIQAKQ1MQbAZJBPob418/pupepA
klSo4ADWiE/kFgaOzMhVDnfcq5R5Ajq3WHg34dim1Hp10KYf9VM+7ssZYCmUNeXA
FCTovfvZVokIlJnj/6eukqZg+vlHRjef/UgrreGjMmkqGZP4XtcyGluj9RwRIY/E
vxugJQHXcyKmi+nigOAu8zkHDsCRs7f5yv2NOgBq4WUTlind8MxBUbFQw52T+WOK
yuuUj6Nf1lb1CQiSnIaEh27K3TK1H7zLKsx66+OBmRwb6CJFbPiQPrapSd7jI4Cv
MsXj5vpk8Fe5AqKcGWpq9XZW0Ts+j41P3FPivdchMtBXnvnA5gyqZUtcpq0jevgn
QBdfQ7t6C/sQCrMMnVigEBgkQWTL9WuWstEkl2/KHpfrE6SQAZ3wTUUFhFyNPhk4
CMOGOXfGLBIsGTYlzVYKneJNkVqUsp1KaEhThoWrb5XvJl46GcEYmhuX/F1PMQK3
wqouv92yinglr4xFLSoXZWYRYbGQ958778R380HotxmtDN/v1SZUHQ2116eEiWX3
pnCr9FbcWc0NsJt5a4andmvFs50FdYL4W0TmM5QOBUPV9wesqTu1EK/zDmSzYXvu
mGU4DAxvq3GOMGNZa3KNghVwbsuE4SK/CCq5CjH2IWpSRQfMIN5WrfwFnftEXK7f
eFuSrb8/wockflVWVe4G
=Fy+Q
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jul_2012_13_50_29_+1000_FqANtVRejT40ibkR--
