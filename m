Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab0G3TTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:19:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:34083 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0G3TS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:18:58 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 15/15] mm,kdb,kgdb: Add a debug reference for the kdb kmap usage
Date: Fri, 30 Jul 2010 14:17:36 -0500
Message-Id: <1280517456-1167-16-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 30 Jul 2010 19:17:52.0189 (UTC) FILETIME=[E7D446D0:01CB301B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kdb kmap should never get used outside of the kernel debugger
exception context.

Signed-off-by: Jason Wessel<jason.wessel@windriver.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-mm@kvack.org
---
 mm/highmem.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 66baa20..7a0aa1b 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
+#include <linux/kgdb.h>
 #include <asm/tlbflush.h>
 
 /*
@@ -470,6 +471,12 @@ void debug_kmap_atomic(enum km_type type)
 			warn_count--;
 		}
 	}
+#ifdef CONFIG_KGDB_KDB
+	if (unlikely(type == KM_KDB && atomic_read(&kgdb_active) == -1)) {
+		WARN_ON(1);
+		warn_count--;
+	}
+#endif /* CONFIG_KGDB_KDB */
 }
 
 #endif
-- 
1.6.4.rc1

