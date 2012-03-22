Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2CVQtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:49:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2CVQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:49:48 -0400
From: Colin King <colin.king@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Allow pcie_aspm=force to work even when FADT indicates it is unsupported
Date: Thu, 22 Mar 2012 16:49:45 +0000
Message-Id: <1332434985-11522-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Right now using pcie_aspm=force will not enable ASPM if the FADT indicates
ASPM is unsupported.  However, the semantics of force should probably allow
for this, especially as they did before the ASPM disable rework with commit
3c076351c4027a56d5005a39a0b518a4ba393ce2

This patch just skips the clearing of any ASPM setup that the firmware has
carried out on this bus if pcie_aspm=force is being used.

BugLink: https://bugs.launchpad.net/ubuntu/+bug/962038

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/pci/pcie/aspm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 24f049e..e406429 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -783,6 +783,9 @@ void pcie_clear_aspm(struct pci_bus *bus)
 {
 	struct pci_dev *child;
 
+	if (aspm_force)
+		return;
+
 	/*
 	 * Clear any ASPM setup that the firmware has carried out on this bus
 	 */
-- 
1.7.9.1

