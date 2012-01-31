Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2AaWmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:42:31 -0500
Received: from [206.117.179.246] ([206.117.179.246]:57465 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755464Ab2AaWm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:42:29 -0500
From: Joe Perches <joe@perches.com>
To: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu
Cc: codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] coda: Remove unnecessary OOM messages
Date: Tue, 31 Jan 2012 14:42:07 -0800
Message-Id: <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1328049542.git.joe@perches.com>
References: <cover.1328049542.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per call site OOM messages are unnecessary.
k.alloc and v.alloc failures use dump_stack().

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/coda/coda_linux.h |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
index cc0ea9f..7b2c3a1 100644
--- a/fs/coda/coda_linux.h
+++ b/fs/coda/coda_linux.h
@@ -57,13 +57,12 @@ unsigned short coda_flags_to_cflags(unsigned short);
 void coda_sysctl_init(void);
 void coda_sysctl_clean(void);
 
-#define CODA_ALLOC(ptr, cast, size) do { \
-    if (size < PAGE_SIZE) \
-        ptr = kzalloc((unsigned long) size, GFP_KERNEL); \
-    else \
-        ptr = (cast)vzalloc((unsigned long) size); \
-    if (!ptr) \
-        printk("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
+#define CODA_ALLOC(ptr, cast, size)			\
+do {							\
+	if (size < PAGE_SIZE)				\
+		ptr = kzalloc(size, GFP_KERNEL);	\
+	else						\
+		ptr = vzalloc(size);			\
 } while (0)
 
 
-- 
1.7.8.111.gad25c.dirty

