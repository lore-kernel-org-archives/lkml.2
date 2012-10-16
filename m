Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2JPWa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:30:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50838 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2JPWaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:30:22 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: gregkh@linuxfoundation.org
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 1/4] Staging: android: binder: Add some missing binder_stat_br calls
Date: Tue, 16 Oct 2012 15:29:52 -0700
Message-Id: <1350426595-18059-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20121016071101.GA5172@kroah.com>
References: <20121016071101.GA5172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cached thread return errors, death notifications and new looper
requests were not included in the stats.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7b0ba92..9e852d0 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2135,6 +2135,7 @@ retry:
 			if (put_user(thread->return_error2, (uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
+			binder_stat_br(proc, thread, thread->return_error2);
 			if (ptr == end)
 				goto done;
 			thread->return_error2 = BR_OK;
@@ -2142,6 +2143,7 @@ retry:
 		if (put_user(thread->return_error, (uint32_t __user *)ptr))
 			return -EFAULT;
 		ptr += sizeof(uint32_t);
+		binder_stat_br(proc, thread, thread->return_error);
 		thread->return_error = BR_OK;
 		goto done;
 	}
@@ -2297,6 +2299,7 @@ retry:
 			if (put_user(death->cookie, (void * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
+			binder_stat_br(proc, thread, cmd);
 			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
 				     "binder: %d:%d %s %p\n",
 				      proc->pid, thread->pid,
@@ -2404,6 +2407,7 @@ done:
 			     proc->pid, thread->pid);
 		if (put_user(BR_SPAWN_LOOPER, (uint32_t __user *)buffer))
 			return -EFAULT;
+		binder_stat_br(proc, thread, BR_SPAWN_LOOPER);
 	}
 	return 0;
 }
-- 
1.7.7.3

