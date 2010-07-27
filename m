Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0G0Xxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:53:41 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44606 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0G0XwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:00 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 08/15] Group declarations specific to NMI sourcing together
Date: Tue, 27 Jul 2010 17:50:56 -0600
Message-Id: <1280274663-9160-9-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index f337c22..cedcc61 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -115,19 +115,11 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static char expect_release;
 static unsigned long hpwdt_is_open;
 static unsigned int allow_kdump;
-static unsigned int hpwdt_nmi_sourcing;
-static unsigned int priority;		/* hpwdt at end of die_notify list */
 
 static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
 static unsigned long __iomem *hpwdt_timer_con;
 
-static DEFINE_SPINLOCK(rom_lock);
-
-static void *cru_rom_addr;
-
-static struct cmn_registers cmn_regs;
-
 static struct pci_device_id hpwdt_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },
@@ -135,6 +127,12 @@ static struct pci_device_id hpwdt_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
+static unsigned int hpwdt_nmi_sourcing;
+static unsigned int priority;		/* hpwdt at end of die_notify list */
+static DEFINE_SPINLOCK(rom_lock);
+static void *cru_rom_addr;
+static struct cmn_registers cmn_regs;
+
 extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
 						unsigned long *pRomEntry);
 
-- 
1.7.1

