Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2IDIZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:25:46 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:5604 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384Ab2IDIZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:25:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9TGQJ-01-71N-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Renninger <trenn@suse.de>
CC: Matthew Garret <mjg@redhat.com>, <linux-pm@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 3/8 v2] cpufreq: Add warning message to powernow-k8
Date: Tue, 4 Sep 2012 10:28:04 +0200
Message-ID: <1346747289-8421-4-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq modules are often loaded from init scripts that assume that
all recent AMD systems will use powernow-k8.
To inform the user of the change of support and ease the transition
to acpi-cpufreq, emit a warning message.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 drivers/cpufreq/Kconfig.x86   | 3 ++-
 drivers/cpufreq/powernow-k8.c | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 8d12e37..b36ca1f 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -96,7 +96,8 @@ config X86_POWERNOW_K8
 	select CPU_FREQ_TABLE
 	depends on ACPI && ACPI_PROCESSOR
 	help
-	  This adds the CPUFreq driver for K8/K10 Opteron/Athlon64 processors.
+	  This adds the CPUFreq driver for K8/early Opteron/Athlon64 processors.
+	  Support for K10 and newer processors is now in acpi-cpufreq.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called powernow-k8.
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c0e8164..16c7fb6 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1560,6 +1560,9 @@ static int __cpuinit powernowk8_init(void)
 	if (!x86_match_cpu(powernow_k8_ids))
 		return -ENODEV;
 
+	if (static_cpu_has(X86_FEATURE_HW_PSTATE))
+		pr_warn(PFX "support for this CPU is deprecated, use acpi-cpufreq instead.\n");
+
 	for_each_online_cpu(i) {
 		int rc;
 		smp_call_function_single(i, check_supported_cpu, &rc, 1);
-- 
1.7.12


