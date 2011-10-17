Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1JQPvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:51:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1JQPvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:51:37 -0400
From: Grant Grundler <grundler@chromium.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        Freddy Xin <freddy@asix.com.tw>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH] NET: asix: fix ethtool -e for AX88178 USB dongle
Date: Mon, 17 Oct 2011 08:51:06 -0700
Message-Id: <1318866666-956-1-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ethtool -e ethX" dumps EEPROM data. Patch sets EEPROM length for device.
Ethtool works alot better when the kernel believes the length is > 0.

From: Allan Chou <allan@asix.com.tw>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index 66e5ccb..03a1621 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1399,6 +1399,9 @@ static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 	int ret;
 	u8 buf[ETH_ALEN];
 	u32 phyid;
+	struct asix_data *data = (struct asix_data *)&dev->data;
+
+	data->eeprom_len = AX88772_EEPROM_LEN;
 
 	usbnet_get_endpoints(dev,intf);
 
-- 
1.7.2.3

