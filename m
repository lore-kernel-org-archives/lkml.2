Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199Ab2HHJyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:54:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:3532 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2HHJyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:54:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,732,1336374000"; 
   d="scan'208";a="178261609"
From: Jenny TC <jenny.tc@intel.com>
To: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Cc: jenny.tc@intel.com
Subject: [PATCH v2] kernel_notifier: register conditional raw notifier
Date: Wed,  8 Aug 2012 20:56:23 +0530
Message-Id: <1344439583-8243-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new API raw_notifier_chain_cond_register to
add a notifier to a raw notifier chain, only if notifier
not already present in the chain.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
v1
* Added API definition
v2	
* Added API decalarion
 include/linux/notifier.h |    2 ++
 kernel/notifier.c        |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index d65746e..67895f0 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -124,6 +124,8 @@ extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
 extern int blocking_notifier_chain_cond_register(
 		struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
+extern int raw_notifier_chain_cond_register(struct raw_notifier_head *nh,
+		struct notifier_block *nb);
 
 extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 		struct notifier_block *nb);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2d5cc4c..267e26f 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -349,6 +349,24 @@ int raw_notifier_chain_register(struct raw_notifier_head *nh,
 EXPORT_SYMBOL_GPL(raw_notifier_chain_register);
 
 /**
+ *	raw_notifier_chain_cond_register - Cond add notifier to a raw notifier chain
+ *	@nh: Pointer to head of the raw notifier chain
+ *	@n: New entry in notifier chain
+ *
+ *	Adds a notifier to a raw notifier chain, only if not already
+ *	present in the chain.
+ *	All locking must be provided by the caller.
+ *
+ *	Currently always returns zero.
+ */
+int raw_notifier_chain_cond_register(struct raw_notifier_head *nh,
+		struct notifier_block *n)
+{
+	return notifier_chain_cond_register(&nh->head, n);
+}
+EXPORT_SYMBOL_GPL(raw_notifier_chain_cond_register);
+
+/**
  *	raw_notifier_chain_unregister - Remove notifier from a raw notifier chain
  *	@nh: Pointer to head of the raw notifier chain
  *	@n: Entry to remove from notifier chain
-- 
1.7.9.5

