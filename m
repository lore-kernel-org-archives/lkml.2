Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0KXNT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:19:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40094 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab0KXNTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:19:24 -0500
From: Borislav Petkov <bp@amd64.org>
To: Dave Jones <davej@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Neil Brown <neilb@suse.de>,
        <x86@kernel.org>, cpufreq@vger.kernel.org,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Thomas Renninger <trenn@suse.de>,
        Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [PATCH 1/2] x86, powernow-k8: Fixup missing _PSS objects message
Date: Wed, 24 Nov 2010 14:19:00 +0100
Message-Id: <1290604741-25151-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <20101124131303.GA24892@aftab>
References: <20101124131303.GA24892@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

_PSS objects can also be missing if Cool'N'Quiet is disabled in the
BIOS. Add that to the FW_BUG message for the user to try before updating
her BIOS. Fix formatting.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 491977b..d2e53ac 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1247,12 +1247,15 @@ static void __cpuinit powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
 	init_on_cpu->rc = 0;
 }
 
+static const char missing_pss_msg[] =
+	KERN_ERR
+	FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
+	FW_BUG PFX "First, make sure Cool'N'Quiet is enabled in the BIOS.\n"
+	FW_BUG PFX "If that doesn't help, try upgrading your BIOS.\n";
+
 /* per CPU init entry point to the driver */
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
-	static const char ACPI_PSS_BIOS_BUG_MSG[] =
-		KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
-		FW_BUG PFX "Try again with latest BIOS.\n";
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
 	int rc;
@@ -1280,7 +1283,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
-			printk_once(ACPI_PSS_BIOS_BUG_MSG);
+			printk_once(missing_pss_msg);
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
-- 
1.7.3.1.50.g1e633

