Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab2INSGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:06:10 -0400
Received: from mail.digium.com ([216.207.245.2]:50927 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab2INSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:05:34 -0400
From: Shaun Ruffell <sruffell@digium.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: [PATCH v2 3/3] edac: edac_mc no longer deals with kobjects directly.
Date: Fri, 14 Sep 2012 12:58:18 -0500
Message-Id: <1347645498-21215-4-git-send-email-sruffell@digium.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347645498-21215-1-git-send-email-sruffell@digium.com>
References: <1345349484-31552-1-git-send-email-sruffell@digium.com>
 <1347645498-21215-1-git-send-email-sruffell@digium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more embedded kobjects in struct mem_ctl_info. Remove a header and
a comment that does not reflect the code anymore.

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
---
 drivers/edac/edac_mc.c | 7 -------
 include/linux/edac.h   | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d5dc9da..02f0d3e 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -433,13 +433,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 
 	mci->op_state = OP_ALLOC;
 
-	/* at this point, the root kobj is valid, and in order to
-	 * 'free' the object, then the function:
-	 *      edac_mc_unregister_sysfs_main_kobj() must be called
-	 * which will perform kobj unregistration and the actual free
-	 * will occur during the kobject callback operation
-	 */
-
 	return mci;
 
 error:
diff --git a/include/linux/edac.h b/include/linux/edac.h
index bab9f84..aeddb3f 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -14,7 +14,6 @@
 
 #include <linux/atomic.h>
 #include <linux/device.h>
-#include <linux/kobject.h>
 #include <linux/completion.h>
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
-- 
1.7.11.2

