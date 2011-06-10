Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1FJDoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:44:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43477 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab1FJDoE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:44:04 -0400
Subject: [PATCH] x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) if
 CONFIG_APM_MODULE (only)
From: Ben Hutchings <ben@decadent.org.uk>
To: x86@kernel.org
Cc: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 04:43:56 +0100
Message-ID: <1307677436.22348.589.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 06ae40ce073daf233607a3c54a489f2c1e44683e ('x86 idle:
EXPORT_SYMBOL(default_idle, pm_idle) only when APM demands it') made
these exports dependent on CONFIG_APM_MODULE && CONFIG_APM_CPU_IDLE.
However, the apm module always needs these symbols.
CONFIG_APM_CPU_IDLE only controls whether it installs its CPU idle
handler by default.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This fixes a regression in 3.0-rc1 and should be applied in this cycle.

Ben.

 arch/x86/kernel/process.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2e4928d..e1ba8cb 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -337,7 +337,7 @@ EXPORT_SYMBOL(boot_option_idle_override);
  * Powermanagement idle function, if any..
  */
 void (*pm_idle)(void);
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
+#ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(pm_idle);
 #endif
 
@@ -399,7 +399,7 @@ void default_idle(void)
 		cpu_relax();
 	}
 }
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
+#ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(default_idle);
 #endif
 
-- 
1.7.5.3


