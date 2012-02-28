Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2B1ExI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 23:53:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47417 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2B1ExH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 23:53:07 -0500
Date: Tue, 28 Feb 2012 15:52:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120228155232.2609d6442e0b63bb4c70a31a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Feb_2012_15_52_32_+1100_pzb7Zwu0vEfLoDA4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Feb_2012_15_52_32_+1100_pzb7Zwu0vEfLoDA4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/kernel/nmi_selftest.c between commit f0ba662a6e06 ("x86:
Properly _init-annotate NMI selftest code") from the tip tree and commit
"x86: use this_cpu_xxx to replace percpu_xxx funcs" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/nmi_selftest.c
index 2c39dcd,8aca005..0000000
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@@ -12,7 -12,7 +12,8 @@@
  #include <linux/smp.h>
  #include <linux/cpumask.h>
  #include <linux/delay.h>
 +#include <linux/init.h>
+ #include <linux/percpu.h>
 =20
  #include <asm/apic.h>
  #include <asm/nmi.h>

--Signature=_Tue__28_Feb_2012_15_52_32_+1100_pzb7Zwu0vEfLoDA4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTF2QAAoJEECxmPOUX5FEqw4P/10WG5hemqLjuVhEQhOQjiRn
CKrnC2gy4CydtLg0yyP64eckNBsws9A/AuleOD4m/Pl1cHWhgn7tjy7wFoHXDPtb
5pSAiryokdhJRPCmS5NT3H+R9SPZYuE0/s8LwO4XZ3GoEyRy2kcKZHgLmpgc0lr1
2uc35GFImZmgAPZPBTLGS/zEJc2y/XmlLugE2U6cjmUinRAhjtTnDtOHbxNvFFys
+sIx3CkseCN7C19g+TDeL7iLzKtmmlbDIVpr5hKcJsLn2SkyZd/ZAR0fgleb/FVj
3T7xyifvSZMUhSMlOc8Q+6HmI/6rp/mm73VN6a+uVkoLzlEkpp09a6Fz/0wWzbcd
AWmnSdUiASMFZOia3uTcdMsf1TNdT7xd13Yn0z7R4rQU8nVPHRUIW9DggYGVv58n
F+qs4q8SgmklLZjDY7RPP8Jw2Io0/c9lbsUaIPmVw3lL+w2Npw5PgtXxuKG7yO2n
sjSAAhzQScsKpZE8EmuRN4Av7uN1N7KXq9MUQNhE8vmdIKeyRL1hZeF7Uyx5pSpZ
0IqPioNMehCY9pVoYEUReq1xM3o8OyJGJkEwd1cqigsBtgOaLXrIHM8qh8/Dkiz6
QxgKnHA97/I/ExJvKIg8eyEruPU9kb9a06RYDzQFuQuwJ6szmcJENB+TZPazJ9nR
CgoqXZJOOsvQXEKipwOF
=3hIF
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Feb_2012_15_52_32_+1100_pzb7Zwu0vEfLoDA4--
