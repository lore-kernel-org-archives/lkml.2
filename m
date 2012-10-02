Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2JBPCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:02:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:36740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab2JBPBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:01:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="218352970"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/7] procfs: reuse kbasename() functionality
Date: Tue,  2 Oct 2012 18:00:58 +0300
Message-Id: <1349190062-13107-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/proc/proc_devtree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index df7dd08..3d9fd66 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -195,11 +196,7 @@ void proc_device_tree_add_node(struct device_node *np,
 	set_node_proc_entry(np, de);
 	for (child = NULL; (child = of_get_next_child(np, child));) {
 		/* Use everything after the last slash, or the full name */
-		p = strrchr(child->full_name, '/');
-		if (!p)
-			p = child->full_name;
-		else
-			++p;
+		p = kbasename(child->full_name);
 
 		if (duplicate_name(de, p))
 			p = fixup_name(np, de, p);
-- 
1.7.10.4

