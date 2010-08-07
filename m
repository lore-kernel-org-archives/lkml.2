Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0HGILe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:11:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26654 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0HGILA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:11:00 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] lib/Kconfig.debug: add list_sort debugging switch
Date: Sat,  7 Aug 2010 11:10:40 +0300
Message-Id: <1281168645-18413-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 07 Aug 2010 08:10:55.0281 (UTC) FILETIME=[0F32B210:01CB3608]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/Kconfig.debug |    9 +++++++++
 lib/list_sort.c   |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..4d5adde 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -684,6 +684,15 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config TEST_LIST_SORT
+	bool "Linked list sorting test"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on 'list_sort()' function test. This test is
+	  executed only once during system boot, so affects only boot time.
+
+	  If unsure, say N.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
diff --git a/lib/list_sort.c b/lib/list_sort.c
index 4b5cb79..9dd8d4a 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -141,7 +141,7 @@ void list_sort(void *priv, struct list_head *head,
 }
 EXPORT_SYMBOL(list_sort);
 
-#ifdef DEBUG_LIST_SORT
+#ifdef CONFIG_TEST_LIST_SORT
 struct debug_el {
 	struct list_head l_h;
 	int value;
@@ -214,4 +214,4 @@ static int __init list_sort_test(void)
 	return 0;
 }
 module_init(list_sort_test);
-#endif
+#endif /* CONFIG_TEST_LIST_SORT */
-- 
1.7.1.1

