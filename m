Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab0KPObo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:31:44 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837Ab0KPOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSFEoVG
Message-Id: <20101116142028.458264209@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:03 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 03/28] fs: dcache documentation cleanup
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-lock-doc-remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant (and incorrect, since dcache RCU lookup) dentry locking
documentation and point to the canonical document.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 include/linux/dcache.h |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:50:55.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:51.000000000 +1100
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


