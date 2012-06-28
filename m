Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2F1Nw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:52:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37676 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2F1Nwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:52:54 -0400
Date: Thu, 28 Jun 2012 16:52:39 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        <Heinz.Egger@linutronix.de>, thomas.wucher@linutronix.de,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com, linux-mtd@lists.infradead.org
Subject: [PATCH] ubi: fastmap: Remove 'ubi' parameter of 'destroy_ai()'
Message-ID: <20120628165239.52cffc64@pixies.home.jungo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>

The 'ubi' argument of 'destroy_ai' was added during fastmap development,
but it is no longer used.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
Applies to linux-ubi.git fastmap

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 3d9be42..019fbd3 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -97,7 +97,7 @@
  * it that way, or re-structure all the code. :-)
  */
 static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
-static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
+static void destroy_ai(struct ubi_attach_info *ai);
 
 /* Temporary variables used during scanning */
 static struct ubi_ec_hdr *ech;
@@ -1219,7 +1219,7 @@ out_vidh:
 out_ech:
 	kfree(ech);
 out_ai:
-	destroy_ai(ubi, ai);
+	destroy_ai(ai);
 	return err;
 }
 
@@ -1280,7 +1280,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		 */
 		err = ubi_scan_fastmap(ubi, ai);
 		if (err > 0) {
-			destroy_ai(ubi, ai);
+			destroy_ai(ai);
 			ai = alloc_ai();
 			if (!ai)
 				return -ENOMEM;
@@ -1334,10 +1334,10 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		}
 
 		self_check_eba(ubi, ai, scan_ai);
-		destroy_ai(ubi, scan_ai);
+		destroy_ai(scan_ai);
 	}
 
-	destroy_ai(ubi, ai);
+	destroy_ai(ai);
 	return 0;
 
 out_wl:
@@ -1346,7 +1346,7 @@ out_vtbl:
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
 out_ai:
-	destroy_ai(ubi, ai);
+	destroy_ai(ai);
 	return err;
 }
 
@@ -1385,10 +1385,9 @@ static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
 
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
