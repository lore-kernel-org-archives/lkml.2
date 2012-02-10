Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2BJWoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2BJWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:07 -0500
MIME-Version: 1.0
Message-Id: <20120210223441.477750667@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 13/55] firewire: ohci: add reset packet quirk for SB Audigy
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit d1bb399ad03c11e792f6dea198d3b1e23061f094 upstream.

The Audigy's SB1394 controller is actually from Texas Instruments
and has the same bus reset packet generation bug, so it needs the
same quirk entry.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/ohci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -262,6 +262,7 @@ static inline struct fw_ohci *fw_ohci(st
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
+#define PCI_DEVICE_ID_CREATIVE_SB1394	0x4001
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
 #define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
@@ -285,6 +286,9 @@ static const struct {
 	{PCI_VENDOR_ID_ATT, PCI_DEVICE_ID_AGERE_FW643, 6,
 		QUIRK_NO_MSI},
 
+	{PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_SB1394, PCI_ANY_ID,
+		QUIRK_RESET_PACKET},
+
 	{PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_FW, PCI_ANY_ID,
 		QUIRK_NO_MSI},
 


