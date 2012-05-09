Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab2EIGGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:06:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756529Ab2EIFxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:36 -0400
Message-Id: <20120509055044.108912893@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 104/167] [PATCH] hwmon: (fam15h_power) Fix pci_device_id array
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit c3e40a9972428d6e2d8e287ed0233a57a218c30f upstream.

pci_match_id() takes an *array* of IDs which must be properly zero-
terminated.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/fam15h_power.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 37a8fc9..e8e18ca 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -128,17 +128,20 @@ static bool __devinit fam15h_power_is_internal_node0(struct pci_dev *f4)
  * counter saturations resulting in bogus power readings.
  * We correct this value ourselves to cope with older BIOSes.
  */
+static DEFINE_PCI_DEVICE_TABLE(affected_device) = {
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ 0 }
+};
+
 static void __devinit tweak_runavg_range(struct pci_dev *pdev)
 {
 	u32 val;
-	const struct pci_device_id affected_device = {
-		PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) };
 
 	/*
 	 * let this quirk apply only to the current version of the
 	 * northbridge, since future versions may change the behavior
 	 */
-	if (!pci_match_id(&affected_device, pdev))
+	if (!pci_match_id(affected_device, pdev))
 		return;
 
 	pci_bus_read_config_dword(pdev->bus,
-- 
1.7.10



