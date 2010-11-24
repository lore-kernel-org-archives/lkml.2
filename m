Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0KXTyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:54:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48625 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753281Ab0KXTyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:54:24 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/12] sep: netlink - what netlink
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:34:08 +0000
Message-ID: <20101124193406.16425.51371.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Kill unused stuff

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index b2cf553..38b2db4 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -55,10 +55,6 @@
 #include <linux/delay.h>
 #include <linux/rar_register.h>
 
-#include <linux/netlink.h>
-#include <linux/connector.h>
-#include <linux/cn_proc.h>
-
 #include "../memrar/memrar.h"
 
 #include "sep_driver_hw_defs.h"
@@ -943,23 +939,11 @@ static unsigned long sep_set_time(struct sep_device *sep)
  */
 static int sep_init_caller_id(struct sep_device *sep)
 {
-	/* return value */
-	int ret_val;
-
-	/* counter */
 	int counter;
 
-	struct cb_id caller_id;
-
 	dev_dbg(&sep->pdev->dev,
 		"sep_init_caller_id start\n");
 
-	ret_val = 0;
-
-	/* init cb_id struct */
-	caller_id.idx = CN_IDX_PROC;
-	caller_id.val = CN_VAL_PROC;
-
 	/**
 	 * init caller id table
 	 * note that locking is not needed here as this function is
@@ -975,16 +959,10 @@ static int sep_init_caller_id(struct sep_device *sep)
 	dev_dbg(&sep->pdev->dev,
 		"caller id table init finished\n");
 
-	/* register to netlink connector */
-
-	if (ret_val)
-		dev_warn(&sep->pdev->dev,
-			"cn_add_callback failed %x\n", ret_val);
-
 	dev_dbg(&sep->pdev->dev,
 		"sep_init_caller_id end\n");
 
-	return ret_val;
+	return 0;
 }
 
 /**

