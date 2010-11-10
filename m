Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0KJRKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:10:35 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46155 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab0KJRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:10:34 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/3] x86/mrst: add Moorestown specific reboot/shutdown support
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Nov 2010 16:50:08 +0000
Message-ID: <20101110164928.6365.94243.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alek Du <alek.du@intel.com>

Moorestowns needs to use a special IPC command to reboot or shutdown the
platform.

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)


diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 8705f6b..10fec10 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -35,6 +35,7 @@
 #include <asm/i8259.h>
 #include <asm/intel_scu_ipc.h>
 #include <asm/apb_timer.h>
+#include <asm/reboot.h>
 
 
 /*
@@ -268,6 +269,17 @@ static int mrst_i8042_detect(void)
 	return 0;
 }
 
+/* Reboot and power off are handled by the SCU on a MID device */
+static void mrst_power_off(void)
+{
+	intel_scu_ipc_simple_command(0xf1, 1);
+}
+
+static void mrst_reboot(void)
+{
+	intel_scu_ipc_simple_command(0xf1, 0);
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
@@ -293,6 +305,10 @@ void __init x86_mrst_early_setup(void)
 
 	legacy_pic = &null_legacy_pic;
 
+	/* Moorestown specific power_off/restart method */
+	pm_power_off = mrst_power_off;
+	machine_ops.emergency_restart  = mrst_reboot;
+
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;

