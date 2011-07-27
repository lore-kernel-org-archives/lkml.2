Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1G0Co7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 22:44:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58884 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1G0Co5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 22:44:57 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
        Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH 1/2] ASIX: Simplify condition in rx_fixup()
Date: Wed, 27 Jul 2011 04:44:46 +0200
Message-Id: <1311734687-23551-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/net/usb/asix.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index 5250288..d5b62a4 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -314,10 +314,9 @@ static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	skb_pull(skb, 4);
 
 	while (skb->len > 0) {
-		if ((short)(header & 0x0000ffff) !=
-		    ~((short)((header & 0xffff0000) >> 16))) {
+		if ((header & 0xffff) != ((~header >> 16) & 0xffff))
 			netdev_err(dev->net, "asix_rx_fixup() Bad Header Length\n");
-		}
+
 		/* get the packet length */
 		size = (u16) (header & 0x0000ffff);
 
-- 
1.7.5.3

