Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2EHOTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:19:37 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44470 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2EHOTf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 8 May 2012 10:19:35 -0400
Message-Id: <4FA947910200007800082470@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 08 May 2012 15:19:29 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <sp@numascale.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix section annotation of acpi_map_cpu2node()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 943bc7e110f269f88dc92bbf249adbd384d35f1c added __cpuinitdata
here, while for functions __cpuinit should be used.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Steffen Persvold <sp@numascale.com>

---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.4-rc6/arch/x86/kernel/acpi/boot.c
+++ 3.4-rc6-x86-acpi_map_cpu2node-section/arch/x86/kernel/acpi/boot.c
@@ -593,7 +593,7 @@ void __init acpi_set_irq_model_ioapic(vo
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
 
-static void __cpuinitdata acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int nid;



