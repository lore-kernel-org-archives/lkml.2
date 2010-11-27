Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0K0KZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:25:58 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34780 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343Ab0K0KZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:25:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEhRSFTQ
Message-Id: <93bd3fc2e0a2aec1051c5e5bfaafd59cf325580f.1290852958.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:34 +1100
Subject: [PATCH 04/46] fs: dcache documentation cleanup
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant (and incorrect, since dcache RCU lookup) dentry locking
documentation and point to the canonical document.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 include/linux/dcache.h |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 6a4aea3..fff9755 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -141,22 +141,16 @@ struct dentry_operations {
 	char *(*d_dname)(struct dentry *, char *, int);
 };
 
-/* the dentry parameter passed to d_hash and d_compare is the parent
+/*
+ * Locking rules for dentry_operations callbacks are to be found in
+ * Documentation/filesystems/Locking. Keep it updated!
+ *
+ * the dentry parameter passed to d_hash and d_compare is the parent
  * directory of the entries to be compared. It is used in case these
  * functions need any directory specific information for determining
  * equivalency classes.  Using the dentry itself might not work, as it
  * might be a negative dentry which has no information associated with
- * it */
-
-/*
-locking rules:
-		big lock	dcache_lock	d_lock   may block
-d_revalidate:	no		no		no       yes
-d_hash		no		no		no       yes
-d_compare:	no		yes		yes      no
-d_delete:	no		yes		no       no
-d_release:	no		no		no       yes
-d_iput:		no		no		no       yes
+ * it.
  */
 
 /* d_flags entries */
-- 
1.7.1

