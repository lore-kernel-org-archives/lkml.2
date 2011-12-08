Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1LHAmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:42:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:13722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab1LHAlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:41:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84106919"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/10] x86: autoload microcode driver on Intel and AMD systems
Date: Wed,  7 Dec 2011 16:41:21 -0800
Message-Id: <1323304882-27953-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Don't try to describe the actual models for now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/microcode_core.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9d46f5e..51016ad 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -86,6 +86,7 @@
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
+#include <asm/cpu_device_id.h>
 
 MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
@@ -502,6 +503,20 @@ static struct notifier_block __refdata mc_cpu_notifier = {
 	.notifier_call	= mc_cpu_callback,
 };
 
+#ifdef MODULE
+/* Autoload on Intel and AMD systems */
+static struct x86_cpu_id microcode_id[] = {
+#ifdef CONFIG_MICROCODE_INTEL
+       { X86_VENDOR_INTEL, X86_VENDOR_ANY, X86_MODEL_ANY, },
+#endif
+#ifdef CONFIG_MICROCODE_AMD
+       { X86_VENDOR_AMD, X86_VENDOR_ANY, X86_MODEL_ANY, },
+#endif
+       {}
+};
+MODULE_DEVICE_TABLE(x86cpu, microcode_id);
+#endif
+
 static int __init microcode_init(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
-- 
1.7.4.4

