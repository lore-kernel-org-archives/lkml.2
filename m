Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1DQWq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 18:46:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49520 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1DQWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 18:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PFEomQVUJJdNIMNt4TEV650fM7kFbW2pkfRkHvlJMDPXl4wbnPoa/XbDPaH3pz34VR
         YOe9GsYqKQ8vgxESCdQR8Ktis+ut4a1nftCrRwJk5ucKF4xOUMyudWpiCyhzutwsB7/N
         id2c5yI4VLLBvKLbmSmYwYnh6SW8fdjCodtlw=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH 1/1] drivers/net/usb/usbnet.c: Use FIELD_SIZEOF macro in usbnet_init() function.
Date: Sun, 17 Apr 2011 19:46:04 -0300
Message-Id: <3f3e63ecef46abc5d23053c051b3fef52104cbe7.1303080236.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.5.rc2.4.g4d8b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/net/usb/usbnet.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 069c1cf..7bc9852 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1529,9 +1529,9 @@ EXPORT_SYMBOL_GPL(usbnet_resume);
 
 static int __init usbnet_init(void)
 {
-	/* compiler should optimize this out */
-	BUILD_BUG_ON (sizeof (((struct sk_buff *)0)->cb)
-			< sizeof (struct skb_data));
+	/* Compiler should optimize this out. */
+	BUILD_BUG_ON(
+		FIELD_SIZEOF(struct sk_buff, cb) < sizeof(struct skb_data));
 
 	random_ether_addr(node_id);
 	return 0;
-- 
1.7.5.rc2.4.g4d8b3

