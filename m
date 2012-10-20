Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2JTIYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 04:24:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab2JTIYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 04:24:17 -0400
Date: Sat, 20 Oct 2012 01:23:58 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-a05123bdd1b9ba961ed262864924a5b3ee81afe8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        penberg@kernel.org, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, penberg@kernel.org, tglx@linutronix.de
In-Reply-To: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
References: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Disable uncore on virtualized CPUs
Git-Commit-ID: a05123bdd1b9ba961ed262864924a5b3ee81afe8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 20 Oct 2012 01:24:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a05123bdd1b9ba961ed262864924a5b3ee81afe8
Gitweb:     http://git.kernel.org/tip/a05123bdd1b9ba961ed262864924a5b3ee81afe8
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 21 Aug 2012 17:08:37 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 20 Oct 2012 10:07:02 +0200

perf/x86: Disable uncore on virtualized CPUs

Initializing uncore PMU on virtualized CPU may hang the kernel.
This is because kvm does not emulate the entire hardware. Thers
are lots of uncore related MSRs, making kvm enumerate them all
is a non-trival task. So just disable uncore on virtualized CPU.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Tested-by: Pekka Enberg <penberg@kernel.org>
Cc: a.p.zijlstra@chello.nl
Cc: eranian@google.com
Cc: andi@firstfloor.org
Cc: avi@redhat.com
Link: http://lkml.kernel.org/r/1345540117-14164-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 99d96a4..5df8d32 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2926,6 +2926,9 @@ static int __init intel_uncore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return -ENODEV;
 
+	if (cpu_has_hypervisor)
+		return -ENODEV;
+
 	ret = uncore_pci_init();
 	if (ret)
 		goto fail;
