Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab2F2EWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:22:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65084 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2F2EWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:22:37 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/3] staging: sep: sep_driver_config.h: Remove unused macros
Date: Fri, 29 Jun 2012 01:19:24 -0300
Message-Id: <1340943564-19082-4-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340943564-19082-1-git-send-email-marcos.souza.org@gmail.com>
References: <1340943564-19082-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these macros are not used, so remove it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/sep/sep_driver_config.h |   65 -------------------------------
 1 file changed, 65 deletions(-)

diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index 9d9fc7c..499664f 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -38,17 +38,6 @@
   DRIVER CONFIGURATION FLAGS
   -------------------------------------*/
 
-/* if flag is on , then the driver is running in polling and
-	not interrupt mode */
-#define SEP_DRIVER_POLLING_MODE                         0
-
-/* flag which defines if the shared area address should be
-	reconfiged (send to SEP anew) during init of the driver */
-#define SEP_DRIVER_RECONFIG_MESSAGE_AREA                0
-
-/* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
-#define SEP_DRIVER_ARM_DEBUG_MODE                       0
-
 /* Critical message area contents for sanity checking */
 #define SEP_START_MSG_TOKEN				0x02558808
 /*-------------------------------------------
@@ -67,18 +56,6 @@
 /* minimum data size of the MLLI table */
 #define SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE		16
 
-/* flag that signifies tah the lock is
-currently held by the process (struct file) */
-#define SEP_DRIVER_OWN_LOCK_FLAG                        1
-
-/* flag that signifies tah the lock is currently NOT
-held by the process (struct file) */
-#define SEP_DRIVER_DISOWN_LOCK_FLAG                     0
-
-/* indicates whether driver has mapped/unmapped shared area */
-#define SEP_REQUEST_DAEMON_MAPPED 1
-#define SEP_REQUEST_DAEMON_UNMAPPED 0
-
 /*--------------------------------------------------------
 	SHARED AREA  memory total size is 36K
 	it is divided is following:
@@ -140,12 +117,6 @@ held by the process (struct file) */
 /* Offset of the sep printf buffer in the message area */
 #define SEP_DRIVER_PRINTF_OFFSET_IN_BYTES			(5888)
 
-/* the size in bytes of the time memory */
-#define SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES			8
-
-/* the size in bytes of the RAR parameters memory */
-#define SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES		8
-
 /* area size that is mapped  - we map the MESSAGE AREA, STATIC POOL and
 	DATA POOL areas. area must be module 4k */
 #define SEP_DRIVER_MMMAP_AREA_SIZE				(1024 * 28)
@@ -154,9 +125,6 @@ held by the process (struct file) */
 	offsets of the areas starting from the shared area start address
 */
 
-/* message area offset */
-#define SEP_DRIVER_MESSAGE_AREA_OFFSET_IN_BYTES			0
-
 /* static pool area offset */
 #define SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES \
 	(SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES)
@@ -180,56 +148,23 @@ held by the process (struct file) */
 #define SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES \
 	(SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES)
 
-/* offset of the RAR area */
-#define SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES \
-	(SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES + \
-	SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES)
-
-/* offset of the caller id area */
-#define SEP_CALLER_ID_OFFSET_BYTES \
-	(SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES + \
-	SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
-
 /* offset of the DCB area */
 #define SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES \
 	(SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES + \
 	0x400)
 
-/* offset of the ext cache area */
-#define SEP_DRIVER_SYSTEM_EXT_CACHE_ADDR_OFFSET_IN_BYTES \
-	SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES
-
-/* offset of the allocation data pointer area */
-#define SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES \
-	(SEP_CALLER_ID_OFFSET_BYTES + \
-	SEP_CALLER_ID_HASH_SIZE_IN_BYTES)
-
 /* the token that defines the start of time address */
 #define SEP_TIME_VAL_TOKEN                                    0x12345678
 
-#define FAKE_RAR_SIZE (1024*1024) /* used only for mfld */
 /* DEBUG LEVEL MASKS */
 
-/* size of the caller id hash (sha2) */
-#define SEP_CALLER_ID_HASH_SIZE_IN_BYTES                      32
-
 /* size of the caller id hash (sha2) in 32 bit words */
 #define SEP_CALLER_ID_HASH_SIZE_IN_WORDS                8
 
-/* maximum number of entries in the caller id table */
-#define SEP_CALLER_ID_TABLE_NUM_ENTRIES                       20
-
 /* maximum number of symetric operation (that require DMA resource)
 	per one message */
 #define SEP_MAX_NUM_SYNC_DMA_OPS			16
 
-/* the token that defines the start of time address */
-#define SEP_RAR_VAL_TOKEN                                     0xABABABAB
-
-/* ioctl error that should be returned when trying
-   to realloc the cache/resident second time */
-#define SEP_ALREADY_INITIALIZED_ERR                           12
-
 /* bit that locks access to the shared area */
 #define SEP_TRANSACTION_STARTED_LOCK_BIT                      0
 
-- 
1.7.10.2

