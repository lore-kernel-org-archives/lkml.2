Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab1JNV55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:57:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60869 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1JNV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/11] drbd: Changed some defaults
Date: Fri, 14 Oct 2011 23:57:44 +0200
Message-Id: <1318629472-11110-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Enabled the resync controller, with a fill target of 50Kib. That gives
  reasonable resync speeds without tuning. A much better default than
  the 250KiB/s fixed.

* Enable bitmap compression. It is save to use, and most people have
  more CPU power than network bandwidth.

* ko-count of 7: Abort a connection if the peer fails to process a
  write request within 42 seconds.

* al-extents of 1237: ~5 GiB seems to be a much more sane default
  these days.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_limits.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 425010a..3fc554b 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -16,7 +16,7 @@
 #define DEBUG_RANGE_CHECK 0
 
 #define DRBD_MINOR_COUNT_MIN 1
-#define DRBD_MINOR_COUNT_MAX 256
+#define DRBD_MINOR_COUNT_MAX (1U << 20)
 #define DRBD_MINOR_COUNT_DEF 32
 
 #define DRBD_VOLUME_MAX 65535
@@ -99,7 +99,7 @@
    * 200 should be more than enough even for very short timeouts */
 #define DRBD_KO_COUNT_MIN  0
 #define DRBD_KO_COUNT_MAX  200
-#define DRBD_KO_COUNT_DEF  0
+#define DRBD_KO_COUNT_DEF  7
 /* } */
 
 /* syncer { */
@@ -117,7 +117,7 @@
    * 919 * 7 = 6433 */
 #define DRBD_AL_EXTENTS_MIN  7
 #define DRBD_AL_EXTENTS_MAX  6433
-#define DRBD_AL_EXTENTS_DEF  127
+#define DRBD_AL_EXTENTS_DEF  1237
 
 #define DRBD_MINOR_NUMBER_MIN  -1
 #define DRBD_MINOR_NUMBER_MAX  (1<<30)
@@ -151,7 +151,7 @@
 
 #define DRBD_C_PLAN_AHEAD_MIN  0
 #define DRBD_C_PLAN_AHEAD_MAX  300
-#define DRBD_C_PLAN_AHEAD_DEF  0 /* RS rate controller disabled by default */
+#define DRBD_C_PLAN_AHEAD_DEF  20
 
 #define DRBD_C_DELAY_TARGET_MIN 1
 #define DRBD_C_DELAY_TARGET_MAX 100
@@ -159,7 +159,7 @@
 
 #define DRBD_C_FILL_TARGET_MIN 0
 #define DRBD_C_FILL_TARGET_MAX (1<<20) /* 500MByte in sec */
-#define DRBD_C_FILL_TARGET_DEF 0 /* By default disabled -> controlled by delay_target */
+#define DRBD_C_FILL_TARGET_DEF 100 /* Try to place 50KiB in socket send buffer during resync */
 
 #define DRBD_C_MAX_RATE_MIN     250 /* kByte/sec */
 #define DRBD_C_MAX_RATE_MAX     (4 << 20)
@@ -167,7 +167,7 @@
 
 #define DRBD_C_MIN_RATE_MIN     0 /* kByte/sec */
 #define DRBD_C_MIN_RATE_MAX     (4 << 20)
-#define DRBD_C_MIN_RATE_DEF     4096
+#define DRBD_C_MIN_RATE_DEF     250
 
 #define DRBD_CONG_FILL_MIN	0
 #define DRBD_CONG_FILL_MAX	(10<<21) /* 10GByte in sectors */
@@ -187,6 +187,6 @@
 
 #define DRBD_ALLOW_TWO_PRIMARIES_DEF	0
 #define DRBD_ALWAYS_ASBP_DEF	0
-#define DRBD_USE_RLE_DEF	0
+#define DRBD_USE_RLE_DEF	1
 
 #endif
-- 
1.7.4.1

