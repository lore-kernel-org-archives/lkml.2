Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab0E1Rpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:45:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:10488 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293Ab0E1Rpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:45:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,319,1272870000"; 
   d="scan'208";a="625733875"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix section mismatch cpu_notify_nofail() -> cpu_chain
Date: Fri, 28 May 2010 10:45:38 -0700
Message-Id: <4c000142282429edd0@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Section mismatch in reference from the function cpu_notify_nofail()
         to the variable .cpuinit.data:cpu_chain
    
It appears that "cpu_chain" should not be marked as __cpuinitdata.
    
Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3097382..84d66a0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -34,7 +34,7 @@ void cpu_maps_update_done(void)
 	mutex_unlock(&cpu_add_remove_lock);
 }
 
-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+static RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
