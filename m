Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab0KJAfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:35:37 -0500
Received: from mail.perches.com ([173.55.12.10]:4849 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab0KJAfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:35:32 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH 8/9] fs/quota/dquot.c: Use printf extension %pV
Date: Tue,  9 Nov 2010 16:35:22 -0800
Message-Id: <8ee8a64dba59575938955a22ba3a390ba924b4c5.1289348757.git.joe@perches.com>
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
 fs/quota/dquot.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 0fed41e..aad97ef 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -135,14 +135,18 @@ EXPORT_SYMBOL(dq_data_lock);
 void __quota_error(struct super_block *sb, const char *func,
 		  const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (printk_ratelimit()) {
 		va_start(args, fmt);
-		printk(KERN_ERR "Quota error (device %s): %s: ",
-		       sb->s_id, func);
-		vprintk(fmt, args);
-		printk("\n");
+
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		printk(KERN_ERR "Quota error (device %s): %s: %pV\n",
+		       sb->s_id, func, &vaf);
+
 		va_end(args);
 	}
 }
-- 
1.7.3.1.g432b3.dirty

