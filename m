Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2JJQbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:31:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22697 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2JJQbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:31:52 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        srinivas.kandagatla@st.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] of/mdio: fix build errors when CONFIG_OF isn't set
Date: Wed, 10 Oct 2012 12:31:23 -0400
Message-Id: <1349886683-26351-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.7.12
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f9dc9ac5 ("of/mdio: Add dummy functions in of_mdio.h.") has added
empty stubs into of_mdio.h which were not static, this causes build errors
when these symbols were defined across several objects.

Fix it by marking those stubs as 'static inline'.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/of_mdio.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 6ef49b8..7f17b9c 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -26,17 +26,17 @@ extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 extern struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
 
 #else /* CONFIG_OF */
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
+static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 {
 	return -ENOSYS;
 }
 
-struct phy_device *of_phy_find_device(struct device_node *phy_np)
+static inline struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
 	return NULL;
 }
 
-struct phy_device *of_phy_connect(struct net_device *dev,
+static inline struct phy_device *of_phy_connect(struct net_device *dev,
 					 struct device_node *phy_np,
 					 void (*hndlr)(struct net_device *),
 					 u32 flags, phy_interface_t iface)
@@ -44,14 +44,14 @@ struct phy_device *of_phy_connect(struct net_device *dev,
 	return NULL;
 }
 
-struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
+static inline struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 					 void (*hndlr)(struct net_device *),
 					 phy_interface_t iface)
 {
 	return NULL;
 }
 
-struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
+static inline struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
 {
 	return NULL;
 }
-- 
1.7.12

