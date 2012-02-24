Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2BXNs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:48:59 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43966 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757435Ab2BXNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:46:39 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] arch/ia64/hp/sim/simeth.c: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:45:52 +0100
Message-Id: <1330091162-8141-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091198;055059f7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pm
instead of custom code.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/ia64/hp/sim/simeth.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/hp/sim/simeth.c b/arch/ia64/hp/sim/simeth.c
index 47afcc6..440001e 100644
--- a/arch/ia64/hp/sim/simeth.c
+++ b/arch/ia64/hp/sim/simeth.c
@@ -193,7 +193,7 @@ simeth_probe1(void)
 	unsigned char mac_addr[ETH_ALEN];
 	struct simeth_local *local;
 	struct net_device *dev;
-	int fd, i, err, rc;
+	int fd, err, rc;
 
 	/*
 	 * XXX Fix me
@@ -236,12 +236,8 @@ simeth_probe1(void)
 	 */
 	netdev_connect(dev->irq);
 
-	printk(KERN_INFO "%s: hosteth=%s simfd=%d, HwAddr",
-	       dev->name, simeth_device, local->simfd);
-	for(i = 0; i < ETH_ALEN; i++) {
-		printk(" %2.2x", dev->dev_addr[i]);
-	}
-	printk(", IRQ %d\n", dev->irq);
+	printk(KERN_INFO "%s: hosteth=%s simfd=%d, HwAddr=%pm, IRQ %d\n",
+	       dev->name, simeth_device, local->simfd, dev->dev_addr, dev->irq);
 
 	return 0;
 }
-- 
1.7.8.3

