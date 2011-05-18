Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1ERXcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:32:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:41524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab1ERXb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:31:58 -0400
X-ExtLoop1: 1
Message-Id: <20110518233158.089978277@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:39 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 9/9] x86, ioapic: consolidate mp_ioapic_routing[] into struct ioapic
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=add_pin_programmed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -89,6 +89,7 @@ static struct ioapic {
 	struct mpc_ioapic mp_config;
 	/* IO APIC gsi routing info */
 	struct mp_ioapic_gsi  gsi_config;
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
@@ -1356,10 +1357,6 @@ static void setup_ioapic_irq(int apic_id
 	ioapic_write_entry(apic_id, pin, entry);
 }
 
-static struct {
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-} mp_ioapic_routing[MAX_IO_APICS];
-
 static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
 {
 	if (idx != -1)
@@ -3540,14 +3537,14 @@ int io_apic_setup_irq_pin_once(unsigned 
 	int ret;
 
 	/* Avoid redundant programming */
-	if (test_bit(pin, mp_ioapic_routing[id].pin_programmed)) {
+	if (test_bit(pin, ioapics[id].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
 			 mpc_ioapic_id(id), pin);
 		return 0;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
-		set_bit(pin, mp_ioapic_routing[id].pin_programmed);
+		set_bit(pin, ioapics[id].pin_programmed);
 	return ret;
 }
 


