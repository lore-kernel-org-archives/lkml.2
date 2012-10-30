Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2J3C0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:26:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43679 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2J3C0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:26:36 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: csr: Remove struct CsrEvent
Date: Tue, 30 Oct 2012 11:26:13 +0900
Message-Id: <1351563973-20392-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody use struct CsrEvent. So, remove it.
Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext_types.h |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
index 627556a..575598c 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -19,24 +19,10 @@
 
 #ifdef __KERNEL__
 
-struct CsrEvent {
-	/* wait_queue for waking the kernel thread */
-	wait_queue_head_t wakeup_q;
-	unsigned int      wakeup_flag;
-};
-
-typedef struct CsrEvent CsrEventHandle;
 typedef struct semaphore CsrMutexHandle;
 
 #else /* __KERNEL __ */
 
-struct CsrEvent {
-	pthread_cond_t  event;
-	pthread_mutex_t mutex;
-	u32       eventBits;
-};
-
-typedef struct CsrEvent CsrEventHandle;
 typedef pthread_mutex_t CsrMutexHandle;
 
 #endif /* __KERNEL__ */
-- 
1.7.9.5

