Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0LBMpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 07:45:40 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37936 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab0LBMpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 07:45:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ku+UX/IFsN79N73FEo6WA2FkasWqs/x+pxLfrFE9ChOSvQGUyJItfLhRKU+Y5b9YJK
         +/zA6JU42GOBBbZMOTA0WgmZuHIwghHSKW+eH71vYBUJeAUQXFs2VsHhCNDgBF9fwr4C
         zm1ZE+crWTHHD5lsDHVew2924tTe9xoAieG24=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wireless: ray_cs: use '%pm' format option to print MAC
Date: Thu,  2 Dec 2010 14:45:07 +0200
Message-Id: <1291293908-29180-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ray_cs.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 2b1cbba..0764d1a 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1776,11 +1776,8 @@ static void ray_update_multi_list(struct net_device *dev, int all)
 		/* Copy the kernel's list of MC addresses to card */
 		netdev_for_each_mc_addr(ha, dev) {
 			memcpy_toio(p, ha->addr, ETH_ALEN);
-			dev_dbg(&link->dev,
-			      "ray_update_multi add addr %02x%02x%02x%02x%02x%02x\n",
-			      ha->addr[0], ha->addr[1],
-			      ha->addr[2], ha->addr[3],
-			      ha->addr[4], ha->addr[5]);
+			dev_dbg(&link->dev, "ray_update_multi add addr %pm\n",
+				ha->addr);
 			p += ETH_ALEN;
 			i++;
 		}
@@ -2015,11 +2012,8 @@ static irqreturn_t ray_interrupt(int irq, void *dev_id)
 				memcpy_fromio(&local->bss_id,
 					      prcs->var.rejoin_net_complete.
 					      bssid, ADDRLEN);
-				dev_dbg(&link->dev,
-				      "ray_cs new BSSID = %02x%02x%02x%02x%02x%02x\n",
-				      local->bss_id[0], local->bss_id[1],
-				      local->bss_id[2], local->bss_id[3],
-				      local->bss_id[4], local->bss_id[5]);
+				dev_dbg(&link->dev, "ray_cs new BSSID = %pm\n",
+					local->bss_id);
 				if (!sniffer)
 					authenticate(local);
 			}
-- 
1.7.2.3

