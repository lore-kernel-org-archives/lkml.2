Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2DBAqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 20:46:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54661 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2DBAqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 20:46:18 -0400
Date: Mon, 2 Apr 2012 10:46:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the tile tree with Linus' tree
Message-Id: <20120402104611.85a4f144ccaa4a2511cf2d4b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Apr_2012_10_46_11_+1000_pn=c8AI821G9ZoAl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Apr_2012_10_46_11_+1000_pn=c8AI821G9ZoAl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the tile tree got a conflict in
arch/tile/include/asm/barrier.h (actually setup.h - git tried its best)
between commit bd119c692393 ("Disintegrate asm/system.h for Tile") from
Linus' tree and commit 8507ce994794 ("arch/tile: fix hardwall for tilegx
and generalize for idn and ipi") from the tile tree.

I used the upstream version of barrier.h and applied the following merge
fixup.

It may be worth while rebasing the tile tree on top of v3.4-rc1 or
(maybe better) merging 3.4-rc1 into the tile tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 Apr 2012 10:41:41 +1000
Subject: [PATCH] tile: apply changes after system/h break up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/tile/include/asm/setup.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/tile/include/asm/setup.h b/arch/tile/include/asm/setup.h
index e58613e..c67eb70 100644
--- a/arch/tile/include/asm/setup.h
+++ b/arch/tile/include/asm/setup.h
@@ -41,15 +41,15 @@ void restrict_dma_mpls(void);
 #ifdef CONFIG_HARDWALL
 /* User-level network management functions */
 void reset_network_state(void);
-void grant_network_mpls(void);
-void restrict_network_mpls(void);
 struct task_struct;
-int hardwall_deactivate(struct task_struct *task);
+void hardwall_switch_tasks(struct task_struct *prev, struct task_struct *n=
ext);
+void hardwall_deactivate_all(struct task_struct *task);
+int hardwall_ipi_valid(int cpu);
=20
 /* Hook hardwall code into changes in affinity. */
 #define arch_set_cpus_allowed(p, new_mask) do { \
-	if (p->thread.hardwall && !cpumask_equal(&p->cpus_allowed, new_mask)) \
-		hardwall_deactivate(p); \
+	if (!cpumask_equal(&p->cpus_allowed, new_mask)) \
+		hardwall_deactivate_all(p); \
 } while (0)
 #endif
=20
--=20
1.7.10.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Apr_2012_10_46_11_+1000_pn=c8AI821G9ZoAl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPePbTAAoJEECxmPOUX5FEMN4P/jbVta1VhrmBFYevvenUNVPg
uYcDMIzsO8UP5Y7JRGqHw0ugdvKgKXmukCasRmaX2Hh+//RJmGU8w5euGDHImxys
PAYqGoamcRug8DOeqrdvP/VxM8iI97KcvJPE0ilxJXm+ybwljQZ+iLvSo5Qhh095
3WUkrKlTZ9rm7m62KiggVbI8r2IEztVsg2ZPXMrceCx33P0PeMn3zOQQuOyL/3at
Ga1Mf8oLZxv4A6Ppt05pTNeGM90s/A5teOWkw3gA6N6tQGKQ4uCeQOIpj4XfIHUU
X7jnFe/axxJ8XKh4FSHCVyI9COI6eiYYhJlueUAQ1YYWDNbV2nDcy66Q6S3Z0sW0
ss9uVTG1Ek54hK41PNFbQ7m3EnfLnuXPCBAesnQe4r1sHZsaFEPC+HIX80H3ZNJ5
lHi4PPE500OqQTvdukVNsCbowRO4Q6Fsi8Q8CxgIwIR/gwFWf+VbzXEium5Qc6WF
Qeed/mcN5ggSS6jgesJcgGB+I9/jtxI3j6ofr+OS3ySmO0JsZlFZ/k43an0UcGAQ
MPfWP/p8iGj5Ura1Y+tw8GHGuuzQAKuKZd8v5u6yDMiMsZ13F6immZemFx+qmPET
vRiW0bXQUaeSOnUUnUxZNLksogeSZ29xwgXGhaZ8bBemf70ICFB8YMB599+wYzSL
sZBDQoAbTuYQ/2oZO6TO
=yvJJ
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Apr_2012_10_46_11_+1000_pn=c8AI821G9ZoAl--
