Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2JOP2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:28:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:44411 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab2JOP2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 11:28:08 -0400
Subject: [PATCH] proc: check vma->vm_file before dereferencing
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, ebiederm@xmission.com,
        rientjes@google.com, gorcunov@openvz.org, devel@openvz.org
Date: Mon, 15 Oct 2012 19:30:03 +0400
Message-ID: <20121015152957.24859.7960.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can be equal to NULL.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 fs/proc/base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 144a967..74fc562 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1770,8 +1770,9 @@ static struct dentry *proc_map_files_lookup(struct inode *dir,
 	if (!vma)
 		goto out_no_vma;
 
-	result = proc_map_files_instantiate(dir, dentry, task,
-			(void *)(unsigned long)vma->vm_file->f_mode);
+	if (vma->vm_file)
+		result = proc_map_files_instantiate(dir, dentry, task,
+				(void *)(unsigned long)vma->vm_file->f_mode);
 
 out_no_vma:
 	up_read(&mm->mmap_sem);

