Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1GYVn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39747 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1GYVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:21 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 04/25] dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
Date: Mon, 25 Jul 2011 15:42:29 -0600
Message-Id: <1311630170-26057-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace strcpy with strlcpy, and add define for the size constant.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a7161db..887940d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -506,14 +506,15 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 }
 EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
-static __initdata char ddebug_setup_string[1024];
+#define BOOT_QUERY_SZ 1024
+static __initdata char ddebug_setup_string[BOOT_QUERY_SZ];
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
1.7.4.1

