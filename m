Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab1IOMrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:47:11 -0400
Received: from www17.your-server.de ([213.133.104.17]:34459 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478Ab1IOMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:47:09 -0400
Subject: [PATCH] sys_poll(): fix function definition/negative timeout values
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 15 Sep 2011 14:45:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316090761.6545.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix negative timeout values for x86 userland on x86_64 kernels.
Align sys_poll() definition to glibc's definition.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 fs/select.c              |    2 +-
 include/linux/syscalls.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index d33418f..e782258 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -912,7 +912,7 @@ static long do_restart_poll(struct restart_block *restart_block)
 }
 
 SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
-		long, timeout_msecs)
+		int, timeout_msecs)
 {
 	struct timespec end_time, *to = NULL;
 	int ret;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1ff0ec2..8f482e5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -624,7 +624,7 @@ asmlinkage long sys_socketpair(int, int, int, int __user *);
 asmlinkage long sys_socketcall(int call, unsigned long __user *args);
 asmlinkage long sys_listen(int, int);
 asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
-				long timeout);
+				int timeout);
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
 asmlinkage long sys_old_select(struct sel_arg_struct __user *arg);
-- 
1.7.6.2


