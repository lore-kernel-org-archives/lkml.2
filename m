Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2JWGBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:01:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59753 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2JWGBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:01:01 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/2] Remove CsrThreadHandle
Date: Tue, 23 Oct 2012 15:00:07 +0900
Message-Id: <1350972007-5855-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350972007-5855-1-git-send-email-sj38.park@gmail.com>
References: <1350972007-5855-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CsrThreadHandle is typedef of struct CsrThread.
Some functions in csr_framework_ext.h use it as parameter.
But, nobody call them.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext.h       |   49 -------------------------
 drivers/staging/csr/csr_framework_ext_types.h |    2 -
 2 files changed, 51 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext.h b/drivers/staging/csr/csr_framework_ext.h
index 66973e9..16635a9 100644
--- a/drivers/staging/csr/csr_framework_ext.h
+++ b/drivers/staging/csr/csr_framework_ext.h
@@ -181,55 +181,6 @@ void CsrGlobalMutexUnlock(void);
 
 /*----------------------------------------------------------------------------*
  *  NAME
- *      CsrThreadCreate
- *
- *  DESCRIPTION
- *      Create thread function and return a handle to the created thread.
- *
- *  RETURNS
- *      Possible values:
- *          CSR_RESULT_SUCCESS           in case of success
- *          CSR_FE_RESULT_NO_MORE_THREADS   in case of out of thread resources
- *          CSR_FE_RESULT_INVALID_POINTER   in case one of the supplied pointers is invalid
- *
- *----------------------------------------------------------------------------*/
-CsrResult CsrThreadCreate(void (*threadFunction)(void *pointer), void *pointer,
-    u32 stackSize, u16 priority,
-    const char *threadName, CsrThreadHandle *threadHandle);
-
-/*----------------------------------------------------------------------------*
- *  NAME
- *      CsrThreadGetHandle
- *
- *  DESCRIPTION
- *      Return thread handle of calling thread.
- *
- *  RETURNS
- *      Possible values:
- *          CSR_RESULT_SUCCESS             in case of success
- *          CSR_FE_RESULT_INVALID_POINTER  in case the threadHandle pointer is invalid
- *
- *----------------------------------------------------------------------------*/
-CsrResult CsrThreadGetHandle(CsrThreadHandle *threadHandle);
-
-/*----------------------------------------------------------------------------*
- *  NAME
- *      CsrThreadEqual
- *
- *  DESCRIPTION
- *      Compare thread handles
- *
- *  RETURNS
- *      Possible values:
- *          CSR_RESULT_SUCCESS             in case thread handles are identical
- *          CSR_FE_RESULT_INVALID_POINTER  in case either threadHandle pointer is invalid
- *          CSR_RESULT_FAILURE             otherwise
- *
- *----------------------------------------------------------------------------*/
-CsrResult CsrThreadEqual(CsrThreadHandle *threadHandle1, CsrThreadHandle *threadHandle2);
-
-/*----------------------------------------------------------------------------*
- *  NAME
  *      CsrThreadSleep
  *
  *  DESCRIPTION
diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
index 2bf854a..cd1f877 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -32,7 +32,6 @@ struct CsrEvent {
 
 typedef struct CsrEvent CsrEventHandle;
 typedef struct semaphore CsrMutexHandle;
-typedef struct CsrThread CsrThreadHandle;
 
 #else /* __KERNEL __ */
 
@@ -44,7 +43,6 @@ struct CsrEvent {
 
 typedef struct CsrEvent CsrEventHandle;
 typedef pthread_mutex_t CsrMutexHandle;
-typedef pthread_t CsrThreadHandle;
 
 #endif /* __KERNEL__ */
 
-- 
1.7.9.5

