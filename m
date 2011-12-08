Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1LHAlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:41:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:60089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab1LHAlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:41:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84106920"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/10] x86: Add a test module for cpu loading
Date: Wed,  7 Dec 2011 16:41:22 -0800
Message-Id: <1323304882-27953-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Not for merging, but useful for testing.

Not-Signed-off: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile        |    2 ++
 arch/x86/kernel/cpu/test-cpu-load.c |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/test-cpu-load.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6ab6aa2..1af7e7b 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -48,3 +48,5 @@ cpufeature = $(src)/../../include/asm/cpufeature.h
 targets += capflags.c
 $(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.pl FORCE
 	$(call if_changed,mkcapflags)
+
+obj-m					+= test-cpu-load.o
diff --git a/arch/x86/kernel/cpu/test-cpu-load.c b/arch/x86/kernel/cpu/test-cpu-load.c
new file mode 100644
index 0000000..497a764
--- /dev/null
+++ b/arch/x86/kernel/cpu/test-cpu-load.c
@@ -0,0 +1,19 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <asm/cpu_device_id.h>
+
+static struct x86_cpu_id microcode_id[] = {
+        { X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, },
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, microcode_id);
+
+static int start(void)
+{
+	printk("test-cpu-load loaded\n");
+	return 0;
+}
+
+module_init(start);
+
+
-- 
1.7.4.4

