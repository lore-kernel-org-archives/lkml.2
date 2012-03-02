Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2CBCtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 21:49:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58542 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab2CBCtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 21:49:19 -0500
Date: Fri, 2 Mar 2012 13:49:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@snapgear.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the tip tree with the m68knommu tree
Message-Id: <20120302134903.7992cf17cb0c50b9a2b3842c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Mar_2012_13_49_03_+1100_8cA_RSmfIifkY1pm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Mar_2012_13_49_03_+1100_8cA_RSmfIifkY1pm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in
arch/m68k/kernel/process_no.c and arch/m68k/kernel/process_mm.c between
commit 8d8b74c955fd ("m68k: merge the MMU and non-MMU versions of
process.c") from the m68knommu tree and commit bd2f55361f18 ("sched/rt:
Use schedule_preempt_disabled()") from the tip tree.

The former merged these two files into a single process.c, so I removed
them.  I then applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 2 Mar 2012 13:43:03 +1100
Subject: [PATCH] sched/rt: Use schedule_preempt_disabled() in m68k

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/m68k/kernel/process.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index f053e24..c54ef927 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -78,9 +78,7 @@ void cpu_idle(void)
 	while (1) {
 		while (!need_resched())
 			idle();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
=20
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Mar_2012_13_49_03_+1100_8cA_RSmfIifkY1pm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPUDUfAAoJEECxmPOUX5FEZqAP/RsgsBD7iZ/ulk44vUu9GqyK
6gNWFCAl3sfNX9u0ow30jE2RXRHVdrhI9dwse5JO36FPVPajGfRyLWJU8ptq5TNl
yP1XLCTjfXt6HOLE05jzPxqQfdS8MutQJ/mGnKvKMjXhcze9NjOE528UqDynDh56
O+3Xsk90JPuMKvtidsmu4RGm1AxvPMwTJXayAs/KEoY5yUZnqmG97cQFzkgBx9s/
G0RnmOdfnA3rV1ltUgTItj8NwrLiA5JJ6yzxOjh8hrbwNKOxQHy6mfaMOHqs0w24
r4SOpmqWcpuJuAZsUz8wJ0UJo7PoQ5bR4o6VJalk7TB4c0uSYaw28mK8dqy57Atn
KCZPB7DRLxJEQkqZbUwRaKai5FMlcqhkGSL+2YSyfJ1uRNMZCcTT2bvN6D7V1XnS
uq+DmAKUaTCDhJca8Ni5Xw8uM0S+vnafDvS/jSNtXiy1q1BHIGOSlaP7aJO+743d
nwcBjtDhYOV+8oVWVtq0g2RQHNvxADy472ZNmN6PnOwkH4eUaTfMR/tFGIb/wmJ2
1VbXysgkJDBW1C0+eJ0xT7Qnj3+2c6IiQ/XgaZEllWgmdgXO4jzkrcg41KeKPNTz
BizwiUm0mRC1Y24KWm/oRrQpIL2qD33j8VEFM8tybqxeu5bMKLT8ODqc4Q/zCKr8
DXSvv7EOfWNIz0sJpCCK
=DQHg
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Mar_2012_13_49_03_+1100_8cA_RSmfIifkY1pm--
