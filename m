Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2LRGbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:31:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41607 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750854Ab2LRGbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:31:33 -0500
From: Joe Perches <joe@perches.com>
To: Youquan Song <youquan.song@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: glue: Update DBG macro to include KERN_DEBUG
Date: Mon, 17 Dec 2012 22:31:30 -0800
Message-Id: <95d86788536a6f095f261c051249ebd4f0e30a87.1355812070.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <1355851562-28407-1-git-send-email-youquan.song@intel.com>
References: <1355851562-28407-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently these DBG statements are emitted at KERN_DEFAULT.
Change the macro to emit at KERN_DEBUG.

This can help avoid unexpected message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---

Another way to fix this message interleaving...

 drivers/acpi/glue.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 0155184..95af6f6 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -18,9 +18,14 @@
 
 #define ACPI_GLUE_DEBUG	0
 #if ACPI_GLUE_DEBUG
-#define DBG(x...) printk(PREFIX x)
+#define DBG(fmt, ...)						\
+	printk(KERN_DEBUG PREFIX fmt, ##__VA_ARGS__)
 #else
-#define DBG(x...) do { } while(0)
+#define DBG(fmt, ...)						\
+do {								\
+	if (0)							\
+		printk(KERN_DEBUG PREFIX fmt, ##__VA_ARGS__);	\
+} while (0)
 #endif
 static LIST_HEAD(bus_type_list);
 static DECLARE_RWSEM(bus_type_sem);
-- 
1.7.8.112.g3fd21

