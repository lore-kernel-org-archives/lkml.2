Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1FPHBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45142 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab1FPHBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:45 -0400
X-Sasl-enc: Zs+V0UCS84fsEP4V1LGvcjBSbvwJQ+0Dvbg7LcMPShuP 1308207704
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:36 2011
Message-Id: <20110616000236.821876370@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <ffainelli@freebox.fr>,
        Grant Likely <grant.likely@secretlab.ca>,
        Maxime Bizon <mbizon@freebox.fr>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [80/89] x86: devicetree: Add missing early_init_dt_setup_initrd_arch
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 stub

From: Florian Fainelli <ffainelli@freebox.fr>

commit 977cb76d52e7aa040e18a84b29fe6fd80d79319b upstream.

This patch fixes the following build failure:

drivers/built-in.o: In function `early_init_dt_check_for_initrd':
/home/florian/dev/kernel/x86/linux-2.6-x86/drivers/of/fdt.c:571:
undefined reference to `early_init_dt_setup_initrd_arch'
make: *** [.tmp_vmlinux1] Error 1

which happens as soon as we enable initrd support on a x86 devicetree
platform such as Intel CE4100.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Bizon <mbizon@freebox.fr>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Link: http://lkml.kernel.org/r/201106061015.50039.ffainelli@freebox.fr
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/devicetree.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/of_pci.h>
+#include <linux/initrd.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
@@ -98,6 +99,16 @@ void * __init early_init_dt_alloc_memory
 	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
 }
 
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+					    unsigned long end)
+{
+	initrd_start = (unsigned long)__va(start);
+	initrd_end = (unsigned long)__va(end);
+	initrd_below_start_ok = 1;
+}
+#endif
+
 void __init add_dtb(u64 data)
 {
 	initial_dtb = data + offsetof(struct setup_data, data);


