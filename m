Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab2EDU7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:59:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab2EDUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:48:57 -0400
Message-Id: <20120504204245.825317429@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 11/47] hwmon: (fam15h_power) Fix pci_device_id array
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit c3e40a9972428d6e2d8e287ed0233a57a218c30f upstream.

pci_match_id() takes an *array* of IDs which must be properly zero-
terminated.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/fam15h_power.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -128,17 +128,20 @@ static bool __devinit fam15h_power_is_in
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


