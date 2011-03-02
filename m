Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab1CBBV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:21:26 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:52235 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1CBBVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:21:25 -0500
X-ASG-Debug-ID: 1299028884-082b65890001-xx1T2L
X-Barracuda-Envelope-From: bzhao@marvell.com
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Frank Huang <frankh@marvell.com>,
        Bing Zhao <bzhao@marvell.com>
X-ASG-Orig-Subj: [RFC v3 2/2] printk: add hexdump_debug macro
Subject: [RFC v3 2/2] printk: add hexdump_debug macro
Date: Tue,  1 Mar 2011 17:24:10 -0800
X-ASG-Orig-Subj: [RFC v3 2/2] printk: add hexdump_debug macro
Message-Id: <1299029050-32242-2-git-send-email-bzhao@marvell.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1299029050-32242-1-git-send-email-bzhao@marvell.com>
References: <1299029050-32242-1-git-send-email-bzhao@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299028884
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hexdump_debug(str, buf, len)

str: "prefix string"
buf: buffer pointer
len: length of the buffer being printed

usage:
hexdump_debug("mwifiex data_d: tx_buf: ", tx_buf, 32);

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: use "str" as prefix string (Joe Perches)
v2: rebase against linux-next.git tree and split into 2 patches

 include/linux/printk.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..041ef6d 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -299,4 +299,15 @@ static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 #endif
 
+#if defined(DEBUG)
+#define hexdump_debug(str, buf, len) \
+	print_hex_dump_bytes(str, DUMP_PREFIX_OFFSET, buf, len);
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

