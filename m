Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1LGCwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:52:14 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62704 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1LGCwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:52:13 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Dec 2011 21:52:13 EST
From: Mandeep Singh Baines <msb@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <kees@chromium.org>
Subject: [PATCH] sys_getppid: add missing rcu_dereference
Date: Tue,  6 Dec 2011 18:43:54 -0800
Message-Id: <1323225834-23765-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to safely dereference current->real_parent inside an
rcu_read_lock, we need an rcu_dereference.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@chromium.org>
---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index dbaa624..9c3c62b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1368,7 +1368,7 @@ SYSCALL_DEFINE0(getppid)
 	int pid;
 
 	rcu_read_lock();
-	pid = task_tgid_vnr(current->real_parent);
+	pid = task_tgid_vnr(rcu_dereference(current->real_parent));
 	rcu_read_unlock();
 
 	return pid;
-- 
1.7.3.1

