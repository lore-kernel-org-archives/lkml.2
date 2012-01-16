Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2APKpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:45:12 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42379 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab2APKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:45:09 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275bhz2eic1ahc1bh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Steven Miao <realmz6@gmail.com>
To: <wg@grandegger.com>, <mkl@pengutronix.de>
CC: Steven Miao <realmz6@gmail.com>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] socket-can: bit-timing calculation
Date: Mon, 16 Jan 2012 18:50:24 +0800
Message-ID: <1326711025-6629-1-git-send-email-realmz6@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just use first found best bit rate prescaler

Signed-off-by: Steven Miao <realmz6@gmail.com>
---
 drivers/net/can/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 25695bd..9d4afe6 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -106,7 +106,7 @@ static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt)
 		/* tseg brp biterror */
 		if (error < 0)
 			error = -error;
-		if (error > best_error)
+		if (error >= best_error)
 			continue;
 		best_error = error;
 		if (error == 0) {
-- 
1.7.0.4


