Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2BXNrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:47:46 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:44090 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658Ab2BXNro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:47:44 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Henk de Groot <pe1dnn@amsat.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] Staging: wlags49_h2: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:46:02 +0100
Message-Id: <1330091162-8141-12-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091264;cbe378a0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pM
instead of custom code.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/staging/wlags49_h2/wl_cs.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 2faee2d..a2cbb29 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -229,7 +229,6 @@ static int wl_adapter_resume(struct pcmcia_device *link)
 void wl_adapter_insert(struct pcmcia_device *link)
 {
 	struct net_device *dev;
-	int i;
 	int ret;
 	/*--------------------------------------------------------------------*/
 
@@ -266,10 +265,8 @@ void wl_adapter_insert(struct pcmcia_device *link)
 
 	register_wlags_sysfs(dev);
 
-	printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, ""mac_address ",
-		dev->name, dev->base_addr, dev->irq);
-	for (i = 0; i < ETH_ALEN; i++)
-		printk("%02X%c", dev->dev_addr[i], ((i < (ETH_ALEN-1)) ? ':' : '\n'));
+	printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, mac_address"
+		" %pM\n", dev->name, dev->base_addr, dev->irq, dev->dev_addr);
 
 	DBG_LEAVE(DbgInfo);
 	return;
-- 
1.7.8.3

