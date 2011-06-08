Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1FHMvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:51:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38272 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1FHMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:51:49 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86 idle: APM requires pm_idle/default_idle unconditionally when a module
Date: Wed,  8 Jun 2011 13:51:26 +0100
Message-Id: <1307537486-19317-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit below removed the export for pm_idle/default_idle unless the
apm module was modularised and CONFIG_APM_CPU_IDLE was set.  The apm
module uses pm_idle/default_idle unconditionally, CONFIG_APM_CPU_IDLE
only affects the bios idle threshold.  Adjust the export accordingly.

    commit 06ae40ce073daf233607a3c54a489f2c1e44683e
    Author: Len Brown <len.brown@intel.com>
    Date:   Fri Apr 1 15:28:09 2011 -0400

	x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) only when APM demands it

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 arch/x86/kernel/process.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2e4928d..b8265d0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -337,7 +337,7 @@ EXPORT_SYMBOL(boot_option_idle_override);
  * Powermanagement idle function, if any..
  */
 void (*pm_idle)(void);
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
+#if defined(CONFIG_APM_MODULE)
 EXPORT_SYMBOL(pm_idle);
 #endif
 
@@ -399,7 +399,7 @@ void default_idle(void)
 		cpu_relax();
 	}
 }
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
+#if defined(CONFIG_APM_MODULE)
 EXPORT_SYMBOL(default_idle);
 #endif
 
-- 
1.7.4.1

