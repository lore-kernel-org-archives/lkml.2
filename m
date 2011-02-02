Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1BBQqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:46:36 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:9847 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab1BBQqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:46:34 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG019F-01-OAG-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/5] perf, x86: Add new AMD family 15h msrs to perfctr reservation code
Date: Wed, 2 Feb 2011 17:40:58 +0100
Message-ID: <1296664860-10886-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the reservation of perfctrs with new msr addresses
introduced for AMD cpu family 15h (0xc0010200/0xc0010201, etc).

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index d5a2366..966512b 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -46,6 +46,8 @@ static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
 	/* returns the bit offset of the performance counter register */
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
+		if (msr >= MSR_F15H_PERF_CTR)
+			return (msr - MSR_F15H_PERF_CTR) >> 1;
 		return msr - MSR_K7_PERFCTR0;
 	case X86_VENDOR_INTEL:
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
@@ -70,6 +72,8 @@ static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
 	/* returns the bit offset of the event selection register */
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
+		if (msr >= MSR_F15H_PERF_CTL)
+			return (msr - MSR_F15H_PERF_CTL) >> 1;
 		return msr - MSR_K7_EVNTSEL0;
 	case X86_VENDOR_INTEL:
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-- 
1.7.3.4


