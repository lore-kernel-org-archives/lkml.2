Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab2J0Spu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 14:45:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43110 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab2J0Spr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 14:45:47 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/2] staging: csr: Remove struct CsrEvent
Date: Sun, 28 Oct 2012 03:45:25 +0900
Message-Id: <1351363525-17707-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351363525-17707-1-git-send-email-sj38.park@gmail.com>
References: <1351363525-17707-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one use struct CsrEvent. So it's unnecessary.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext_types.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
index 22340c2..7ad8720 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -24,22 +24,10 @@ extern "C" {
 
 #ifdef __KERNEL__
 
-struct CsrEvent {
-	/* wait_queue for waking the kernel thread */
-	wait_queue_head_t wakeup_q;
-	unsigned int      wakeup_flag;
-};
-
 typedef struct semaphore CsrMutexHandle;
 
 #else /* __KERNEL __ */
 
-struct CsrEvent {
-	pthread_cond_t  event;
-	pthread_mutex_t mutex;
-	u32       eventBits;
-};
-
 typedef pthread_mutex_t CsrMutexHandle;
 
 #endif /* __KERNEL__ */
-- 
1.7.9.5

