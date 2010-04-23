Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0DWPkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab0DWPkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:40:12 -0400
Message-ID: <4BD1BF57.7070201@redhat.com>
Date: Fri, 23 Apr 2010 17:40:07 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Miklos Szeredi <mszeredi@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] procfs: fix tid fdinfo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the file_operations struct in fdinfo entry of tid_base_stuff[].

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7621db8..8418fcc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2909,7 +2909,7 @@ out_no_task:
  */
 static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
+	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
