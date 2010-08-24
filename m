Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0HXQCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:02:36 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932082Ab0HXQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:26 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154855.752613648@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:22 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 01/10] lib/list_sort: selftest: enabled with CONFIG_TEST_LIST_SORT
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest-enabled-with-CONFIG_TEST_LIST_SORT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Enable the self-test, without editing of the code.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Don Mullis <don.mullis@gmail.com>
---
 lib/Kconfig.debug |    9 +++++++++
 lib/list_sort.c   |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-next/lib/Kconfig.debug
===================================================================
--- linux-next.orig/lib/Kconfig.debug	2010-08-23 22:51:13.888053055 -0700
+++ linux-next/lib/Kconfig.debug	2010-08-23 22:51:19.674177607 -0700
@@ -714,6 +714,15 @@ config DEBUG_LIST
 
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
Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:13.888053055 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:56.494053043 -0700
@@ -141,7 +141,7 @@ void list_sort(void *priv, struct list_h
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

