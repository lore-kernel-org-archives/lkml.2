Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab1CDI6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:58:32 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46046 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1CDI6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:58:31 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Blackfin: outs[lwb]: make sure count is greater than 0
Date: Fri,  4 Mar 2011 03:58:37 -0500
Message-Id: <1299229118-26455-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299229102-26414-1-git-send-email-vapier@gentoo.org>
References: <1299229102-26414-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices will use the outs* funcs with a length of zero, so make sure
we do not write any data in that case.

Reported-by: Gilbert Inho <gneny@edevice.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/lib/outs.S |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/lib/outs.S b/arch/blackfin/lib/outs.S
index 250f4d4..06a5e67 100644
--- a/arch/blackfin/lib/outs.S
+++ b/arch/blackfin/lib/outs.S
@@ -13,6 +13,8 @@
 .align 2
 
 ENTRY(_outsl)
+	CC = R2 == 0;
+	IF CC JUMP 1f;
 	P0 = R0;	/* P0 = port */
 	P1 = R1;	/* P1 = address */
 	P2 = R2;	/* P2 = count */
@@ -20,10 +22,12 @@ ENTRY(_outsl)
 	LSETUP( .Llong_loop_s, .Llong_loop_e) LC0 = P2;
 .Llong_loop_s: R0 = [P1++];
 .Llong_loop_e: [P0] = R0;
-	RTS;
+1:	RTS;
 ENDPROC(_outsl)
 
 ENTRY(_outsw)
+	CC = R2 == 0;
+	IF CC JUMP 1f;
 	P0 = R0;	/* P0 = port */
 	P1 = R1;	/* P1 = address */
 	P2 = R2;	/* P2 = count */
@@ -31,10 +35,12 @@ ENTRY(_outsw)
 	LSETUP( .Lword_loop_s, .Lword_loop_e) LC0 = P2;
 .Lword_loop_s: R0 = W[P1++];
 .Lword_loop_e: W[P0] = R0;
-	RTS;
+1:	RTS;
 ENDPROC(_outsw)
 
 ENTRY(_outsb)
+	CC = R2 == 0;
+	IF CC JUMP 1f;
 	P0 = R0;	/* P0 = port */
 	P1 = R1;	/* P1 = address */
 	P2 = R2;	/* P2 = count */
@@ -42,10 +48,12 @@ ENTRY(_outsb)
 	LSETUP( .Lbyte_loop_s, .Lbyte_loop_e) LC0 = P2;
 .Lbyte_loop_s: R0 = B[P1++];
 .Lbyte_loop_e: B[P0] = R0;
-	RTS;
+1:	RTS;
 ENDPROC(_outsb)
 
 ENTRY(_outsw_8)
+	CC = R2 == 0;
+	IF CC JUMP 1f;
 	P0 = R0;	/* P0 = port */
 	P1 = R1;	/* P1 = address */
 	P2 = R2;	/* P2 = count */
@@ -56,5 +64,5 @@ ENTRY(_outsw_8)
 		R0 = R0 << 8;
 		R0 = R0 + R1;
 .Lword8_loop_e: W[P0] = R0;
-	RTS;
+1:	RTS;
 ENDPROC(_outsw_8)
-- 
1.7.4.1

