Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab2KWMIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:08:52 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56728 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab2KWMIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:08:50 -0500
From: James Hogan <james.hogan@imgtec.com>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Joe Perches" <joe@perches.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 1/2] linux/kernel.h: define SYMBOL_PREFIX
Date: Fri, 23 Nov 2012 12:08:15 +0000
Message-ID: <1353672496-10789-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1353672496-10789-1-git-send-email-james.hogan@imgtec.com>
References: <1353672496-10789-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_11_23_12_08_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define SYMBOL_PREFIX to be the same as CONFIG_SYMBOL_PREFIX if set by
the architecture, or "" otherwise. This avoids the need for ugly #ifdefs
whenever symbols are referenced in asm blocks.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/kernel.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a123b13..7d8dfc7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -701,6 +701,13 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #define COMPACTION_BUILD 0
 #endif
 
+/* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
+#ifdef CONFIG_SYMBOL_PREFIX
+#define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define SYMBOL_PREFIX ""
+#endif
+
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
-- 
1.7.7.6


