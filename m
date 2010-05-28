Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0E1HEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:04:42 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:40684 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab0E1HD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:03:59 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 1/8] cpuidle: fail to register if !CONFIG_CPU_IDLE
Date: Fri, 28 May 2010 02:01:54 -0400
Message-id: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1275026521-30835-1-git-send-email-lenb@kernel.org>
References: <1275026521-30835-1-git-send-email-lenb@kernel.org>
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
index dcf77fa..f5e6480 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -137,16 +137,16 @@ extern void cpuidle_disable_device(struct cpuidle_device *dev);
 #else
 
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
-{return 0;}
+{return -ENODEV; }
 static inline void cpuidle_unregister_driver(struct cpuidle_driver *drv) { }
 static inline int cpuidle_register_device(struct cpuidle_device *dev)
-{return 0;}
+{return -ENODEV; }
 static inline void cpuidle_unregister_device(struct cpuidle_device *dev) { }
 
 static inline void cpuidle_pause_and_lock(void) { }
 static inline void cpuidle_resume_and_unlock(void) { }
 static inline int cpuidle_enable_device(struct cpuidle_device *dev)
-{return 0;}
+{return -ENODEV; }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
 
 #endif
-- 
1.6.0.6

