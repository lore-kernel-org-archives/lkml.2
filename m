Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2FYLlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:41:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab2FYLlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:41:15 -0400
Date: Mon, 25 Jun 2012 04:40:41 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-357398e96d8c883b010379a7669df43ed0e2e32b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, zheng.z.yan@intel.com,
        tglx@linutronix.de
In-Reply-To: <20120620163927.GI5046@erda.amd.com>
References: <20120620163927.GI5046@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix section mismatch in uncore_pci_init(
 )
Git-Commit-ID: 357398e96d8c883b010379a7669df43ed0e2e32b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 25 Jun 2012 04:40:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  357398e96d8c883b010379a7669df43ed0e2e32b
Gitweb:     http://git.kernel.org/tip/357398e96d8c883b010379a7669df43ed0e2e32b
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 20 Jun 2012 18:39:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 25 Jun 2012 10:32:21 +0200

perf/x86: Fix section mismatch in uncore_pci_init()

Fix section mismatch in uncore_pci_init():

 WARNING: vmlinux.o(.init.text+0x9246): Section mismatch in reference from the function uncore_pci_init() to the function .devexit.text:uncore_pci_remove()
 The function __init uncore_pci_init() references
 a function __devexit uncore_pci_remove().
 [...]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: <a.p.zijlstra@chello.nl>
Cc: <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/20120620163927.GI5046@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 28a8413..6f43f95 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1313,7 +1313,7 @@ static int __devinit uncore_pci_add(struct intel_uncore_type *type,
 	return 0;
 }
 
-static void __devexit uncore_pci_remove(struct pci_dev *pdev)
+static void uncore_pci_remove(struct pci_dev *pdev)
 {
 	struct intel_uncore_box *box = pci_get_drvdata(pdev);
 	struct intel_uncore_pmu *pmu = box->pmu;
