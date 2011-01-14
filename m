Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1ANUkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:40:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54201
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138Ab1ANUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:40:20 -0500
Date: Fri, 14 Jan 2011 12:40:53 -0800 (PST)
Message-Id: <20110114.124053.111572121.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: sparclinux@vger.kernel.org, fberckel@xs4all.nl, julian.calaby@gmail.com,
        sinan@writeme.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cassini: Use local-mac-address prom property for
 Cassini MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D3035F0.6020503@oldelvet.org.uk>
References: <1294324455.6193.70.camel@duncow>
	<20110106.115123.35031451.davem@davemloft.net>
	<4D3035F0.6020503@oldelvet.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Fri, 14 Jan 2011 11:39:28 +0000

> FYI Sinan Akman has reported that cassini does not compile for x86 any
> longer. Message included below.
> 
> Does anyone have suggestions as to the best way to resolve this?

I'll fix it like this:

--------------------
cassini: Fix build bustage on x86.

Unfortunately, not all CONFIG_OF platforms provide
pci_device_to_OF_node().

Change the test to CONFIG_SPARC for now to deal with
the build regressions.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/cassini.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 7206ab2..3437613 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -3203,7 +3203,7 @@ static int cas_get_vpd_info(struct cas *cp, unsigned char *dev_addr,
 	int phy_type = CAS_PHY_MII_MDIO0; /* default phy type */
 	int mac_off  = 0;
 
-#if defined(CONFIG_OF)
+#if defined(CONFIG_SPARC)
 	const unsigned char *addr;
 #endif
 
@@ -3354,7 +3354,7 @@ use_random_mac_addr:
 	if (found & VPD_FOUND_MAC)
 		goto done;
 
-#if defined(CONFIG_OF)
+#if defined(CONFIG_SPARC)
 	addr = of_get_property(cp->of_node, "local-mac-address", NULL);
 	if (addr != NULL) {
 		memcpy(dev_addr, addr, 6);
@@ -5031,7 +5031,7 @@ static int __devinit cas_init_one(struct pci_dev *pdev,
 	cp->msg_enable = (cassini_debug < 0) ? CAS_DEF_MSG_ENABLE :
 	  cassini_debug;
 
-#if defined(CONFIG_OF)
+#if defined(CONFIG_SPARC)
 	cp->of_node = pci_device_to_OF_node(pdev);
 #endif
 
-- 
1.7.3.4

