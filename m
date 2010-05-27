Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab0E0Cmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:42:51 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:35877 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab0E0Cml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:42:41 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 1/8] cpuidle: fail to register if !CONFIG_CPU_IDLE
Date: Wed, 26 May 2010 22:42:24 -0400
Message-id: <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1274928151-30919-1-git-send-email-lenb@kernel.org>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/cpuidle.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index dcf77fa..0fe1efe 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -137,16 +137,16 @@ extern void cpuidle_disable_device(struct cpuidle_device *dev);
 #else
 
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
-{return 0;}
+{return -ENODEV;}
 static inline void cpuidle_unregister_driver(struct cpuidle_driver *drv) { }
 static inline int cpuidle_register_device(struct cpuidle_device *dev)
-{return 0;}
+{return -ENODEV;}
 static inline void cpuidle_unregister_device(struct cpuidle_device *dev) { }
 
 static inline void cpuidle_pause_and_lock(void) { }
 static inline void cpuidle_resume_and_unlock(void) { }
 static inline int cpuidle_enable_device(struct cpuidle_device *dev)
-{return 0;}
+{return -ENODEV;}
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
 
 #endif
-- 
1.6.0.6

