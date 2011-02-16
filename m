Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1BPNsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:48:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:40014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1BPNsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:48:51 -0500
Date: Wed, 16 Feb 2011 13:48:26 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1296664860-10886-4-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Add new AMD family 15h msrs to perfctr reservation code
Message-ID: <tip-69d8e1e8ac0a7d829f1c0fd5bd07eb3022d9a1a0@git.kernel.org>
Git-Commit-ID: 69d8e1e8ac0a7d829f1c0fd5bd07eb3022d9a1a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:48:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69d8e1e8ac0a7d829f1c0fd5bd07eb3022d9a1a0
Gitweb:     http://git.kernel.org/tip/69d8e1e8ac0a7d829f1c0fd5bd07eb3022d9a1a0
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 2 Feb 2011 17:40:58 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:50 +0100

perf, x86: Add new AMD family 15h msrs to perfctr reservation code

This patch allows the reservation of perfctrs with new msr addresses
introduced for AMD cpu family 15h (0xc0010200/0xc0010201, etc).

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1296664860-10886-4-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
