Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab2EPHLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:11:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:57963 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342Ab2EPHLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:11:21 -0400
From: <jgq516@gmail.com>
To: <steve.glendinning@smsc.com>, <gregkh@linuxfoundation.org>
CC: <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jgq516@gmail.com>
Subject: [PATCH 1/1] smsc95xx: add FLAG_POINTTOPOINT flag for driver_info
Date: Wed, 16 May 2012 16:01:42 +0800
Message-ID: <1337155302-26244-1-git-send-email-jgq516@gmail.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

commit c26134 introduced FLAG_POINTTOPOINT flag for USB ethernet devices
which possibly use "usb%d" names, add this flag to make sure pandaboard
can mount nfs with smsc95xx NIC.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
---
 drivers/net/usb/smsc95xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 94ae669..e158288 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1192,7 +1192,8 @@ static const struct driver_info smsc95xx_info = {
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,
 	.status		= smsc95xx_status,
-	.flags		= FLAG_ETHER | FLAG_SEND_ZLP | FLAG_LINK_INTR,
+	.flags		= FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_SEND_ZLP |
+			  FLAG_LINK_INTR,
 };
 
 static const struct usb_device_id products[] = {
-- 
1.7.3

