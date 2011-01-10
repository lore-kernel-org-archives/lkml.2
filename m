Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1AJUJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:09:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:60793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1AJUJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:09:34 -0500
Date: Mon, 10 Jan 2011 20:09:30 +0000
From: Denis Kirjanov <dkirjanov@kernel.org>
To: devel@driverdev.osuosl.org
Cc: ozan@pardus.org.tr, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rt2860: Fix incorrect netif_stop_queue usage warning
Message-ID: <20110110200930.GA4632@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 Jan 2011 20:09:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TX queues are allocated inside register_netdev.
It doesn't make any sense to stop the queue before
allocation.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 drivers/staging/rt2860/rt_main_dev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index ad60cea..caf8b76 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -483,8 +483,6 @@ struct net_device *RtmpPhyNetDevInit(struct rt_rtmp_adapter *pAd,
 	net_dev->ml_priv = (void *)pAd;
 	pAd->net_dev = net_dev;
 
-	netif_stop_queue(net_dev);
-
 	return net_dev;
 
 }
-- 
1.7.3.4

