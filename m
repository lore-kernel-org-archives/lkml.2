Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0FCFXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:23:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63919 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0FCFXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:23:23 -0400
Message-Id: <201006030523.o535NA16029042@www262.sakura.ne.jp>
Subject: [PATCH] kobject: Suppress compiler warning with gcc 3.x
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: ebiederm@aristanetworks.com, randy.dunlap@oracle.com, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jun 2010 14:23:10 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 03062010 #3951516, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc 3.x generates a warning

  include/linux/sysfs.h:183: warning: parameter has incomplete type

on each file.
Suppress the warning by moving the definition of "enum kobj_ns_type"
to before "#include <linux/sysfs.h>".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/kobject.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- linux-2.6.35-rc1.orig/include/linux/kobject.h
+++ linux-2.6.35-rc1/include/linux/kobject.h
@@ -16,6 +16,16 @@
 #ifndef _KOBJECT_H_
 #define _KOBJECT_H_
 
+/*
+ * Namespace types which are used to tag kobjects and sysfs entries.
+ * Network namespace will likely be the first.
+ */
+enum kobj_ns_type {
+	KOBJ_NS_TYPE_NONE = 0,
+	KOBJ_NS_TYPE_NET,
+	KOBJ_NS_TYPES
+};
+
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/sysfs.h>
@@ -136,16 +146,6 @@ struct kobj_attribute {
 
 extern const struct sysfs_ops kobj_sysfs_ops;
 
-/*
- * Namespace types which are used to tag kobjects and sysfs entries.
- * Network namespace will likely be the first.
- */
-enum kobj_ns_type {
-	KOBJ_NS_TYPE_NONE = 0,
-	KOBJ_NS_TYPE_NET,
-	KOBJ_NS_TYPES
-};
-
 struct sock;
 
 /*
