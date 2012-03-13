Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2CMFmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:42:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54027 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2CMFl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:41:58 -0400
Date: Tue, 13 Mar 2012 16:41:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the uprobes tree with the tip tree
Message-Id: <20120313164150.6e64d11ee0c3e7aad49c0fbb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_16_41_50_+1100_yL8HT5a5jFy1M7n8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_16_41_50_+1100_yL8HT5a5jFy1M7n8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

Today's linux-next merge of the uprobes tree got a conflict in
arch/x86/kernel/cpu/perf_event_intel_ds.c between commit 3e702ff6d1ea
("perf/x86: Add LBR software filter support for Intel CPUs") from the tip
tree and commit 1e1e2cddc33d ("x86/trivial: use is_ia32_compat_task")
from the uprobes tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/perf_event_intel_ds.c
index 7f64df1,92e7dee4..0000000
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@@ -3,7 -3,7 +3,8 @@@
  #include <linux/slab.h>
 =20
  #include <asm/perf_event.h>
 +#include <asm/insn.h>
+ #include <asm/compat.h>
 =20
  #include "perf_event.h"
 =20

--Signature=_Tue__13_Mar_2012_16_41_50_+1100_yL8HT5a5jFy1M7n8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXt4eAAoJEECxmPOUX5FEkQ4P/2BgYiv0lxczJLsBKIiTs2mp
XjBeAVURWhye5DZ24CCS6KABk8Gm96y2Dd9gE6kcJ3P9B9JNy0mcGYGv78SiiwEs
nmiVfu6lf+EgRx/37CphH/fUMPx1q/w6pcF2wlHy3u9IzMrIQZINJNcFbb8e0/To
Ku3h0UXkKnZvQqAkijnYagkmL6WnXRxGfmb555lQ8fyrooxUIDL7gE9PnN/S3S1n
NGUbDQKiXmWkKQByvNtnUJIqFvz4WJIv6pfg9qg9r1a+/KgsNJqtlgBLWXV1WQUw
juxFb26V3Vq0ViQyH4N4BKNyYKEoEUQM1d1IU7rAou8t1uG61ofwtO0uDqHsvIVq
BB2vorpSgfXWMNCf7NPtgtlaeg7YvCBU0DGNMjxq2pYeOkQG9C1GL7mSlskp1MTn
Ou7E7IbEWVFWPlEOVmPhpcMAop89UGXOw6O5UX01dmaGE8+qziEbDcWAPBMwkBPF
t5M2Gxn1p3CuReUZ+sEyrbcktNbA7LOHG/54XDcBp8IvyjWESnfsDc2rdOqL2pBK
ay/LULxFwsR94NEwcpBmrVuXgaIrqpHN8lAZEBDXvOOufg0Nq/fVAHD5nY/iy+7A
fILVH/0hoX7b6GNVfpUl8IyXItO0Cw5zT4efc721Zp+96nPI+mVW76+0cYAr8sYJ
EnB1b1PcD6C3Ak/Wgr2N
=FwJL
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_16_41_50_+1100_yL8HT5a5jFy1M7n8--
