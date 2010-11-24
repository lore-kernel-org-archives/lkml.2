Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0KXTyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:54:43 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48630 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932086Ab0KXTyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:54:40 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/12] sep: clean up caller_id function
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:34:25 +0000
Message-ID: <20101124193419.16425.37036.stgit@bob.linux.org.uk>
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

This is called on a kmalloc/memset object. Remove everything that isn't a
set to zero

Oh look 8)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |   42 --------------------------------------
 1 files changed, 0 insertions(+), 42 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 38b2db4..c98cb9b 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -934,38 +934,6 @@ static unsigned long sep_set_time(struct sep_device *sep)
 }
 
 /**
- *	sep_init_caller_id - initializes the caller id functionality
- *	@sep: pointer to struct sep_device
- */
-static int sep_init_caller_id(struct sep_device *sep)
-{
-	int counter;
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_init_caller_id start\n");
-
-	/**
-	 * init caller id table
-	 * note that locking is not needed here as this function is
-	 * called prior to registering the device file
-	 */
-	for (counter = 0; counter < SEP_CALLER_ID_TABLE_NUM_ENTRIES; counter++)
-		sep->caller_id_table[counter].pid = 0;
-
-
-	/* init access flag */
-	sep->singleton_access_flag = 0;
-
-	dev_dbg(&sep->pdev->dev,
-		"caller id table init finished\n");
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_init_caller_id end\n");
-
-	return 0;
-}
-
-/**
  *	sep_set_caller_id_handler - inserts the data into the caller id table
  *      note that this function does fall under the ioctl lock
  *	@sep: sep device
@@ -4056,16 +4024,6 @@ static int __init sep_init(void)
 	mutex_init(&sep->sep_mutex);
 	mutex_init(&sep->ioctl_mutex);
 
-	if (sep->mrst == 0) {
-		ret_val = sep_init_caller_id(sep);
-		if (ret_val) {
-			dev_warn(&sep->pdev->dev,
-				"cant init caller id\n");
-			goto end_function_unregister_pci;
-		}
-
-	}
-
 	/* new chip requires share area reconfigure */
 	if (sep->pdev->revision == 4) { /* only for new chip */
 		ret_val = sep_reconfig_shared_area(sep);

