Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2ARXbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:31:45 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47842 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab2ARXbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:31:42 -0500
From: Richard Weinberger <rw@linutronix.de>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/5] xt_log: Make printk() in sb_close() optional
Date: Wed, 18 Jan 2012 23:43:27 +0100
Message-Id: <1326926610-17830-3-git-send-email-rw@linutronix.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1326926610-17830-1-git-send-email-rw@linutronix.de>
References: <1326926610-17830-1-git-send-email-rw@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>


Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/net/netfilter/xt_log.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
index 0dfb34a..767e08d 100644
--- a/include/net/netfilter/xt_log.h
+++ b/include/net/netfilter/xt_log.h
@@ -39,10 +39,12 @@ static struct sbuff *sb_open(void)
 	return m;
 }
 
-static void sb_close(struct sbuff *m)
+static void __sb_close(struct sbuff *m, int print)
 {
-	m->buf[m->count] = 0;
-	printk("%s\n", m->buf);
+	if (print) {
+		m->buf[m->count] = 0;
+		printk("%s\n", m->buf);
+	}
 
 	if (likely(m != &emergency))
 		kfree(m);
@@ -52,3 +54,4 @@ static void sb_close(struct sbuff *m)
 	}
 }
 
+#define sb_close(m)	__sb_close(m, 1)
-- 
1.7.7

