Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2FRLbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:31:13 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36025 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2FRLbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:31:10 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [RFC PATCH 8/8] ARM: vmlinux.lds: Setup correct entry point to physical address
Date: Mon, 18 Jun 2012 13:30:11 +0200
Message-Id: <1340019011-18642-9-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linker script setups entry point to virtual address.

Signed-off-by: Michal Simek <monstr@monstr.eu>

---
Not sure what is the reason to setup entry point to virtual address.
---
 arch/arm/kernel/vmlinux.lds.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index b996bc0..de43b01 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -39,7 +39,7 @@
 #endif
 
 OUTPUT_ARCH(arm)
-ENTRY(stext)
+ENTRY(arm_start)
 
 #ifndef __ARMEB__
 jiffies = jiffies_64;
@@ -83,8 +83,10 @@ SECTIONS
 
 #ifdef CONFIG_XIP_KERNEL
 	. = XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR);
+	arm_start = . ;
 #else
 	. = PAGE_OFFSET + TEXT_OFFSET;
+	arm_start = CONFIG_PHYS_OFFSET + TEXT_OFFSET;
 #endif
 	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {
 		_text = .;
-- 
1.7.0.4

