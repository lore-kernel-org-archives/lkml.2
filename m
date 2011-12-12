Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1LLXSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:18:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab1LLXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:15 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 06/25] dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
Date: Mon, 12 Dec 2011 16:12:32 -0700
Message-Id: <1323731569-20644-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

replace strcpy with strlcpy, and add define for the size constant.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 8c88b89..101e2e5 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -525,14 +525,16 @@ EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
 #endif
 
-static __initdata char ddebug_setup_string[1024];
+#define DDEBUG_STRING_SIZE 1024
+static __initdata char ddebug_setup_string[DDEBUG_STRING_SIZE];
+
 static __init int ddebug_setup_query(char *str)
 {
 	if (strlen(str) >= 1024) {
 		pr_warn("ddebug boot param string too large\n");
 		return 0;
 	}
-	strcpy(ddebug_setup_string, str);
+	strlcpy(ddebug_setup_string, str, DDEBUG_STRING_SIZE);
 	return 1;
 }
 
-- 
1.7.7.3

