Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030769Ab2HGWko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:40:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030749Ab2HGWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:40:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        xiong <xiong@qca.qualcomm.com>, Cloud Ren <cjren@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 077/109] atl1c: fix issue of transmit queue 0 timed out
Date: Tue,  7 Aug 2012 15:35:36 -0700
Message-Id: <20120807222049.862670411@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Cloud Ren <cjren@qca.qualcomm.com>

[ Upstream commit b94e52f62683dc0b00c6d1b58b80929a078c0fd5 ]

some people report atl1c could cause system hang with following
kernel trace info:
---------------------------------------
WARNING: at.../net/sched/sch_generic.c:258 dev_watchdog+0x1db/0x1d0()
...
NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
...
---------------------------------------
This is caused by netif_stop_queue calling when cable Link is down.
So remove netif_stop_queue, because link_watch will take it over.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -267,7 +267,6 @@ static void atl1c_check_link_status(stru
 				dev_warn(&pdev->dev, "stop mac failed\n");
 		atl1c_set_aspm(hw, false);
 		netif_carrier_off(netdev);
-		netif_stop_queue(netdev);
 		atl1c_phy_reset(hw);
 		atl1c_phy_init(&adapter->hw);
 	} else {


