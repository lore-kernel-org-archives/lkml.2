Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2DDLea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:34:30 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63414 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2DDLe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:34:28 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        WANG Cong <amwang@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] Do notify userspace when there is change in uts_kern_table.
Date: Wed,  4 Apr 2012 17:06:31 +0530
Message-Id: <1333539391-11036-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sethostname and setdomainname notifies userspace on failure (without modifying uts_kern_table) too

Notify userspace if there is change in uts_kern_table, on failure don't notify userspace 

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e7006eb..6c569a8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1295,8 +1295,8 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 		memcpy(u->nodename, tmp, len);
 		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
+		uts_proc_notify(UTS_PROC_HOSTNAME);
 	}
-	uts_proc_notify(UTS_PROC_HOSTNAME);
 	up_write(&uts_sem);
 	return errno;
 }
@@ -1346,8 +1346,8 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 		memcpy(u->domainname, tmp, len);
 		memset(u->domainname + len, 0, sizeof(u->domainname) - len);
 		errno = 0;
+		uts_proc_notify(UTS_PROC_DOMAINNAME);
 	}
-	uts_proc_notify(UTS_PROC_DOMAINNAME);
 	up_write(&uts_sem);
 	return errno;
 }
-- 
1.7.3.4

