Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2DKGCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:02:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38246 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2DKGB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:01:58 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH 6/6] proc: use IS_ERR_OR_NULL()
Date: Wed, 11 Apr 2012 13:59:27 +0800
Message-Id: <1334123976-11681-6-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 fs/proc/base.c       |    2 +-
 fs/proc/task_mmu.c   |    4 ++--
 fs/proc/task_nommu.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2dff86b..a72a409 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -239,7 +239,7 @@ static int proc_pid_auxv(struct task_struct *task, char *buffer)
 {
 	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ);
 	int res = PTR_ERR(mm);
-	if (mm && !IS_ERR(mm)) {
+	if (!IS_ERR_OR_NULL(mm)) {
 		unsigned int nwords = 0;
 		do {
 			nwords += 2;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 03360a1..da4cf5f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -126,7 +126,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-ESRCH);
 
 	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm))
+	if (IS_ERR_OR_NULL(mm))
 		return mm;
 	down_read(&mm->mmap_sem);
 
@@ -916,7 +916,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 
 	mm = mm_access(task, PTRACE_MODE_READ);
 	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
+	if (IS_ERR_OR_NULL(mm))
 		goto out_free;
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 1ccfa53..57ad3cf 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -224,7 +224,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-ESRCH);
 
 	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm)) {
+	if (IS_ERR_OR_NULL(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
 		return mm;
-- 
1.7.7.6

