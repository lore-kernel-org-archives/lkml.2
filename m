Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2FTQ5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:57:06 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:38742 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2FTQ5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:57:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, Sam Creasey <sammy@sammy.net>
Cc: Sarah Nadi <snadi@uwaterloo.ca>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/sun3: Remove unselectable code in prom_init()
Date: Wed, 20 Jun 2012 18:56:55 +0200
Message-Id: <1340211415-24489-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was copied from SPARC, but isn't relevant for the supported Sun-3
models.

[Geert] Also remove the related extern declarations, and update the
	comment about prom_init().

Reported-by: Sarah Nadi <snadi@uwaterloo.ca>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/sun3/prom/init.c |   48 +------------------------------------------
 1 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/arch/m68k/sun3/prom/init.c b/arch/m68k/sun3/prom/init.c
index d8e6349..eeba067 100644
--- a/arch/m68k/sun3/prom/init.c
+++ b/arch/m68k/sun3/prom/init.c
@@ -22,57 +22,13 @@ int prom_root_node;
 struct linux_nodeops *prom_nodeops;
 
 /* You must call prom_init() before you attempt to use any of the
- * routines in the prom library.  It returns 0 on success, 1 on
- * failure.  It gets passed the pointer to the PROM vector.
+ * routines in the prom library.
+ * It gets passed the pointer to the PROM vector.
  */
 
-extern void prom_meminit(void);
-extern void prom_ranges_init(void);
-
 void __init prom_init(struct linux_romvec *rp)
 {
 	romvec = rp;
-#ifndef CONFIG_SUN3
-	switch(romvec->pv_romvers) {
-	case 0:
-		prom_vers = PROM_V0;
-		break;
-	case 2:
-		prom_vers = PROM_V2;
-		break;
-	case 3:
-		prom_vers = PROM_V3;
-		break;
-	case 4:
-		prom_vers = PROM_P1275;
-		prom_printf("PROMLIB: Sun IEEE Prom not supported yet\n");
-		prom_halt();
-		break;
-	default:
-		prom_printf("PROMLIB: Bad PROM version %d\n",
-			    romvec->pv_romvers);
-		prom_halt();
-		break;
-	};
-
-	prom_rev = romvec->pv_plugin_revision;
-	prom_prev = romvec->pv_printrev;
-	prom_nodeops = romvec->pv_nodeops;
-
-	prom_root_node = prom_getsibling(0);
-	if((prom_root_node == 0) || (prom_root_node == -1))
-		prom_halt();
-
-	if((((unsigned long) prom_nodeops) == 0) ||
-	   (((unsigned long) prom_nodeops) == -1))
-		prom_halt();
-
-	prom_meminit();
-
-	prom_ranges_init();
-#endif
-//	printk("PROMLIB: Sun Boot Prom Version %d Revision %d\n",
-//	       romvec->pv_romvers, prom_rev);
 
 	/* Initialization successful. */
 	return;
-- 
1.7.0.4

