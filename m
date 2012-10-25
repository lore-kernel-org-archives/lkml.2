Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab2JYFvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:51:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53981 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab2JYFvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:51:42 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/2] Remove struct CsrEvent
Date: Thu, 25 Oct 2012 14:51:11 +0900
Message-Id: <1351144271-24443-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351144271-24443-1-git-send-email-sj38.park@gmail.com>
References: <1351144271-24443-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody use struct CsrEvent. Remove it.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext_types.h |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
index d97c2de..9623eec 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -30,25 +30,11 @@ struct CsrThread
     char                name[16];
 };
 
-struct CsrEvent
-{
-    /* wait_queue for waking the kernel thread */
-    wait_queue_head_t wakeup_q;
-    unsigned int      wakeup_flag;
-};
-
 typedef struct semaphore CsrMutexHandle;
 typedef struct CsrThread CsrThreadHandle;
 
 #else /* __KERNEL __ */
 
-struct CsrEvent
-{
-    pthread_cond_t  event;
-    pthread_mutex_t mutex;
-    u32       eventBits;
-};
-
 typedef pthread_mutex_t CsrMutexHandle;
 typedef pthread_t CsrThreadHandle;
 
-- 
1.7.9.5

