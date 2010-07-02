Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0GBIRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:17:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:58364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0GBIQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:16:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,525,1272870000"; 
   d="scan'208";a="532503459"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       hpa@zytor.com, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/5] x86, mrst: add i8042_detect API for Moorestwon platform
Date: Fri,  2 Jul 2010 16:35:13 +0800
Message-Id: <1278059716-7147-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278059716-7147-1-git-send-email-feng.tang@intel.com>
References: <1278059716-7147-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

It will just return 0 as there is no i8042 controller

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/mrst.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index e796448..5915e0b 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -216,6 +216,12 @@ static void __init mrst_setup_boot_clock(void)
 		setup_boot_APIC_clock();
 };
 
+/* MID systems don't have i8042 controller */
+static int mrst_i8042_detect(void)
+{
+	return 0;
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
@@ -233,6 +239,7 @@ void __init x86_mrst_early_setup(void)
 	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
+	x86_platform.i8042_detect = mrst_i8042_detect;
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
-- 
1.7.0.4

