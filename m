Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2HVQij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:38:39 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43462 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757819Ab2HVQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:38:32 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adobriyan@gmail.com, Nathan Zimmer <nzimmer@sgi.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] fs/prof: Update comment on pde_unload_lock
Date: Wed, 22 Aug 2012 11:38:30 -0500
Message-Id: <1345653510-22000-2-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
References: <n>
 <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment was updated to include the other structures held by the lock.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 include/linux/proc_fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 3fd2e87..42e57e3 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -73,7 +73,8 @@ struct proc_dir_entry {
 	int pde_users;	/* number of callers into module in progress */
 	struct completion *pde_unload_completion;
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	spinlock_t pde_unload_lock;	/* proc_fops checks, pde_users bumps */
+					/* pde_openers, pde_unload_completion */
 	u8 namelen;
 	char name[];
 };
-- 
1.6.0.2

