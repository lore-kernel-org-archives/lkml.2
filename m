Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1BBFIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:08:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61123 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1BBFIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:08:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aLmHF61pMf8IjDzTAVYzJzfuOPa1oJLUJ4aH8odTntGBMCkgkHVeLg/r51p5/xwCwl
         7oDVPeXd4U7q2fYsN6qpZMRPtxKG9MeZxibjs+m2aAoEEFapVoFZzKstphmyuPm0FaUa
         7VjJK88XQVypg/YigSOCfJ/nualFZJN7yJFuI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 8/8]drivers:staging:octeon change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:08:09 -0800
Message-Id: <1296623289-5500-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/octeon/cvmx-cmd-queue.h |   16 ++++++++--------
 drivers/staging/octeon/cvmx-pko.c       |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/octeon/cvmx-cmd-queue.h b/drivers/staging/octeon/cvmx-cmd-queue.h
index f0cb20f..59d2214 100644
--- a/drivers/staging/octeon/cvmx-cmd-queue.h
+++ b/drivers/staging/octeon/cvmx-cmd-queue.h
@@ -110,7 +110,7 @@ typedef enum {
 } cvmx_cmd_queue_id_t;
 
 /**
- * Command write operations can fail if the comamnd queue needs
+ * Command write operations can fail if the command queue needs
  * a new buffer and the associated FPA pool is empty. It can also
  * fail if the number of queued command words reaches the maximum
  * set at initialization.
@@ -136,12 +136,12 @@ typedef struct {
 	uint64_t unused2:6;
 	/* FPA buffer size in 64bit words minus 1 */
 	uint64_t pool_size_m1:13;
-	/* Number of comamnds already used in buffer */
+	/* Number of commands already used in buffer */
 	uint64_t index:13;
 } __cvmx_cmd_queue_state_t;
 
 /**
- * This structure contains the global state of all comamnd queues.
+ * This structure contains the global state of all command queues.
  * It is stored in a bootmem named block and shared by all
  * applications running on Octeon. Tickets are stored in a differnet
  * cahce line that queue information to reduce the contention on the
@@ -308,7 +308,7 @@ static inline __cvmx_cmd_queue_state_t
 
 /**
  * Write an arbitrary number of command words to a command queue.
- * This is a generic function; the fixed number of comamnd word
+ * This is a generic function; the fixed number of command word
  * functions yield higher performance.
  *
  * @queue_id:  Hardware command queue to write to
@@ -317,7 +317,7 @@ static inline __cvmx_cmd_queue_state_t
  *                  updates. If you don't use this locking you must ensure
  *                  exclusivity some other way. Locking is strongly recommended.
  * @cmd_count: Number of command words to write
- * @cmds:      Array of comamnds to write
+ * @cmds:      Array of commands to write
  *
  * Returns CVMX_CMD_QUEUE_SUCCESS or a failure code
  */
@@ -363,7 +363,7 @@ static inline cvmx_cmd_queue_result_t cvmx_cmd_queue_write(cvmx_cmd_queue_id_t
 		uint64_t *ptr;
 		int count;
 		/*
-		 * We need a new comamnd buffer. Fail if there isn't
+		 * We need a new command buffer. Fail if there isn't
 		 * one available.
 		 */
 		uint64_t *new_buffer =
@@ -466,7 +466,7 @@ static inline cvmx_cmd_queue_result_t cvmx_cmd_queue_write2(cvmx_cmd_queue_id_t
 		 */
 		int count = qptr->pool_size_m1 - qptr->index;
 		/*
-		 * We need a new comamnd buffer. Fail if there isn't
+		 * We need a new command buffer. Fail if there isn't
 		 * one available.
 		 */
 		uint64_t *new_buffer =
@@ -568,7 +568,7 @@ static inline cvmx_cmd_queue_result_t cvmx_cmd_queue_write3(cvmx_cmd_queue_id_t
 		 */
 		int count = qptr->pool_size_m1 - qptr->index;
 		/*
-		 * We need a new comamnd buffer. Fail if there isn't
+		 * We need a new command buffer. Fail if there isn't
 		 * one available
 		 */
 		uint64_t *new_buffer =
diff --git a/drivers/staging/octeon/cvmx-pko.c b/drivers/staging/octeon/cvmx-pko.c
index 00db915..50a2c9b 100644
--- a/drivers/staging/octeon/cvmx-pko.c
+++ b/drivers/staging/octeon/cvmx-pko.c
@@ -54,7 +54,7 @@ void cvmx_pko_initialize_global(void)
 	/*
 	 * Set the size of the PKO command buffers to an odd number of
 	 * 64bit words. This allows the normal two word send to stay
-	 * aligned and never span a comamnd word buffer.
+	 * aligned and never span a command word buffer.
 	 */
 	config.u64 = 0;
 	config.s.pool = CVMX_FPA_OUTPUT_BUFFER_POOL;
-- 
1.6.5.GIT

