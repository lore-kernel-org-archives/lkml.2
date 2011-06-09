Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab1FINn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:43:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:40249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584Ab1FINn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:43:26 -0400
Date: Thu, 9 Jun 2011 13:43:04 GMT
From: tip-bot for Florian Fainelli <ffainelli@freebox.fr>
Message-ID: <tip-977cb76d52e7aa040e18a84b29fe6fd80d79319b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, mbizon@freebox.fr, tglx@linutronix.de,
        sebastian@breakpoint.cc, ffainelli@freebox.fr
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, mbizon@freebox.fr, tglx@linutronix.de,
        sebastian@breakpoint.cc, ffainelli@freebox.fr
In-Reply-To: <201106061015.50039.ffainelli@freebox.fr>
References: <201106061015.50039.ffainelli@freebox.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: devicetree: Add missing early_init_dt_setup_initrd_arch stub
Git-Commit-ID: 977cb76d52e7aa040e18a84b29fe6fd80d79319b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 13:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  977cb76d52e7aa040e18a84b29fe6fd80d79319b
Gitweb:     http://git.kernel.org/tip/977cb76d52e7aa040e18a84b29fe6fd80d79319b
Author:     Florian Fainelli <ffainelli@freebox.fr>
AuthorDate: Mon, 6 Jun 2011 10:15:49 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 15:39:43 +0200

x86: devicetree: Add missing early_init_dt_setup_initrd_arch stub

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
Cc: stable@kernel.org # 2.6.39
Link: http://lkml.kernel.org/r/201106061015.50039.ffainelli@freebox.fr
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/devicetree.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 690bc84..9aeb78a 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/of_pci.h>
+#include <linux/initrd.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
@@ -98,6 +99,16 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
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
