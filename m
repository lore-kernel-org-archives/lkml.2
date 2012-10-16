Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2JPLsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:48:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:28304 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab2JPLs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="205024301"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 5/6] procfs: reuse kbasename() functionality
Date: Tue, 16 Oct 2012 14:48:13 +0300
Message-Id: <1350388094-18805-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
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

