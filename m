Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162696Ab2GMFfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:35:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37496 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030245Ab2GMFfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:35:12 -0400
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Mike Frysinger <vapier@gentoo.org>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-c6x-dev@linux-c6x.org,
        linux-mips@linux-mips.org, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH net-next 8/8] arch: Use eth_random_addr
Date: Thu, 12 Jul 2012 22:33:12 -0700
Message-Id: <14a91278564bb5a263c561a7f1bd10ea6386d90a.1342157022.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1341968967.13724.23.camel@joe2Laptop>
References: <1341968967.13724.23.camel@joe2Laptop>
In-Reply-To: <cover.1342157022.git.joe@perches.com>
References: <cover.1342157022.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing uses of random_ether_addr to
the new eth_random_addr.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
 arch/c6x/kernel/soc.c                   |    2 +-
 arch/mips/ar7/platform.c                |    4 ++--
 arch/mips/powertv/powertv_setup.c       |    6 +++---
 arch/um/drivers/net_kern.c              |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index c9d9473..5ed654a 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -873,7 +873,7 @@ static struct adf702x_platform_data adf7021_platform_data = {
 };
 static inline void adf702x_mac_init(void)
 {
-	random_ether_addr(adf7021_platform_data.mac_addr);
+	eth_random_addr(adf7021_platform_data.mac_addr);
 }
 #else
 static inline void adf702x_mac_init(void) {}
diff --git a/arch/c6x/kernel/soc.c b/arch/c6x/kernel/soc.c
index 0748c94..3ac7408 100644
--- a/arch/c6x/kernel/soc.c
+++ b/arch/c6x/kernel/soc.c
@@ -80,7 +80,7 @@ int soc_mac_addr(unsigned int index, u8 *addr)
 		if (have_fuse_mac)
 			memcpy(addr, c6x_fuse_mac, 6);
 		else
-			random_ether_addr(addr);
+			eth_random_addr(addr);
 	}
 
 	/* adjust for specific EMAC device */
diff --git a/arch/mips/ar7/platform.c b/arch/mips/ar7/platform.c
index 1a24d31..1bbc24b 100644
--- a/arch/mips/ar7/platform.c
+++ b/arch/mips/ar7/platform.c
@@ -310,10 +310,10 @@ static void __init cpmac_get_mac(int instance, unsigned char *dev_addr)
 					&dev_addr[4], &dev_addr[5]) != 6) {
 			pr_warning("cannot parse mac address, "
 					"using random address\n");
-			random_ether_addr(dev_addr);
+			eth_random_addr(dev_addr);
 		}
 	} else
-		random_ether_addr(dev_addr);
+		eth_random_addr(dev_addr);
 }
 
 /*****************************************************************************
diff --git a/arch/mips/powertv/powertv_setup.c b/arch/mips/powertv/powertv_setup.c
index 3933c37..820b848 100644
--- a/arch/mips/powertv/powertv_setup.c
+++ b/arch/mips/powertv/powertv_setup.c
@@ -254,7 +254,7 @@ early_param("rfmac", rfmac_param);
  * Generates an Ethernet MAC address that is highly likely to be unique for
  * this particular system on a network with other systems of the same type.
  *
- * The problem we are solving is that, when random_ether_addr() is used to
+ * The problem we are solving is that, when eth_random_addr() is used to
  * generate MAC addresses at startup, there isn't much entropy for the random
  * number generator to use and the addresses it produces are fairly likely to
  * be the same as those of other identical systems on the same local network.
@@ -269,7 +269,7 @@ early_param("rfmac", rfmac_param);
  * Still, this does give us something to work with.
  *
  * The approach we take is:
- * 1.	If we can't get the RF MAC Address, just call random_ether_addr.
+ * 1.	If we can't get the RF MAC Address, just call eth_random_addr.
  * 2.	Use the 24-bit NIC-specific bits of the RF MAC address as the last 24
  *	bits of the new address. This is very likely to be unique, except for
  *	the current box.
@@ -299,7 +299,7 @@ void platform_random_ether_addr(u8 addr[ETH_ALEN])
 	if (!have_rfmac) {
 		pr_warning("rfmac not available on command line; "
 			"generating random MAC address\n");
-		random_ether_addr(addr);
+		eth_random_addr(addr);
 	}
 
 	else {
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 0d60c56..458d324 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -339,7 +339,7 @@ static int setup_etheraddr(char *str, unsigned char *addr, char *name)
 random:
 	printk(KERN_INFO
 	       "Choosing a random ethernet address for device %s\n", name);
-	random_ether_addr(addr);
+	eth_random_addr(addr);
 	return 1;
 }
 
-- 
1.7.8.111.gad25c.dirty

