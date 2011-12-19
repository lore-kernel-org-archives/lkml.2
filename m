Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1LSWMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:12:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1LSWMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:12:34 -0500
Date: Mon, 19 Dec 2011 17:12:29 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <d817e288df0d43d36fde84353cda07772fe3b960.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 05/16] dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Replace strcpy with strlcpy, and add define for the size constant.

[jbaron@redhat.com: Use DDEBUG_STRING_SIZE for overflow check]
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 8c88b89..6fc8622 100644
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
-	if (strlen(str) >= 1024) {
+	if (strlen(str) >= DDEBUG_STRING_SIZE) {
 		pr_warn("ddebug boot param string too large\n");
 		return 0;
 	}
-	strcpy(ddebug_setup_string, str);
+	strlcpy(ddebug_setup_string, str, DDEBUG_STRING_SIZE);
 	return 1;
 }
 
-- 
1.7.7.3

