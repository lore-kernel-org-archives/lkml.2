Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1I1Xbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:31:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1Wia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:26 2011
Message-Id: <20110928220126.311495052@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Smith <eric@brouhaha.com>
Subject: [010/244] 8250_pci: add support for Rosewill RC-305 4x serial port card
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Smith <eric@brouhaha.com>

commit 44178176ecc55ad370b837dd2c4b4b8bed1e3823 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/8250_pci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -3886,7 +3886,7 @@ static struct pci_device_id serial_pci_t
 		0, 0, pbn_b0_1_115200 },
 
 	/*
-	 * Best Connectivity PCI Multi I/O cards
+	 * Best Connectivity and Rosewill PCI Multi I/O cards
 	 */
 
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
@@ -3894,6 +3894,10 @@ static struct pci_device_id serial_pci_t
 		0, 0, pbn_b0_1_115200 },
 
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+		0xA000, 0x3002,
+		0, 0, pbn_b0_bt_2_115200 },
+
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
 		0xA000, 0x3004,
 		0, 0, pbn_b0_bt_4_115200 },
 	/* Intel CE4100 */


