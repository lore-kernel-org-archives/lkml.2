Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1CAFES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:04:18 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:46183 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1CAFEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:04:14 -0500
X-ASG-Debug-ID: 1298955853-082c62fa0001-xx1T2L
X-Barracuda-Envelope-From: bzhao@marvell.com
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Frank Huang <frankh@marvell.com>,
        Bing Zhao <bzhao@marvell.com>
X-ASG-Orig-Subj: [RFC v2 2/2] printk: add hexdump_debug macro
Subject: [RFC v2 2/2] printk: add hexdump_debug macro
Date: Mon, 28 Feb 2011 21:06:56 -0800
X-ASG-Orig-Subj: [RFC v2 2/2] printk: add hexdump_debug macro
Message-Id: <1298956016-30673-3-git-send-email-bzhao@marvell.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
References: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1298955853
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hexdump_debug(str, buf, len)

str: "subject string"
buf: buffer pointer
len: length of the buffer being printed

usage:
hexdump_debug("mwifiex data: tx_buf:\n", tx_buf, 32);

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/printk.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..c758131 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -299,4 +299,18 @@ static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 #endif
 
+#if defined(DEBUG)
+#define hexdump_debug(str, buf, len) \
+do {									\
+	printk(KERN_DEBUG str);						\
+	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);		\
+} while (0)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+#define hexdump_debug(str, buf, len) \
+	dynamic_hexdump_debug(str, buf, len)
+#else
+#define hexdump_debug(str, buf, len) \
+	no_printk(KERN_DEBUG str)
+#endif
+
 #endif
-- 
1.6.2.5

