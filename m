Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2GWBna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54373 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127Ab2GWBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:23 -0400
Message-Id: <20120723010659.344471507@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Cloud Ren <cjren@qca.qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 052/108] atl1c: fix issue of transmit queue 0 timed out
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cloud Ren <cjren@qca.qualcomm.com>

commit b94e52f62683dc0b00c6d1b58b80929a078c0fd5 upstream.

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
Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


