Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0KJAhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:37:23 -0500
Received: from mail.perches.com ([173.55.12.10]:4838 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab0KJAf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:35:29 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/9] drivers/net/wireless/ath/debug.c: Use printf extension %pV
Date: Tue,  9 Nov 2010 16:35:17 -0800
Message-Id: <a6721b7e8c66b79da756a7b3d9dbf74e7663a1e9.1289348757.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/debug.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/debug.c b/drivers/net/wireless/ath/debug.c
index dacfb23..a9600ba 100644
--- a/drivers/net/wireless/ath/debug.c
+++ b/drivers/net/wireless/ath/debug.c
@@ -19,14 +19,19 @@
 
 void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (likely(!(common->debug_mask & dbg_mask)))
 		return;
 
 	va_start(args, fmt);
-	printk(KERN_DEBUG "ath: ");
-	vprintk(fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_DEBUG "ath: %pV", &vaf);
+
 	va_end(args);
 }
 EXPORT_SYMBOL(ath_print);
-- 
1.7.3.1.g432b3.dirty

