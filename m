Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab2JYGzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:55:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38452 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2JYGzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:55:09 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: csr: Fix coding style
Date: Thu, 25 Oct 2012 15:54:53 +0900
Message-Id: <1351148093-902-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style for csr_log.h

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_log.h |  165 ++++++++++++++++++++---------------------
 1 file changed, 80 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/csr/csr_log.h b/drivers/staging/csr/csr_log.h
index b280856..26657a5 100644
--- a/drivers/staging/csr/csr_log.h
+++ b/drivers/staging/csr/csr_log.h
@@ -2,11 +2,11 @@
 #define CSR_LOG_H__
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            All rights reserved and confidential information of CSR
+	(c) Cambridge Silicon Radio Limited 2010
+	All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+	Refer to LICENSE.txt included with this source for details
+	on the license terms.
 
 *****************************************************************************/
 
@@ -77,34 +77,31 @@ u8 CsrLogTaskIsFiltered(CsrSchedQid taskId, CsrLogLevelTask level);
 /*
  * Logging stuff
  */
-#define CSR_LOG_STRINGIFY_REAL(a) #a
+#define CSR_LOG_STRINGIFY_REAL(a) (#a)
 #define CSR_LOG_STRINGIFY(a) CSR_LOG_STRINGIFY_REAL(a)
 
 #ifdef CSR_LOG_ASSERT_ENABLE
-#define CSR_LOG_ASSERT(cond)                        \
-    do {                                                \
-        if (!(cond))                                    \
-        {                                               \
-            char *panic_arg = "[" __FILE__ ":" CSR_LOG_STRINGIFY(__LINE__) "] - " CSR_LOG_STRINGIFY(cond); \
-            CsrPanic(CSR_TECH_FW, CSR_PANIC_FW_ASSERTION_FAIL, panic_arg); \
-        }                                               \
-    } while (0)
+#define CSR_LOG_ASSERT(cond) \
+	do { \
+		if (!(cond)) { \
+			char *panic_arg = "[" __FILE__ ":" CSR_LOG_STRINGIFY(__LINE__) "] - " CSR_LOG_STRINGIFY(cond); \
+			CsrPanic(CSR_TECH_FW, CSR_PANIC_FW_ASSERTION_FAIL, panic_arg); \
+		} \
+	} while (0)
 #else
 #define CSR_LOG_ASSERT(cond)
 #endif
 
-typedef struct
-{
-    u16            primitiveType;
-    const char *primitiveName;
-    CsrMsgConvMsgEntry  *messageConv; /* Private - do not use */
+typedef struct {
+	u16            primitiveType;
+	const char *primitiveName;
+	CsrMsgConvMsgEntry  *messageConv; /* Private - do not use */
 } CsrLogPrimitiveInformation;
 
-typedef struct
-{
-    const char        *techVer;
-    u32                   primitiveInfoCount;
-    CsrLogPrimitiveInformation *primitiveInfo;
+typedef struct {
+	const char        *techVer;
+	u32                   primitiveInfoCount;
+	CsrLogPrimitiveInformation *primitiveInfo;
 } CsrLogTechInformation;
 
 /*---------------------------------*/
@@ -118,21 +115,19 @@ typedef u32 bitmask32_t;
 #ifdef CSR_LOG_INCLUDE_FILE_NAME_AND_LINE_NUMBER
 /* DEPRECATED - replaced by csr_log_text.h */
 #define CSR_LOG_TEXT(text) \
-    do { \
-        if (!CsrLogTaskIsFiltered(CsrSchedTaskQueueGet(), CSR_LOG_LEVEL_TASK_TEXT)) \
-        { \
-            CsrLogTaskText(text, __LINE__, __FILE__); \
-        } \
-    } while (0)
+	do { \
+		if (!CsrLogTaskIsFiltered(CsrSchedTaskQueueGet(), CSR_LOG_LEVEL_TASK_TEXT)) { \
+			CsrLogTaskText(text, __LINE__, __FILE__); \
+		} \
+	} while (0)
 #else
 /* DEPRECATED - replaced by csr_log_text.h */
 #define CSR_LOG_TEXT(text) \
-    do { \
-        if (!CsrLogTaskIsFiltered(CsrSchedTaskQueueGet(), CSR_LOG_LEVEL_TASK_TEXT)) \
-        { \
-            CsrLogTaskText(text, 0, NULL); \
-        } \
-    } while (0)
+	do { \
+		if (!CsrLogTaskIsFiltered(CsrSchedTaskQueueGet(), CSR_LOG_LEVEL_TASK_TEXT)) { \
+			CsrLogTaskText(text, 0, NULL); \
+		} \
+	} while (0)
 #endif
 #else
 #define CSR_LOG_TEXT(text)
@@ -140,8 +135,8 @@ typedef u32 bitmask32_t;
 
 /* DEPRECATED - replaced by csr_log_text.h */
 void CsrLogTaskText(const char *text,
-    u32 line,
-    const char *file);
+	u32 line,
+	const char *file);
 
 #define CSR_LOG_STATE_TRANSITION_MASK_FSM_NAME          (0x001)
 #define CSR_LOG_STATE_TRANSITION_MASK_NEXT_STATE        (0x002)
@@ -153,16 +148,16 @@ void CsrLogTaskText(const char *text,
 
 /* DEPRECATED - replaced by csr_log_text.h */
 void CsrLogStateTransition(bitmask16_t mask,
-    u32 identifier,
-    const char *fsm_name,
-    u32 prev_state,
-    const char *prev_state_str,
-    u32 in_event,
-    const char *in_event_str,
-    u32 next_state,
-    const char *next_state_str,
-    u32 line,
-    const char *file);
+	u32 identifier,
+	const char *fsm_name,
+	u32 prev_state,
+	const char *prev_state_str,
+	u32 in_event,
+	const char *in_event_str,
+	u32 next_state,
+	const char *next_state_str,
+	u32 line,
+	const char *file);
 
 /*---------------------------------*/
 /*  BSP logging */
@@ -183,64 +178,64 @@ void CsrLogDeactivate(CsrSchedQid tskid);
 #define SYNERGY_SERIALIZER_TYPE_SER     (0x001)
 
 void CsrLogMessagePut(u32 line,
-    const char *file,
-    CsrSchedQid src_task_id,
-    CsrSchedQid dst_taskid,
-    CsrSchedMsgId msg_id,
-    u16 prim_type,
-    const void *msg);
+	const char *file,
+	CsrSchedQid src_task_id,
+	CsrSchedQid dst_taskid,
+	CsrSchedMsgId msg_id,
+	u16 prim_type,
+	const void *msg);
 
 void CsrLogMessageGet(CsrSchedQid src_task_id,
-    CsrSchedQid dst_taskid,
-    u8 get_res,
-    CsrSchedMsgId msg_id,
-    u16 prim_type,
-    const void *msg);
+	CsrSchedQid dst_taskid,
+	u8 get_res,
+	CsrSchedMsgId msg_id,
+	u16 prim_type,
+	const void *msg);
 
 void CsrLogTimedEventIn(u32 line,
-    const char *file,
-    CsrSchedQid task_id,
-    CsrSchedTid tid,
-    CsrTime requested_delay,
-    u16 fniarg,
-    const void *fnvarg);
+	const char *file,
+	CsrSchedQid task_id,
+	CsrSchedTid tid,
+	CsrTime requested_delay,
+	u16 fniarg,
+	const void *fnvarg);
 
 void CsrLogTimedEventFire(CsrSchedQid task_id,
-    CsrSchedTid tid);
+	CsrSchedTid tid);
 
 void CsrLogTimedEventDone(CsrSchedQid task_id,
-    CsrSchedTid tid);
+	CsrSchedTid tid);
 
 void CsrLogTimedEventCancel(u32 line,
-    const char *file,
-    CsrSchedQid task_id,
-    CsrSchedTid tid,
-    u8 cancel_res);
+	const char *file,
+	CsrSchedQid task_id,
+	CsrSchedTid tid,
+	u8 cancel_res);
 
 void CsrLogBgintRegister(u8 thread_id,
-    CsrSchedBgint irq,
-    const char *callback,
-    const void *ptr);
+	CsrSchedBgint irq,
+	const char *callback,
+	const void *ptr);
 void CsrLogBgintUnregister(CsrSchedBgint irq);
 void CsrLogBgintSet(CsrSchedBgint irq);
 void CsrLogBgintServiceStart(CsrSchedBgint irq);
 void CsrLogBgintServiceDone(CsrSchedBgint irq);
 
 void CsrLogExceptionStateEvent(u16 prim_type,
-    CsrPrim msg_type,
-    u16 state,
-    u32 line,
-    const char *file);
+	CsrPrim msg_type,
+	u16 state,
+	u32 line,
+	const char *file);
 void CsrLogExceptionGeneral(u16 prim_type,
-    u16 state,
-    const char *text,
-    u32 line,
-    const char *file);
+	u16 state,
+	const char *text,
+	u32 line,
+	const char *file);
 void CsrLogExceptionWarning(u16 prim_type,
-    u16 state,
-    const char *text,
-    u32 line,
-    const char *file);
+	u16 state,
+	const char *text,
+	u32 line,
+	const char *file);
 
 #ifdef __cplusplus
 }
-- 
1.7.9.5

