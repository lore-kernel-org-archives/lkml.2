Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1IDK0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:26:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33421 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1IDK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:21 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 05/12] staging: et131x: remove calls to netif_carrier_[on|off] from et131x_mii_check
Date: Sun,  4 Sep 2011 11:24:36 +0100
Message-Id: <1315131883-11068-6-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As et131x_adjust_link is called from the phydev in response to a netif_carrier_[on|off], and is the only caller of et131x_mii_check, we don't need to call netif_carrier_[on|off] again.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 0fccb86..6c3ceed 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -452,7 +452,6 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 	if (bmsr_ints & BMSR_LSTATUS) {
 		if (bmsr & BMSR_LSTATUS) {
 			adapter->boot_coma = 20;
-			netif_carrier_on(adapter->netdev);
 		} else {
 			dev_warn(&adapter->pdev->dev,
 			    "Link down - cable problem ?\n");
@@ -475,8 +474,6 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 				et131x_mii_write(adapter, 0x12, register18);
 			}
 
-			netif_carrier_off(adapter->netdev);
-
 			/* Free the packets being actively sent & stopped */
 			et131x_free_busy_send_packets(adapter);
 
-- 
1.7.6

