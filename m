Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1ITW3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:29:39 -0400
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:34427
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab1ITW3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:29:38 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Ben Widawsky <ben@bwidawsk.net>
To: intel-gfx@lists.freedesktop.org
Cc: Ben Widawsky <ben@bwidawsk.net>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/2] drm: Add Panel Self Refresh DP addresses
Date: Tue, 20 Sep 2011 15:29:47 -0700
Message-Id: <1316557787-14935-1-git-send-email-ben@bwidawsk.net>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the addresses and definitions I care about for Panel Self Refresh, as
documented in the eDP spec.

I'm sending these out before some other patches because this should be a fairly
simple one to get upstream and not require too much fuss (where the others may
have some fuss).

This file is a mess with white spacing. I tried to stay consistent with the
surrounding code.

Cc: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
---
 include/drm/drm_dp_helper.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
index 91567bb..c29d493 100644
--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -74,6 +74,17 @@
 
 #define DP_TRAINING_AUX_RD_INTERVAL         0x00e
 
+#define DP_PSR_SUPPORT                      0x070
+# define DP_PSR_TRAIN_ON_EXIT               0
+#define DP_PSR_CAPS                         0x071
+# define DP_PSR_SETUP_TIME_330              0
+# define DP_PSR_SETUP_TIME_275              1
+# define DP_PSR_SETUP_TIME_220              2
+# define DP_PSR_SETUP_TIME_165              3
+# define DP_PSR_SETUP_TIME_110              4
+# define DP_PSR_SETUP_TIME_55               5
+# define DP_PSR_SETUP_TIME_0                6
+
 /* link configuration */
 #define	DP_LINK_BW_SET		            0x100
 # define DP_LINK_BW_1_62		    0x06
@@ -133,6 +144,12 @@
 #define DP_MAIN_LINK_CHANNEL_CODING_SET	    0x108
 # define DP_SET_ANSI_8B10B		    (1 << 0)
 
+#define DP_PSR_EN_CFG			    0x170
+# define DP_PSR_ENABLE			    (1 << 0)
+# define DP_PSR_MAIN_LIKE_ACTIVE	    (1 << 1)
+# define DP_PSR_CRC_VERIFICATION	    (1 << 2)
+# define DP_PSR_FRAME_CAPTURE		    (1 << 3)
+
 #define DP_LANE0_1_STATUS		    0x202
 #define DP_LANE2_3_STATUS		    0x203
 # define DP_LANE_CR_DONE		    (1 << 0)
@@ -169,6 +186,21 @@
 # define DP_SET_POWER_D0                    0x1
 # define DP_SET_POWER_D3                    0x2
 
+#define DP_PSR_ERROR_STATUS                 0x2006
+# define DP_PSR_LINK_CRC_ERROR              (1 << 0)
+# define DP_PSR_RFB_STORAGE_ERROR           (1 << 1)
+
+#define DP_PSR_ESI                          0x2007
+# define DP_PSR_CAPS_CHANGE                 (1 << 0)
+
+#define DP_PSR_STATUS                       0x2008
+# define DP_PSR_SINK_INACTIVE               (1 << 0)
+# define DP_PSR_SINK_ACTIVE_SRC_SYNCED      (1 << 1)
+# define DP_PSR_SINK_ACTIVE_RFB             (1 << 2)
+# define DP_PSR_SINK_ACTIVE_SINK_SYNCED     (1 << 3)
+# define DP_PSR_SINK_ACTIVE_RESYNC          (1 << 4)
+# define DP_PSR_SINK_INTERNAL_ERROR         (1 << 7)
+
 #define MODE_I2C_START	1
 #define MODE_I2C_WRITE	2
 #define MODE_I2C_READ	4
-- 
1.7.6.1

