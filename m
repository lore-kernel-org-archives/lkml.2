Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2FTSrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:47:04 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:5105
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659Ab2FTSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:46:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5XIU5-01-38W-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/4] perf, x86: Improve debug output in check_hw_exists()
Date: Wed, 20 Jun 2012 20:46:36 +0200
Message-ID: <1340217996-2254-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
References: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might be of interest which perfctr msr failed.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bb340dc..8d29a35 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -178,7 +178,7 @@ static void release_pmc_hardware(void) {}
 
 static bool check_hw_exists(void)
 {
-	u64 val, val_new = 0;
+	u64 val, val_new = ~0;
 	int i, reg, ret = 0;
 
 	/*
@@ -229,6 +229,7 @@ bios_fail:
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
+	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
 
 	return false;
 }
-- 
1.7.8.4


