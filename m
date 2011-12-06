Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1LFTR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:17:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1LFTMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:21 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 06/25] dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
Date: Tue,  6 Dec 2011 12:11:16 -0700
Message-Id: <1323198694-7186-7-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
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

