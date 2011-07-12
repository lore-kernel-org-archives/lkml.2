Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1GLHsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:48:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1GLHr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:47:58 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Scott Wood <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2] powerpc/85xx: fix mpic configuration in CAMP mode
Date: Tue, 12 Jul 2011 09:49:43 +0200
Message-Id: <1310456983-1473-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <20110711143859.0e6c95d8@schlenkerla.am.freescale.net>
References: <20110711143859.0e6c95d8@schlenkerla.am.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the string to check for CAMP mode boot on MPC85xx (eg. P2020) to match
the one in the corresponding dts files (p2020rdb_camp_core{0,1}.dts).

Without this fix the mpic is configured as in the SMP boot mode, which causes
the first core to report a protected source interrupt error for devices
of the other core and lock up.

Also add MPIC_SINGLE_DEST_CPU on both P2020 based architectures in CAMP
mode as suggested by Scott Wood. Thanks.

Cc: Scott Wood <scottwood@freescale.com>
Cc: Poonam Aggrwal <poonam.aggrwal@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 arch/powerpc/platforms/85xx/mpc85xx_ds.c  |    3 ++-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index c7b97f7..1b9a8cf 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -83,7 +83,8 @@ void __init mpc85xx_ds_pic_init(void)
 	if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
 		mpic = mpic_alloc(np, r.start,
 			MPIC_PRIMARY |
-			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
+			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(np, r.start,
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index 088f30b..f5ff911 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -58,10 +58,11 @@ void __init mpc85xx_rdb_pic_init(void)
 		return;
 	}
 
-	if (of_flat_dt_is_compatible(root, "fsl,85XXRDB-CAMP")) {
+	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
 		mpic = mpic_alloc(np, r.start,
 			MPIC_PRIMARY |
-			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
+			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(np, r.start,
-- 
1.7.5.1

