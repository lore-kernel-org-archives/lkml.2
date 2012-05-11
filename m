Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab2EKPrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:47:47 -0400
Received: from canardo.mork.no ([148.122.252.1]:45468 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab2EKPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:47:44 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, rdunlap@xenotime.net, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        david.daney@cavium.com, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] net: of/phy: fix build error when phylib is built as a module
Date: Fri, 11 May 2012 17:47:01 +0200
Message-Id: <1336751221-19127-1-git-send-email-bjorn@mork.no>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20120510.224352.2149006669429730060.davem@davemloft.net>
References: <20120510.224352.2149006669429730060.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_OF_MDIO is tristate and will be m if PHYLIB is m.  Use
IS_ENABLED macro to prevent build error:

 ERROR: "of_mdio_find_bus" [drivers/net/phy/mdio-mux.ko] undefined!

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: David Daney <david.daney@cavium.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
I wonder if this could be as banal as this?  Not even build tested...

Should be wrapped into commit 25106022 if it works, to ensure
bisectability.



Bjørn

 drivers/net/phy/mdio_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 83d5c9f..683ef1c 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -88,7 +88,7 @@ static struct class mdio_bus_class = {
 	.dev_release	= mdiobus_release,
 };
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 /* Helper function for of_mdio_find_bus */
 static int of_mdio_bus_match(struct device *dev, void *mdio_bus_np)
 {
-- 
1.7.10

