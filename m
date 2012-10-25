Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2JYFve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:51:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49566 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab2JYFvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:51:32 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/2] Remove CsrEventHandle and functions using it
Date: Thu, 25 Oct 2012 14:51:10 +0900
Message-Id: <1351144271-24443-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody use CsrEventHandle, Nobody call function using it as parameter.
So, remove it.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext.h       |   61 -------------------------
 drivers/staging/csr/csr_framework_ext_types.h |    2 -
 2 files changed, 63 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext.h b/drivers/staging/csr/csr_framework_ext.h
index 66973e9..7cfbd48 100644
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
index 57194ee..d97c2de 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -37,7 +37,6 @@ struct CsrEvent
     unsigned int      wakeup_flag;
 };
 
-typedef struct CsrEvent CsrEventHandle;
 typedef struct semaphore CsrMutexHandle;
 typedef struct CsrThread CsrThreadHandle;
 
@@ -50,7 +49,6 @@ struct CsrEvent
     u32       eventBits;
 };
 
-typedef struct CsrEvent CsrEventHandle;
 typedef pthread_mutex_t CsrMutexHandle;
 typedef pthread_t CsrThreadHandle;
 
-- 
1.7.9.5

