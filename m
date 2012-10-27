Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab2J0Spn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 14:45:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43110 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab2J0Spm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 14:45:42 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/2] staging: csr: Remove CsrEventHandle
Date: Sun, 28 Oct 2012 03:45:24 +0900
Message-Id: <1351363525-17707-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one use CsrEventHandle, No one call functions using it as parameter.
So those are not need to be here.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext.h       |   61 -------------------------
 drivers/staging/csr/csr_framework_ext_types.h |    2 -
 2 files changed, 63 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext.h b/drivers/staging/csr/csr_framework_ext.h
index 16635a9..f1295a1 100644
--- a/drivers/staging/csr/csr_framework_ext.h
+++ b/drivers/staging/csr/csr_framework_ext.h
@@ -36,67 +36,6 @@ extern "C" {
 
 /*----------------------------------------------------------------------------*
  *  NAME
- *      CsrEventCreate
- *
- *  DESCRIPTION
- *      Creates an event and returns a handle to the created event.
- *
- *  RETURNS
- *      Possible values:
- *          CSR_RESULT_SUCCESS          in case of success
- *          CSR_FE_RESULT_NO_MORE_EVENTS   in case of out of event resources
- *          CSR_FE_RESULT_INVALID_POINTER  in case the eventHandle pointer is invalid
- *
- *----------------------------------------------------------------------------*/
-CsrResult CsrEventCreate(CsrEventHandle *eventHandle);
-
-/*----------------------------------------------------------------------------*
- *  NAME
- *      CsrEventWait
- *
- *  DESCRIPTION
- *      Wait fore one or more of the event bits to be set.
- *
- *  RETURNS
- *      Possible values:
- *          CSR_RESULT_SUCCESS              in case of success
- *          CSR_FE_RESULT_TIMEOUT              in case of timeout
- *          CSR_FE_RESULT_INVALID_HANDLE       in case the eventHandle is invalid
- *          CSR_FE_RESULT_INVALID_POINTER      in case the eventBits pointer is invalid
- *
- *----------------------------------------------------------------------------*/
-CsrResult CsrEventWait(CsrEventHandle *eventHandle, u16 timeoutInMs, u32 *eventBits);
-
-/*----------------------------------------------------------------------------*
- *  NAME
- *      CsrEventSet
- *
- *  DESCRIPTION
- *      Set an event.
- *
- *  RETURNS
- *      Possible values:
- *          CSR_RESULT_SUCCESS              in case of success
- *          CSR_FE_RESULT_INVALID_HANDLE       in case the eventHandle is invalid
- *
- *----------------------------------------------------------------------------*/
-CsrResult CsrEventSet(CsrEventHandle *eventHandle, u32 eventBits);
-
-/*----------------------------------------------------------------------------*
- *  NAME
- *      CsrEventDestroy
- *
- *  DESCRIPTION
- *      Destroy the event associated.
- *
- *  RETURNS
- *      void
- *
- *----------------------------------------------------------------------------*/
-void CsrEventDestroy(CsrEventHandle *eventHandle);
-
-/*----------------------------------------------------------------------------*
- *  NAME
  *      CsrMutexCreate
  *
  *  DESCRIPTION
diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
index cd1f877..22340c2 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -30,7 +30,6 @@ struct CsrEvent {
 	unsigned int      wakeup_flag;
 };
 
-typedef struct CsrEvent CsrEventHandle;
 typedef struct semaphore CsrMutexHandle;
 
 #else /* __KERNEL __ */
@@ -41,7 +40,6 @@ struct CsrEvent {
 	u32       eventBits;
 };
 
-typedef struct CsrEvent CsrEventHandle;
 typedef pthread_mutex_t CsrMutexHandle;
 
 #endif /* __KERNEL__ */
-- 
1.7.9.5

