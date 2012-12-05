Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2LEQLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:11:40 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:10411 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947Ab2LEQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:11:38 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0MEKFN5-02-IW2-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <herrmann.der.user@googlemail.com>, <khali@linux-fr.org>,
        <linux@roeck-us.net>, <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <boris.ostrovsky@amd.com>
Subject: [PATCH v2] x86,AMD: Power driver support for AMD's family 16h processors
Date: Wed, 5 Dec 2012 06:12:42 -0500
Message-ID: <1354705962-5603-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add family 16h PCI ID to AMD's power driver to allow it report
power consumption on these processors.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 drivers/hwmon/fam15h_power.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 4f41104..34ab2a8 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -31,6 +31,9 @@ MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
 MODULE_AUTHOR("Andreas Herrmann <herrmann.der.user@googlemail.com>");
 MODULE_LICENSE("GPL");
 
+/* Family 16h Northbridge's function 4 PCI ID */
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
+
 /* D18F3 */
 #define REG_NORTHBRIDGE_CAP		0xe8
 
@@ -248,6 +251,7 @@ static void __devexit fam15h_power_remove(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(fam15h_power_id_table) = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
-- 
1.7.10.4


