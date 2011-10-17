Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1JQHCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:02:31 -0400
Received: from mx06.lb01.inode.at ([62.99.145.6]:9216 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532Ab1JQHCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:02:30 -0400
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rt <linux-rt-users@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        michael@thalmeier.at
Subject: [PATCH] rt18: fix warnings in ftrace.h
Date: Mon, 17 Oct 2011 09:01:07 +0200
Message-Id: <1318834867-14031-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <alpine.LFD.2.02.1110131146370.3240@ionos>
References: <alpine.LFD.2.02.1110131146370.3240@ionos>
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: p9H72Qkb001914
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1319439748.96664@Ja09Jx3Wk+vQ1h50KV0C2g
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_FUNCTION_TRACER is not set usage of unknown struct ftrace_hash in
ftrace_func_command results in a lot of warnings.


Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 include/linux/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ed0eb52..f0c0e8a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -19,6 +19,8 @@
 
 #include <asm/ftrace.h>
 
+struct ftrace_hash;
+
 #ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
@@ -29,8 +31,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
-struct ftrace_hash;
-
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
-- 
1.7.6.4



--
Scanned by MailScanner.

