Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2AEFNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 00:13:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:7780 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab2AEFNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 00:13:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92559886"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/2] time: remove the unnecessary CONFIG_GENERIC_CLOCKEVENS check
Date: Thu,  5 Jan 2012 21:28:05 +0800
Message-Id: <1325770085-5162-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1325770085-5162-1-git-send-email-feng.tang@intel.com>
References: <1325770085-5162-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/time/Kconfig:
config GENERIC_CLOCKEVENTS_BUILD
	bool
	default y
	depends on GENERIC_CLOCKEVENTS

So there is no need to check CONFIG_GENERIC_CLOCKEVENTS if the
CONFIG_GENERIC_CLOCKEVENTS_BUILD is defined already.

This prepares for the total removal of GENERIC_CLOCKEVENTS_BUILD.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 include/linux/clockchips.h |    4 ----
 kernel/time/clockevents.c  |    2 --
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 81e803e..ac15057 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -155,11 +155,7 @@ clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
 				      freq, minsec);
 }
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
-#else
-# define clockevents_notify(reason, arg) do { } while (0)
-#endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
 
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 1ecd6ba..f91b7a8 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -399,7 +399,6 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 /**
  * clockevents_notify - notification about relevant events
  */
@@ -439,4 +438,3 @@ void clockevents_notify(unsigned long reason, void *arg)
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
-#endif
-- 
1.7.1

