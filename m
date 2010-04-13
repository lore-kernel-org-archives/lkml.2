Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0DMLHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:07:04 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:54848 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0DMLHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:07:00 -0400
Date: Tue, 13 Apr 2010 13:05:32 +0200
From: Anders Larsen <al@alarsen.net>
Subject: [at91] Save power by disabling the processor clock when CPU is idle
To: patches@arm.linux.org.uk
Cc: Andrew Victor <avictor.za@gmail.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.3.14
Message-Id: <1271156732l.25331l.7l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the processor clock when the CPU is idle.

This saves much more power than merely entering 'Wait for Interrupt' mode.
Since JTAG-debugging doesn't work when the processor clock is switched off,
make it conditional on CONFIG_DEBUG_KERNEL.

Signed-off-by: Anders Larsen <al@alarsen.net>
Cc: Andrew Victor <avictor.za@gmail.com>
---
KernelVersion: 2.6.33

 arch/arm/mach-at91/include/mach/system.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


Index: b/arch/arm/mach-at91/include/mach/system.h
===================================================================
--- a/arch/arm/mach-at91/include/mach/system.h
+++ b/arch/arm/mach-at91/include/mach/system.h
@@ -24,21 +24,24 @@
 #include <mach/hardware.h>
 #include <mach/at91_st.h>
 #include <mach/at91_dbgu.h>
+#include <mach/at91_pmc.h>
 
 static inline void arch_idle(void)
 {
+#ifndef CONFIG_DEBUG_KERNEL
 	/*
 	 * Disable the processor clock.  The processor will be automatically
 	 * re-enabled by an interrupt or by a reset.
 	 */
-//	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-
+	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
+#else
 	/*
 	 * Set the processor (CP15) into 'Wait for Interrupt' mode.
 	 * Unlike disabling the processor clock via the PMC (above)
 	 *  this allows the processor to be woken via JTAG.
 	 */
 	cpu_do_idle();
+#endif
 }
 
 void (*at91_arch_reset)(void);

