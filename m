Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2K0OJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:09:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2K0OJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:09:41 -0500
From: Colin King <colin.king@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] PCI: Allow pcie_aspm=force to work even when FADT indicates it is unsupported
Date: Tue, 27 Nov 2012 14:09:40 +0000
Message-Id: <1354025380-19092-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/962038

Right now using pcie_aspm=force will not enable ASPM if the FADT indicates
ASPM is unsupported.  However, the semantics of force should probably allow
for this, especially as they did before the ASPM disable rework with commit
3c076351c4027a56d5005a39a0b518a4ba393ce2

This patch just skips the clearing of any ASPM setup that the firmware has
carried out on this bus if pcie_aspm=force is being used.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/pci/pcie/aspm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 213753b..449f257 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -773,6 +773,9 @@ void pcie_clear_aspm(struct pci_bus *bus)
 {
 	struct pci_dev *child;
 
+	if (aspm_force)
+		return;
+
 	/*
 	 * Clear any ASPM setup that the firmware has carried out on this bus
 	 */
-- 
1.8.0

