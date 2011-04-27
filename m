Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab1D0Xhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:37:54 -0400
Received: from mout.perfora.net ([74.208.4.194]:57307 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1D0Xhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:37:50 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] proc: make struct proc_maps_private truly private
Date: Wed, 27 Apr 2011 19:35:48 -0400
Message-Id: <1303947349-3620-8-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1303947349-3620-1-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:9TscRgZ3Ho5+SCFMLNc0Jbo8WSh/1sjAuA4/kW2LoqW
 e5wht6m5bzRqb1efI5jos3STl4k3Vkw45ggSZAk06URHQdc2TO
 xO4auymWJthhteJuhZdykx1TE0odJBUofPChExNla7JPJl168S
 hahEuaYRKGBWEft4PNMC3ILtaOLmCXNUnbaC8LAYmgDBbyoSXX
 5MCsWF082VB77YwZC3Y1Qu2ZyKo26M9wP7YY8s+kag=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that mm/mempolicy.c is no longer implementing /proc/pid/numa_maps
there is no need to export struct proc_maps_private to the world.  Move
it to fs/proc/internal.h instead.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/internal.h      |    8 ++++++++
 include/linux/proc_fs.h |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c03e8d3..3c39863 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -119,3 +119,11 @@ struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
  */
 int proc_readdir(struct file *, void *, filldir_t);
 struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
+
+struct proc_maps_private {
+	struct pid *pid;
+	struct task_struct *task;
+#ifdef CONFIG_MMU
+	struct vm_area_struct *tail_vma;
+#endif
+};
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 838c114..55ff594 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -286,12 +286,4 @@ static inline struct net *PDE_NET(struct proc_dir_entry *pde)
 	return pde->parent->data;
 }
 
-struct proc_maps_private {
-	struct pid *pid;
-	struct task_struct *task;
-#ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
-#endif
-};
-
 #endif /* _LINUX_PROC_FS_H */
-- 
1.7.3.5

