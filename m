Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab3AJBJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:09:31 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:54570
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932323Ab3AJBJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:09:28 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MGDXVH-02-0OG-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to fall back to acpi-cpufreq and it is unavailable.
Date: Wed, 9 Jan 2013 19:09:21 -0600
Message-ID: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in reference to bug#:51741. (https://bugzilla.kernel.org/show_bug.cgi?id=51741)
powernow-k8 falls back to acpi-cpufreq if CPU is not supported. However, it states that acpi-cpufreq
has taken over even if acpi-cpufreq is not compiled in. This patch rewords the warning message to
clarify that the CPU is unsupported and prints a warning message when there is no acpi-cpufreq
present.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/cpufreq/powernow-k8.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 056faf6..6fa58b4 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1256,7 +1256,15 @@ static int __cpuinit powernowk8_init(void)
 	int rv;
 
 	if (static_cpu_has(X86_FEATURE_HW_PSTATE)) {
-		pr_warn(PFX "this CPU is not supported anymore, using acpi-cpufreq instead.\n");
+		pr_warn(PFX
+			"this CPU is not supported anymore, use acpi-cpufreq instead"
+			"Look for message from acpi-cpufreq to ensure it is loaded."
+			".\n");
+#ifndef CONFIG_X86_ACPI_CPUFREQ
+	pr_warn(PFX "acpi-cpufreq is disabled."
+		"Enable it in the config options to get frequency scaling.\n");
+	return -ENODEV;
+#endif
 		request_module("acpi-cpufreq");
 		return -ENODEV;
 	}
-- 
1.7.10.4


