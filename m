Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab2KZWtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:49:05 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:16581
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab2KZWs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:48:57 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0ME4A1F-01-F9V-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 5/5] perf, amd: Use proper naming scheme for AMD bit field definitions
Date: Mon, 26 Nov 2012 16:48:31 -0600
Message-ID: <1353970111-4508-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353970111-4508-1-git-send-email-jacob.shin@amd.com>
References: <1353970111-4508-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update these AMD bit field names to be consistent with naming
convention followed by the rest of the file.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/perf_event.h    |    4 ++--
 arch/x86/kernel/cpu/perf_event_amd.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 63aba8f..57cb634 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -30,8 +30,8 @@
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
 #define AMD64_EVENTSEL_INT_CORE_ENABLE			(1ULL << 36)
-#define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
-#define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
+#define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
+#define AMD64_EVENTSEL_HOSTONLY				(1ULL << 41)
 
 #define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT		37
 #define AMD64_EVENTSEL_INT_CORE_SEL_MASK		\
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 5e3a6a3..0faa35f 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -188,9 +188,9 @@ static int amd_core_hw_config(struct perf_event *event)
 		event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
 				      ARCH_PERFMON_EVENTSEL_OS);
 	else if (event->attr.exclude_host)
-		event->hw.config |= AMD_PERFMON_EVENTSEL_GUESTONLY;
+		event->hw.config |= AMD64_EVENTSEL_GUESTONLY;
 	else if (event->attr.exclude_guest)
-		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
+		event->hw.config |= AMD64_EVENTSEL_HOSTONLY;
 
 	return 0;
 }
@@ -429,7 +429,7 @@ static void amd_pmu_cpu_starting(int cpu)
 	struct amd_nb *nb;
 	int i, nb_id;
 
-	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
+	cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
 
 	if (boot_cpu_data.x86_max_cores < 2)
 		return;
@@ -782,7 +782,7 @@ void amd_pmu_disable_virt(void)
 	 * SVM is disabled the Guest-only bits still gets set and the counter
 	 * will not count anything.
 	 */
-	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
+	cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
 
 	/* Reload all events */
 	x86_pmu_disable_all();
-- 
1.7.9.5


