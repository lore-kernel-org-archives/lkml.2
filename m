Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1GURQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:16:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1GURQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:16:33 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org
Subject: [PATCH 3/4] usb/host/pci-quirks.c: correct annotation of `ehci_dmi_nohandoff_table'
Date: Thu, 21 Jul 2011 13:16:20 -0400
Message-Id: <1311268581-20405-3-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
References: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ehci_bios_handoff() is marked __devinit, `ehci_dmi_nohandoff_table' should be
marked __devinitconst, not __initconst. This fixes the following section
mismatch:

WARNING: vmlinux.o(.devinit.text+0x4f08): Section mismatch in reference from the function ehci_bios_handoff() to the variable .init.rodata:ehci_dmi_nohandoff_table
The function __devinit ehci_bios_handoff() references a variable __initconst ehci_dmi_nohandoff_table.
If ehci_dmi_nohandoff_table is only used by ehci_bios_handoff then annotate ehci_dmi_nohandoff_table with a matching annotation.

Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index a9d3159..31ad147 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -535,7 +535,7 @@ static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
 	iounmap(base);
 }
 
-static const struct dmi_system_id __initconst ehci_dmi_nohandoff_table[] = {
+static const struct dmi_system_id __devinitconst ehci_dmi_nohandoff_table[] = {
 	{
 		/*  Pegatron Lucid (ExoPC) */
 		.matches = {
-- 
1.7.6.153.g78432

