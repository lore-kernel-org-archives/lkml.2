Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1DPAgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 20:36:10 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:12947
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095Ab1DPAfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 20:35:45 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJPYZ9-01-0IY-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/4] perf, x86: Fix pre-defined cache-misses event for AMD family 15h cpus
Date: Sat, 16 Apr 2011 02:27:53 +0200
Message-ID: <1302913676-14352-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

With AMD cpu family 15h a unit mask was introduced for the Data Cache
Miss event (0x041/L1-dcache-load-misses). We need to enable bit 0
(first data cache miss or streaming store to a 64 B cache line) of
this mask to proper count data cache misses.

Now we set this bit for all families and models. In case a PMU does
not implement a unit mask for event 0x041 the bit is ignored.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 461f62b..4e16138 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -8,7 +8,7 @@ static __initconst const u64 amd_hw_cache_event_ids
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
+		[ C(RESULT_MISS)   ] = 0x0141, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
-- 
1.7.3.4


