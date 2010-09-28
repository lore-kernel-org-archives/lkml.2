Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0I1NRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:17:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:41747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab0I1NR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:17:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,247,1283756400"; 
   d="scan'208";a="661907876"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] x86/mrst: parse SFI timer table for all timer configs
To: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 28 Sep 2010 13:29:18 +0100
Message-ID: <20100928122853.9513.87937.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Penwell has APB timer based watchdog timers, it requires platform code to parse
SFI MTMR tables in order to claim its timer.

This patch will always parse SFI MTMR regardless of system timer configuration
choices. Otherwise, SFI MTMR table may not get parsed if running on Medfield
with always-on local APIC timers and constant TSC. Watchdog timer driver will not
get a timer to use.

(Prerequisite to merging the Intel MID watchdog support)

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/kernel/mrst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 0bf74c5..2abbcaf 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -218,6 +218,7 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
 void __init mrst_time_init(void)
 {
+	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	switch (mrst_timer_options) {
 	case MRST_TIMER_APBT_ONLY:
 		break;
@@ -233,7 +234,6 @@ void __init mrst_time_init(void)
 		return;
 	}
 	/* we need at least one APB timer */
-	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	pre_init_apic_IRQ0();
 	apbt_time_init();
 }

