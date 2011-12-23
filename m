Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1LWNYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:24:45 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:25077
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132Ab1LWNYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:24:41 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWNRWZ-02-60W-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf, x86: Fix raw_spin_unlock_irqrestore() usage
Date: Fri, 23 Dec 2011 14:24:25 +0100
Message-ID: <1324646665-13334-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use raw_spin_unlock_irqrestore() as equivalent to
raw_spin_lock_irqsave().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2c3bf53..31286bc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1169,7 +1169,7 @@ again:
 		 */
 		c = &unconstrained;
 	} else if (intel_try_alt_er(event, orig_idx)) {
-		raw_spin_unlock(&era->lock);
+		raw_spin_unlock_irqrestore(&era->lock, flags);
 		goto again;
 	}
 	raw_spin_unlock_irqrestore(&era->lock, flags);
-- 
1.7.8


