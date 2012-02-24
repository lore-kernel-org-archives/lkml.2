Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab2BXNru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:47:50 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:44106 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757563Ab2BXNrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:47:48 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] Staging: ft1000-pcmcia: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:46:01 +0100
Message-Id: <1330091162-8141-11-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091268;15fe98aa;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pM
instead of custom code.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 917bbb0..7569aa0 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -2211,11 +2211,8 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 	ft1000InitProc(dev);
 	ft1000_card_present = 1;
 	SET_ETHTOOL_OPS(dev, &ops);
-	printk(KERN_INFO
-		   "ft1000: %s: addr 0x%04lx irq %d, MAC addr %02x:%02x:%02x:%02x:%02x:%02x\n",
-		   dev->name, dev->base_addr, dev->irq, dev->dev_addr[0],
-		   dev->dev_addr[1], dev->dev_addr[2], dev->dev_addr[3],
-		   dev->dev_addr[4], dev->dev_addr[5]);
+	printk(KERN_INFO "ft1000: %s: addr 0x%04lx irq %d, MAC addr %pM\n",
+			dev->name, dev->base_addr, dev->irq, dev->dev_addr);
 	return dev;
 
 err_unreg:
-- 
1.7.8.3

