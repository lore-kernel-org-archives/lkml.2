Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab1JNV57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:57:59 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60872 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab1JNV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/11] drbd: Define scale factors in a single place
Date: Fri, 14 Oct 2011 23:57:45 +0200
Message-Id: <1318629472-11110-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_limits.h |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 3fc554b..9b76984 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -18,29 +18,35 @@
 #define DRBD_MINOR_COUNT_MIN 1
 #define DRBD_MINOR_COUNT_MAX (1U << 20)
 #define DRBD_MINOR_COUNT_DEF 32
+#define DRBD_MINOR_COUNT_SCALE '1'
 
 #define DRBD_VOLUME_MAX 65535
 
 #define DRBD_DIALOG_REFRESH_MIN 0
 #define DRBD_DIALOG_REFRESH_MAX 600
+#define DRBD_DIALOG_REFRESH_SCALE '1'
 
 /* valid port number */
 #define DRBD_PORT_MIN 1
 #define DRBD_PORT_MAX 0xffff
+#define DRBD_PORT_SCALE '1'
 
 /* startup { */
   /* if you want more than 3.4 days, disable */
 #define DRBD_WFC_TIMEOUT_MIN 0
 #define DRBD_WFC_TIMEOUT_MAX 300000
 #define DRBD_WFC_TIMEOUT_DEF 0
+#define DRBD_WFC_TIMEOUT_SCALE '1'
 
 #define DRBD_DEGR_WFC_TIMEOUT_MIN 0
 #define DRBD_DEGR_WFC_TIMEOUT_MAX 300000
 #define DRBD_DEGR_WFC_TIMEOUT_DEF 0
+#define DRBD_DEGR_WFC_TIMEOUT_SCALE '1'
 
 #define DRBD_OUTDATED_WFC_TIMEOUT_MIN 0
 #define DRBD_OUTDATED_WFC_TIMEOUT_MAX 300000
 #define DRBD_OUTDATED_WFC_TIMEOUT_DEF 0
+#define DRBD_OUTDATED_WFC_TIMEOUT_SCALE '1'
 /* }*/
 
 /* net { */
@@ -49,6 +55,7 @@
 #define DRBD_TIMEOUT_MIN 1
 #define DRBD_TIMEOUT_MAX 600
 #define DRBD_TIMEOUT_DEF 60       /* 6 seconds */
+#define DRBD_TIMEOUT_SCALE '1'
 
  /* If backing disk takes longer than disk_timeout, mark the disk as failed */
 #define DRBD_DISK_TIMEOUT_MIN 0    /* 0 = disabled */
@@ -60,46 +67,55 @@
 #define DRBD_CONNECT_INT_MIN 1
 #define DRBD_CONNECT_INT_MAX 120
 #define DRBD_CONNECT_INT_DEF 10   /* seconds */
+#define DRBD_CONNECT_INT_SCALE '1'
 
   /* keep-alive probes when idle */
 #define DRBD_PING_INT_MIN 1
 #define DRBD_PING_INT_MAX 120
 #define DRBD_PING_INT_DEF 10
+#define DRBD_PING_INT_SCALE '1'
 
  /* timeout for the ping packets.*/
 #define DRBD_PING_TIMEO_MIN  1
 #define DRBD_PING_TIMEO_MAX  300
 #define DRBD_PING_TIMEO_DEF  5
+#define DRBD_PING_TIMEO_SCALE '1'
 
   /* max number of write requests between write barriers */
 #define DRBD_MAX_EPOCH_SIZE_MIN 1
 #define DRBD_MAX_EPOCH_SIZE_MAX 20000
 #define DRBD_MAX_EPOCH_SIZE_DEF 2048
+#define DRBD_MAX_EPOCH_SIZE_SCALE '1'
 
   /* I don't think that a tcp send buffer of more than 10M is useful */
 #define DRBD_SNDBUF_SIZE_MIN  0
 #define DRBD_SNDBUF_SIZE_MAX  (10<<20)
 #define DRBD_SNDBUF_SIZE_DEF  0
+#define DRBD_SNDBUF_SIZE_SCALE '1'
 
 #define DRBD_RCVBUF_SIZE_MIN  0
 #define DRBD_RCVBUF_SIZE_MAX  (10<<20)
 #define DRBD_RCVBUF_SIZE_DEF  0
+#define DRBD_RCVBUF_SIZE_SCALE '1'
 
   /* @4k PageSize -> 128kB - 512MB */
 #define DRBD_MAX_BUFFERS_MIN  32
 #define DRBD_MAX_BUFFERS_MAX  131072
 #define DRBD_MAX_BUFFERS_DEF  2048
+#define DRBD_MAX_BUFFERS_SCALE '1'
 
   /* @4k PageSize -> 4kB - 512MB */
 #define DRBD_UNPLUG_WATERMARK_MIN  1
 #define DRBD_UNPLUG_WATERMARK_MAX  131072
 #define DRBD_UNPLUG_WATERMARK_DEF (DRBD_MAX_BUFFERS_DEF/16)
+#define DRBD_UNPLUG_WATERMARK_SCALE '1'
 
   /* 0 is disabled.
    * 200 should be more than enough even for very short timeouts */
 #define DRBD_KO_COUNT_MIN  0
 #define DRBD_KO_COUNT_MAX  200
 #define DRBD_KO_COUNT_DEF  7
+#define DRBD_KO_COUNT_SCALE '1'
 /* } */
 
 /* syncer { */
@@ -118,6 +134,7 @@
 #define DRBD_AL_EXTENTS_MIN  7
 #define DRBD_AL_EXTENTS_MAX  6433
 #define DRBD_AL_EXTENTS_DEF  1237
+#define DRBD_AL_EXTENTS_SCALE '1'
 
 #define DRBD_MINOR_NUMBER_MIN  -1
 #define DRBD_MINOR_NUMBER_MAX  (1<<30)
@@ -148,34 +165,42 @@
 #define DRBD_MAX_BIO_BVECS_MIN 0
 #define DRBD_MAX_BIO_BVECS_MAX 128
 #define DRBD_MAX_BIO_BVECS_DEF 0
+#define DRBD_MAX_BIO_BVECS_SCALE '1'
 
 #define DRBD_C_PLAN_AHEAD_MIN  0
 #define DRBD_C_PLAN_AHEAD_MAX  300
 #define DRBD_C_PLAN_AHEAD_DEF  20
+#define DRBD_C_PLAN_AHEAD_SCALE '1'
 
 #define DRBD_C_DELAY_TARGET_MIN 1
 #define DRBD_C_DELAY_TARGET_MAX 100
 #define DRBD_C_DELAY_TARGET_DEF 10
+#define DRBD_C_DELAY_TARGET_SCALE '1'
 
 #define DRBD_C_FILL_TARGET_MIN 0
 #define DRBD_C_FILL_TARGET_MAX (1<<20) /* 500MByte in sec */
 #define DRBD_C_FILL_TARGET_DEF 100 /* Try to place 50KiB in socket send buffer during resync */
+#define DRBD_C_FILL_TARGET_SCALE 's'  /* sectors */
 
-#define DRBD_C_MAX_RATE_MIN     250 /* kByte/sec */
+#define DRBD_C_MAX_RATE_MIN     250
 #define DRBD_C_MAX_RATE_MAX     (4 << 20)
 #define DRBD_C_MAX_RATE_DEF     102400
+#define DRBD_C_MAX_RATE_SCALE	'k'  /* kilobytes */
 
-#define DRBD_C_MIN_RATE_MIN     0 /* kByte/sec */
+#define DRBD_C_MIN_RATE_MIN     0
 #define DRBD_C_MIN_RATE_MAX     (4 << 20)
 #define DRBD_C_MIN_RATE_DEF     250
+#define DRBD_C_MIN_RATE_SCALE	'k'  /* kilobytes */
 
 #define DRBD_CONG_FILL_MIN	0
 #define DRBD_CONG_FILL_MAX	(10<<21) /* 10GByte in sectors */
 #define DRBD_CONG_FILL_DEF	0
+#define DRBD_CONG_FILL_SCALE	's'  /* sectors */
 
 #define DRBD_CONG_EXTENTS_MIN	DRBD_AL_EXTENTS_MIN
 #define DRBD_CONG_EXTENTS_MAX	DRBD_AL_EXTENTS_MAX
 #define DRBD_CONG_EXTENTS_DEF	DRBD_AL_EXTENTS_DEF
+#define DRBD_CONG_EXTENTS_SCALE DRBD_AL_EXTENTS_SCALE
 
 #define DRBD_PROTOCOL_DEF DRBD_PROT_C
 
-- 
1.7.4.1

