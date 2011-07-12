Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab1GLE7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 00:59:20 -0400
Received: from mx1.brouhaha.com ([64.62.206.9]:34524 "EHLO mx1.brouhaha.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab1GLE7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 00:59:18 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jul 2011 00:59:18 EDT
Message-ID: <4E1BD339.5060905@brouhaha.com>
Date: Mon, 11 Jul 2011 22:53:13 -0600
From: Eric Smith <eric@brouhaha.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [patch 1/1] 8250_pci: add support for Rosewill RC-305 4x serial port
 card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Smith <eric@brouhaha.com>

This patch adds support for the Rosewill RC-305 four-port PCI serial
card, and probably any other four-port serial cards based on the
Moschip MCS9865 chip, assuming that the EEPROM on the card was
programmed in accordance with Table 6 of the MCS9865 EEPROM
Application Note version 0.3 dated 16-May-2008, available from the
Moschip web site (registration required).

This patch is based on an earlier patch [1] for the SYBA 6x serial
port card by Ira W. Snyder.

[1]: http://www.gossamer-threads.com/lists/linux/kernel/1162435

Signed-off-by: Eric Smith <eric@brouhaha.com>
---
This patch has been tested with the 3.0-rc7 and 2.6.35 kernels, though for
the 2.6.35 kernel the location of the driver source file is in 
drivers/serial
rather than drivers/tty/serial.

diff -uprN -X linux-3.0-rc7/Documentation/dontdiff 
linux-3.0-rc7/drivers/tty/serial/8250_pci.c 
linux-3.0-rc7-rosewill/drivers/tty/serial/8250_pci.c
--- linux-3.0-rc7/drivers/tty/serial/8250_pci.c 2011-07-11 
17:51:52.000000000 -0600
+++ linux-3.0-rc7-rosewill/drivers/tty/serial/8250_pci.c        
2011-07-11 22:24:59.000000000 -0600
@@ -3886,7 +3886,7 @@ static struct pci_device_id serial_pci_t
                 0, 0, pbn_b0_1_115200 },

         /*
-        * Best Connectivity PCI Multi I/O cards
+        * Best Connectivity and Rosewill PCI Multi I/O cards
          */

         {       PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
@@ -3894,6 +3894,10 @@ static struct pci_device_id serial_pci_t
                 0, 0, pbn_b0_1_115200 },

         {       PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+               0xA000, 0x3002,
+               0, 0, pbn_b0_bt_2_115200 },
+
+       {       PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
                 0xA000, 0x3004,
                 0, 0, pbn_b0_bt_4_115200 },
         /* Intel CE4100 */

