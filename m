Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1DEO7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:59:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:44458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab1DEO7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:37 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 18/34] wan/pc300: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:05 +0200
Message-Id: <1302015561-21047-19-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/net/wan/pc300_drv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index f875cfa..80ae503 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -3242,8 +3242,7 @@ static inline void show_version(void)
 	rcsdate++;
 	tmp = strrchr(rcsdate, ' ');
 	*tmp = '\0';
-	printk(KERN_INFO "Cyclades-PC300 driver %s %s (built %s %s)\n", 
-		rcsvers, rcsdate, __DATE__, __TIME__);
+	printk(KERN_INFO "Cyclades-PC300 driver %s %s\n", rcsvers, rcsdate);
 }				/* show_version */
 
 static const struct net_device_ops cpc_netdev_ops = {
-- 
1.7.4.1

