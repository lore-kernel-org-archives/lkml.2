Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2F2POr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:14:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47842 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab2F2POp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:45 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 08/11] ubi: fastmap: Remove 'ubi' parameter of 'destroy_ai()'
Date: Fri, 29 Jun 2012 17:14:26 +0200
Message-Id: <1340982869-77042-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>

The 'ubi' argument of 'destroy_ai' was added during fastmap development,
but it is no longer used.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index bc1e4bf..c30a0f6 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1164,10 +1164,9 @@ static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
 
 /**
  * destroy_ai - destroy attaching information.
- * @ubi: UBI device object
  * @ai: attaching information
  */
-static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
+static void destroy_ai(struct ubi_attach_info *ai)
 {
 	struct ubi_ainf_peb *aeb, *aeb_tmp;
 	struct ubi_ainf_volume *av;
@@ -1300,7 +1299,7 @@ out_vidh:
 out_ech:
 	kfree(ech);
 out_ai:
-	destroy_ai(ubi, ai);
+	destroy_ai(ai);
 	return err;
 }
 
@@ -1353,7 +1352,7 @@ out_vidh:
 out_ech:
 	kfree(ech);
 out_ai:
-	destroy_ai(ubi, ai);
+	destroy_ai(ai);
 	return err;
 }
 static struct ubi_attach_info *alloc_ai(void)
@@ -1403,7 +1402,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		err = scan_fast(ubi, ai);
 		if (err > 0) {
 			if (err != UBI_NO_FASTMAP) {
-				destroy_ai(ubi, ai);
+				destroy_ai(ai);
 				ai = alloc_ai();
 				if (!ai)
 					return -ENOMEM;
@@ -1449,13 +1448,13 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		}
 
 		err = self_check_eba(ubi, ai, scan_ai);
-		destroy_ai(ubi, scan_ai);
+		destroy_ai(scan_ai);
 
 		if (err)
 			goto out_wl;
 	}
 
-	destroy_ai(ubi, ai);
+	destroy_ai(ai);
 	return 0;
 
 out_wl:
@@ -1464,7 +1463,7 @@ out_vtbl:
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
 out_ai:
-	destroy_ai(ubi, ai);
+	destroy_ai(ai);
 	return err;
 }
 
-- 
1.7.6.5

