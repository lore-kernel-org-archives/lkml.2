Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab0ILSQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:16:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65474 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0ILSQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fPL8CbdTRuis5l+VP5EW13YAuQY67b1Vd14HF1H2GwSJL3gnju6/jHJ4kXC5y2xDa9
         6EdoRrUX4DNXvTHGLVHuPFUoD1GKj37oIliKo7xFfyYvwaGqBF5IyprSZU7ZXZ7xJUae
         TaHLeI1W7l1CnBTNQVt7yzfVbRDUJRDhUrotE=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2] uwb: use '%pM' format to print MAC address
Date: Sun, 12 Sep 2010 21:16:26 +0300
Message-Id: <1284315386-27054-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/uwb/address.c    |    5 +----
 drivers/uwb/wlp/wss-lc.c |    7 ++-----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/uwb/address.c b/drivers/uwb/address.c
index 9733213..8739c4f 100644
--- a/drivers/uwb/address.c
+++ b/drivers/uwb/address.c
@@ -363,10 +363,7 @@ size_t __uwb_addr_print(char *buf, size_t buf_size, const unsigned char *addr,
 {
 	size_t result;
 	if (type)
-		result = scnprintf(buf, buf_size,
-				  "%02x:%02x:%02x:%02x:%02x:%02x",
-				  addr[0], addr[1], addr[2],
-				  addr[3], addr[4], addr[5]);
+		result = scnprintf(buf, buf_size, "%pM", addr);
 	else
 		result = scnprintf(buf, buf_size, "%02x:%02x",
 				  addr[1], addr[0]);
diff --git a/drivers/uwb/wlp/wss-lc.c b/drivers/uwb/wlp/wss-lc.c
index a005d2a..67872c8 100644
--- a/drivers/uwb/wlp/wss-lc.c
+++ b/drivers/uwb/wlp/wss-lc.c
@@ -791,11 +791,8 @@ int wlp_wss_prep_hdr(struct wlp *wlp, struct wlp_eda_node *eda_entry,
 	} else {
 		if (printk_ratelimit())
 			dev_err(dev, "WLP: Destination neighbor (Ethernet: "
-				"%02x:%02x:%02x:%02x:%02x:%02x, Dev: "
-				"%02x:%02x) is not connected. \n", eth_addr[0],
-				eth_addr[1], eth_addr[2], eth_addr[3],
-				eth_addr[4], eth_addr[5], dev_addr->data[1],
-				dev_addr->data[0]);
+				"%pM, Dev: %02x:%02x) is not connected.\n",
+				eth_addr, dev_addr->data[1], dev_addr->data[0]);
 		result = -EINVAL;
 	}
 	return result;
-- 
1.7.2.2

