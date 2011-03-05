Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1CEVyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 16:54:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1CEVyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 16:54:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pci@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe native features
Date: Sat, 5 Mar 2011 22:54:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103052254.48515.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After commit 415e12b2379239973feab91850b0dce985c6058a
(PCI/ACPI: Request _OSC control once for each root bridge (v3)) we
require MSI to be supported so that we use _OSC to request control
of PCIe native features (hotplug, AER, PME), but that appears to
be overkill and causes problems to happen on some systems.  For
this reason, request control of PCIe native features via _OSC
even if MSI support is not enabled.

Reported-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

Sarah, please test this patch on your machine causing PCIe hotplug
problems on top of the patch from https://patchwork.kernel.org/patch/612171/
and on top of 2.6.38-rc6 or later.

Thanks,
Rafael

---
 drivers/acpi/pci_root.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -50,8 +50,7 @@ static int acpi_pci_root_start(struct ac
 
 #define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
 				| OSC_ACTIVE_STATE_PWR_SUPPORT \
-				| OSC_CLOCK_PWR_CAPABILITY_SUPPORT \
-				| OSC_MSI_SUPPORT)
+				| OSC_CLOCK_PWR_CAPABILITY_SUPPORT)
 
 static const struct acpi_device_id root_device_ids[] = {
 	{"PNP0A03", 0},
