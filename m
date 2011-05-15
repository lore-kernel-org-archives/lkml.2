Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1EOWW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:22:28 -0400
Received: from mout.perfora.net ([74.208.4.194]:50092 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761443Ab1EOWWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:22:16 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 6/9] mm: declare mpol_to_str() when CONFIG_TMPFS=n
Date: Sun, 15 May 2011 18:20:26 -0400
Message-Id: <1305498029-11677-7-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305498029-11677-1-git-send-email-wilsons@start.ca>
References: <1305498029-11677-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:QX/RSZCyynoZDrp5zdtk6glfoWRwBT7O8SNlnxJJzdz
 ZGEW+SBibZ5ZaeRh04UodAUXbrcG4LvVxCtVfO8o5NDkQPWXuq
 Tq6JNle1Hp7+X0TErMrhpsH3V4ZdgHIXB/in+K2xT2MWYFiA9T
 YSQunfWVJRfnhu2p1xprbcNyP+fre0szaGPTZyUon2yM1ngpC5
 Y0QVkNRczSvjb0peAh0bhCN1qtrDwILt3/+qK5aqQA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_TMPFS=n mpol_to_str() is not declared in mempolicy.h.
However, in the NUMA case, the definition is always compiled.

Since it is not strictly true that tmpfs is the only client, and since
the symbol was always lurking around anyways, export mpol_to_str()
unconditionally.  Furthermore, this will allow us to move
show_numa_map() out of mempolicy.c and into the procfs subsystem.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 include/linux/mempolicy.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index c2f6032..7978eec 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -231,10 +231,10 @@ int do_migrate_pages(struct mm_struct *mm,
 
 #ifdef CONFIG_TMPFS
 extern int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context);
+#endif
 
 extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 			int no_context);
-#endif
 
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
@@ -371,13 +371,13 @@ static inline int mpol_parse_str(char *str, struct mempolicy **mpol,
 {
 	return 1;	/* error */
 }
+#endif
 
 static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 				int no_context)
 {
 	return 0;
 }
-#endif
 
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
-- 
1.7.4.4

