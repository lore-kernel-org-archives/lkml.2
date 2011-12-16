Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1LPTv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:51:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab1LPTus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:59 2011
Message-Id: <20111216194559.060802489@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [31/53] ARM: 7204/1: arch/arm/kernel/setup.c: initialize arm_dma_zone_size earlier
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Patard <arnaud.patard@rtp-net.org>

commit 9811ccdfa94b4773c8030569bd8ec75eafa485ac upstream.

arm_dma_zone_size is used by arm_bootmem_free() which is called by
paging_init(). Thus it needs to be set before calling it.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/setup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -890,6 +890,12 @@ void __init setup_arch(char **cmdline_p)
 	machine_desc = mdesc;
 	machine_name = mdesc->name;
 
+#ifdef CONFIG_ZONE_DMA
+	if (mdesc->dma_zone_size) {
+		extern unsigned long arm_dma_zone_size;
+		arm_dma_zone_size = mdesc->dma_zone_size;
+	}
+#endif
 	if (mdesc->soft_reboot)
 		reboot_setup("s");
 
@@ -920,12 +926,6 @@ void __init setup_arch(char **cmdline_p)
 
 	tcm_init();
 
-#ifdef CONFIG_ZONE_DMA
-	if (mdesc->dma_zone_size) {
-		extern unsigned long arm_dma_zone_size;
-		arm_dma_zone_size = mdesc->dma_zone_size;
-	}
-#endif
 #ifdef CONFIG_MULTI_IRQ_HANDLER
 	handle_arch_irq = mdesc->handle_irq;
 #endif


