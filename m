Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0KXI6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:58:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57888 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0KXI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:58:10 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org
Subject: [PATCH 3/6] net: add some KERN_CONT markers to continuation lines
Date: Wed, 24 Nov 2010 09:57:47 +0100
Message-Id: <1290589070-854-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101124085645.GW4693@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: netdev@vger.kernel.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/phy/phy.c |    4 ++--
 net/ipv4/ipconfig.c   |   32 ++++++++++++++++----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 7670aac..a8445c7 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -47,11 +47,11 @@ void phy_print_status(struct phy_device *phydev)
 	pr_info("PHY: %s - Link is %s", dev_name(&phydev->dev),
 			phydev->link ? "Up" : "Down");
 	if (phydev->link)
-		printk(" - %d/%s", phydev->speed,
+		printk(KERN_CONT " - %d/%s", phydev->speed,
 				DUPLEX_FULL == phydev->duplex ?
 				"Full" : "Half");
 
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 EXPORT_SYMBOL(phy_print_status);
 
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 3a6e1ec..2b09775 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1191,13 +1191,13 @@ static int __init ic_dynamic(void)
 		    (ic_proto_enabled & IC_USE_DHCP) &&
 		    ic_dhcp_msgtype != DHCPACK) {
 			ic_got_reply = 0;
-			printk(",");
+			printk(KERN_CONT ",");
 			continue;
 		}
 #endif /* IPCONFIG_DHCP */
 
 		if (ic_got_reply) {
-			printk(" OK\n");
+			printk(KERN_CONT " OK\n");
 			break;
 		}
 
@@ -1205,7 +1205,7 @@ static int __init ic_dynamic(void)
 			continue;
 
 		if (! --retries) {
-			printk(" timed out!\n");
+			printk(KERN_CONT " timed out!\n");
 			break;
 		}
 
@@ -1215,7 +1215,7 @@ static int __init ic_dynamic(void)
 		if (timeout > CONF_TIMEOUT_MAX)
 			timeout = CONF_TIMEOUT_MAX;
 
-		printk(".");
+		printk(KERN_CONT ".");
 	}
 
 #ifdef IPCONFIG_BOOTP
@@ -1236,7 +1236,7 @@ static int __init ic_dynamic(void)
 		((ic_got_reply & IC_RARP) ? "RARP"
 		 : (ic_proto_enabled & IC_USE_DHCP) ? "DHCP" : "BOOTP"),
 		&ic_servaddr);
-	printk("my address is %pI4\n", &ic_myaddr);
+	printk(KERN_CONT "my address is %pI4\n", &ic_myaddr);
 
 	return 0;
 }
@@ -1468,19 +1468,19 @@ static int __init ip_auto_config(void)
 	/*
 	 * Clue in the operator.
 	 */
-	printk("IP-Config: Complete:");
-	printk("\n     device=%s", ic_dev->name);
-	printk(", addr=%pI4", &ic_myaddr);
-	printk(", mask=%pI4", &ic_netmask);
-	printk(", gw=%pI4", &ic_gateway);
-	printk(",\n     host=%s, domain=%s, nis-domain=%s",
+	printk("IP-Config: Complete:\n");
+	printk("     device=%s", ic_dev->name);
+	printk(KERN_CONT ", addr=%pI4", &ic_myaddr);
+	printk(KERN_CONT ", mask=%pI4", &ic_netmask);
+	printk(KERN_CONT ", gw=%pI4", &ic_gateway);
+	printk(KERN_CONT ",\n     host=%s, domain=%s, nis-domain=%s",
 	       utsname()->nodename, ic_domain, utsname()->domainname);
-	printk(",\n     bootserver=%pI4", &ic_servaddr);
-	printk(", rootserver=%pI4", &root_server_addr);
-	printk(", rootpath=%s", root_server_path);
+	printk(KERN_CONT ",\n     bootserver=%pI4", &ic_servaddr);
+	printk(KERN_CONT ", rootserver=%pI4", &root_server_addr);
+	printk(KERN_CONT ", rootpath=%s", root_server_path);
 	if (ic_dev_mtu)
-		printk(", mtu=%d", ic_dev_mtu);
-	printk("\n");
+		printk(KERN_CONT ", mtu=%d", ic_dev_mtu);
+	printk(KERN_CONT "\n");
 #endif /* !SILENT */
 
 	return 0;
-- 
1.7.2.3

