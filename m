Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1JSIoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:44:39 -0400
Received: from bitmer.com ([213.157.87.50]:59877 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab1JSIoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:44:38 -0400
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] mfd: twl4030-audio: Fix audio codec breakage
Date: Wed, 19 Oct 2011 11:44:05 +0300
Message-Id: <1319013845-2628-1-git-send-email-jarkko.nikula@bitmer.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 57fe725 ("MFD: twl4030-codec -> twl4030-audio: Rename the driver")
broke the device registration for twl4030 codec if twl6040 is not set.

Reason for breakage is that commit didn't update the changed config name for
macro twl_has_codec().

Signed-off-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
I don't know is this too late for 3.1 or would it be better to queue for
stable when it's out? Anyway breakage happened in 3.1-rc cycle and unfortunately
I noticed it only now.
---
 drivers/mfd/twl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 01ecfee..b8eef46 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -109,7 +109,7 @@
 #define twl_has_watchdog()        false
 #endif
 
-#if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE) ||\
+#if defined(CONFIG_MFD_TWL4030_AUDIO) || defined(CONFIG_MFD_TWL4030_AUDIO_MODULE) ||\
 	defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
 #define twl_has_codec()	true
 #else
-- 
1.7.6.3

