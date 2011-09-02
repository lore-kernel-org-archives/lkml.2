Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1IBQsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:48:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56052 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab1IBQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:48:51 -0400
Date: Fri, 2 Sep 2011 20:48:41 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: proc: fix task_struct leak in proc_pid_fd_link_getattr()
Message-ID: <20110902164841.GA3818@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the patch "proc: fix races against execve() of /proc/PID/fd**"
proc_pid_fd_link_getattr() leaked task_struct if ptrace check fails.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
--
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index b65bd88..d44c701 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1681,9 +1681,9 @@ static int proc_pid_fd_link_getattr(struct vfsmount *mnt, struct dentry *dentry,
 
 	generic_fillattr(inode, stat);
 	unlock_trace(task);
-	put_task_struct(task);
 	rc = 0;
 out_task:
+	put_task_struct(task);
 	return rc;
 }
 
-- 
Vasiliy
