Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab1CBBV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:21:27 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:52231 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab1CBBVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:21:25 -0500
X-ASG-Debug-ID: 1299028884-082c657e0001-xx1T2L
X-Barracuda-Envelope-From: bzhao@marvell.com
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Frank Huang <frankh@marvell.com>,
        Bing Zhao <bzhao@marvell.com>
X-ASG-Orig-Subj: [RFC v3 1/2] dynamic debug: add dynamic_hexdump_debug macro
Subject: [RFC v3 1/2] dynamic debug: add dynamic_hexdump_debug macro
Date: Tue,  1 Mar 2011 17:24:09 -0800
X-ASG-Orig-Subj: [RFC v3 1/2] dynamic debug: add dynamic_hexdump_debug macro
Message-Id: <1299029050-32242-1-git-send-email-bzhao@marvell.com>
X-Mailer: git-send-email 1.7.0.2
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299028884
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic_hexdump_debug(str, buf, len)

str: "prefix string"
buf: buffer pointer
len: length of the buffer being printed

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: use "str" as prefix string (Joe Perches)
v2: rebase against linux-next.git tree and split into 2 patches

 include/linux/dynamic_debug.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 0c9653f..06a7fed 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -70,6 +70,17 @@ extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
+#define dynamic_hexdump_debug(str, buf, len)				\
+do {									\
+	static struct _ddebug descriptor				\
+	__used								\
+	__attribute__((section("__verbose"), aligned(8))) =		\
+	{ KBUILD_MODNAME, __func__, __FILE__, str, __LINE__,		\
+		_DPRINTK_FLAGS_DEFAULT };				\
+	if (unlikely(descriptor.enabled))				\
+		print_hex_dump_bytes(str, DUMP_PREFIX_OFFSET, buf, len);\
+} while (0)
+
 #else
 
 static inline int ddebug_remove_module(const char *mod)
@@ -81,6 +92,9 @@ static inline int ddebug_remove_module(const char *mod)
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dynamic_hexdump_debug(str, buf, len)				\
+	do { if (0) print_hex_dump_bytes(str, DUMP_PREFIX_OFFSET,	\
+						buf, len); } while (0)
 #endif
 
 #endif
-- 
1.6.2.5

