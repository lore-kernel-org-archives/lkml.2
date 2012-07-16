Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2GPJlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:41:40 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:53263 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2GPJli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:41:38 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, shangw@linux.vnet.ibm.com,
        haodong@linux.vnet.ibm.com
Subject: [PATCH] Simplify function kobject_init().
Date: Mon, 16 Jul 2012 17:41:28 +0800
Message-Id: <1342431688-4836-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
x-cbid: 12071609-6892-0000-0000-00000271E9CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

The function printk() at end of function kobject_init() already had '\n',
so remove it.

While the kobject has been initialized, assign error string and
jump to error case directly.

Signed-off-by: Dong Hao<haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index c33d7a1..ef3d807 100644
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
-		/* do not error out as sometimes we can recover */
-		printk(KERN_ERR "kobject (%p): tried to init an initialized "
-		       "object, something is seriously wrong.\n", kobj);
-		dump_stack();
+		err_str = "tried to init an initialized "
+			"object, something is seriously wrong.";
+		goto error;
 	}
 
 	kobject_init_internal(kobj);
-- 
1.7.2.5

