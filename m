Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2GEH6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:58:33 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:37381 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2GEH6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:58:32 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH] lib/kobject: simplify function kobject_init
Date: Thu,  5 Jul 2012 15:58:22 +0800
Message-Id: <1341475102-10433-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
x-cbid: 12070507-0542-0000-0000-0000025DB27D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hao Dong <haodong@linux.vnet.ibm.com> 

The printk() at end of function kobject_init() already had "\n",
so remove "\n".

While the kobject has been initialized, assign error string and
jump to error case directly.

Signed-off-by: Dong Hao<haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index c6e201a..cab2fc9 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -276,14 +276,13 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 		goto error;
 	}
 	if (!ktype) {
-		err_str = "must have a ktype to be initialized properly!\n";
+		err_str = "must have a ktype to be initialized properly!";
 		goto error;
 	}
 	if (kobj->state_initialized) {
 		/* do not error out as sometimes we can recover */
-		printk(KERN_ERR "kobject (%p): tried to init an initialized "
-		       "object, something is seriously wrong.\n", kobj);
-		dump_stack();
+		err_str = "tried to init an initialized object, something is seriously wrong.";
+		goto error;
 	}
 
 	kobject_init_internal(kobj);
-- 
1.7.9.5

