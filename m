Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab1IUVz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:55:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1IUVzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:55:52 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/26] dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
Date: Wed, 21 Sep 2011 15:54:52 -0600
Message-Id: <1316642115-20029-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

replace strcpy with strlcpy, and add define for the size constant.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f2fb0c0..6372b18 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -516,14 +516,16 @@ EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
 #endif
 
-static __initdata char ddebug_setup_string[1024];
+#define BOOT_QUERY_SZ 1024
+static __initdata char ddebug_setup_string[BOOT_QUERY_SZ];
+
 static __init int ddebug_setup_query(char *str)
 {
-	if (strlen(str) >= 1024) {
+	if (strlen(str) >= BOOT_QUERY_SZ) {
 		pr_warn("ddebug boot param string too large\n");
 		return 0;
 	}
-	strcpy(ddebug_setup_string, str);
+	strlcpy(ddebug_setup_string, str, BOOT_QUERY_SZ);
 	return 1;
 }
 
-- 
1.7.4.4

