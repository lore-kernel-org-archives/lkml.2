Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab2D0JJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 05:09:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43253 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2D0JJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 05:09:13 -0400
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
Date: Fri, 27 Apr 2012 11:08:31 +0200
Message-Id: <1335517711-6522-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User lautriv asked for belkin N-1 WLAN device support on IRC.

Further informations from lautriv:
* marvell 80W8031, card-id 11ab:2a02
* Debian/sid 3.2.x

On [1] I found a report by Jim Cromie concerning same PCI device-id:

00:0e.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
88W8361 [TopDog] 802.11n Wireless [11ab:2a02] (rev 03)
	Subsystem: Marvell Technology Group Ltd. 88W8361 [TopDog] 802.11n Wireless [11ab:2a02]

So, let's add 0x2a02 to PCI device table.

[1] http://www.spinics.net/lists/newbies/msg46601.html

Cc: stable@vger.kernel.org
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/wireless/mwl8k.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b48674b..16f0a9a 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5264,6 +5264,7 @@ MODULE_FIRMWARE("mwl8k/fmimage_8366.fw");
 MODULE_FIRMWARE(MWL8K_8366_AP_FW(MWL8K_8366_AP_FW_API));
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
+	{ PCI_VDEVICE(MARVELL, 0x2a02), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a0a), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a0c), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a24), .driver_data = MWL8363, },
-- 
1.7.9.5

