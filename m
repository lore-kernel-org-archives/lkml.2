Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1BIKhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:37:38 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58133 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1BIKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:37:36 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/8] intel_mid_ssp_spi: Add chip definitions
To: spi-devel-general@lists.sourceforge.net, russ.gorby@intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Wed, 09 Feb 2011 10:08:47 +0000
Message-ID: <20110209100838.555.90298.stgit@bob.linux.org.uk>
In-Reply-To: <20110209100231.555.90520.stgit@bob.linux.org.uk>
References: <20110209100231.555.90520.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The quirk tweaks so far are sufficient for us to support master mode on all
the devices. Put the PCI identifiers back. If they are in use for other
things the vendor bits will ensure the driver doesn't claim the wrong ones.

Add the missing MODULE tag so we can do autoloading

Based on previous generic driver work by Mathieu SOULARD
<mathieux.soulard@intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/spi/intel_mid_ssp_spi.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/drivers/spi/intel_mid_ssp_spi.c b/drivers/spi/intel_mid_ssp_spi.c
index 6435adc..c8cd3bb 100644
--- a/drivers/spi/intel_mid_ssp_spi.c
+++ b/drivers/spi/intel_mid_ssp_spi.c
@@ -1574,9 +1574,14 @@ static const struct dev_pm_ops intel_mid_ssp_spi_pm = {
 };
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
+	{ PCI_VDEVICE(INTEL, 0x0815),
+			QUIRKS_PLATFORM_MRST | QUIRKS_BIT_BANGING },
 	{ PCI_VDEVICE(INTEL, 0x0816) },
+	{ PCI_VDEVICE(INTEL, 0x0825) },
+	{ PCI_VDEVICE(INTEL, 0x0832) },
 	{ }
 };
+MODULE_DEVICE_TABLE(pci, pci_ids);
 
 static struct pci_driver intel_mid_ssp_spi_driver = {
 	.driver = {

