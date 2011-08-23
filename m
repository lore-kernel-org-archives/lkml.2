Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1HWWnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:43:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61972 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab1HWWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:13 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/8] [RESEND] staging: et131x: Removing commented out code implemented elsewhere
Date: Tue, 23 Aug 2011 23:40:36 +0100
Message-Id: <1314139240-869-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <1314139240-869-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function et131x_set_mac_addr() contains commented out code that has been moved to
et131x_change_mtu() in the same file.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_netdev.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 5fe3ec4..93ef9d5 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -593,7 +593,6 @@ int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 
 	/* Set the new MAC */
 	/* netdev->set_mac_address  = &new_mac; */
-	/* netdev->mtu = new_mtu; */
 
 	memcpy(netdev->dev_addr, address->sa_data, netdev->addr_len);
 
@@ -603,10 +602,6 @@ int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 	/* Free Rx DMA memory */
 	et131x_adapter_memory_free(adapter);
 
-	/* Set the config parameter for Jumbo Packet support */
-	/* adapter->registry_jumbo_packet = new_mtu + 14; */
-	/* blux: not needet here, we'll change the MAC */
-
 	et131x_soft_reset(adapter);
 
 	/* Alloc and init Rx DMA memory */
-- 
1.7.6

