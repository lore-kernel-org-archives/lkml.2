Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab2HRRcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:38273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab2HRRac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="188137648"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 21/31] sections: Fix section conflicts in drivers/net
Date: Sat, 18 Aug 2012 10:30:12 -0700
Message-Id: <1345311022-26328-22-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/can/slcan.c                         |    2 +-
 drivers/net/can/vcan.c                          |    2 +-
 drivers/net/ethernet/8390/ne3210.c              |    2 +-
 drivers/net/ethernet/adaptec/starfire.c         |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c        |    2 +-
 drivers/net/ethernet/dec/tulip/eeprom.c         |    2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c    |    2 +-
 drivers/net/ethernet/dlink/sundance.c           |    2 +-
 drivers/net/ethernet/fealnx.c                   |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c  |    2 +-
 drivers/net/ethernet/realtek/8139too.c          |    2 +-
 drivers/net/ethernet/sis/sis190.c               |    2 +-
 drivers/net/hamradio/6pack.c                    |    4 ++--
 14 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 034c16b..adc3708 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -56,7 +56,7 @@
 #include <linux/kernel.h>
 #include <linux/can.h>
 
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "slcan: serial line CAN interface driver\n";
 
 MODULE_ALIAS_LDISC(N_SLCAN);
diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index 4f93c0b..0a2a5ee 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -49,7 +49,7 @@
 #include <linux/slab.h>
 #include <net/rtnetlink.h>
 
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "vcan: Virtual CAN interface driver\n";
 
 MODULE_DESCRIPTION("virtual CAN interface");
diff --git a/drivers/net/ethernet/8390/ne3210.c b/drivers/net/ethernet/8390/ne3210.c
index a2f8b2b..e3f5742 100644
--- a/drivers/net/ethernet/8390/ne3210.c
+++ b/drivers/net/ethernet/8390/ne3210.c
@@ -81,7 +81,7 @@ static void ne3210_block_output(struct net_device *dev, int count, const unsigne
 
 static unsigned char irq_map[] __initdata = {15, 12, 11, 10, 9, 7, 5, 3};
 static unsigned int shmem_map[] __initdata = {0xff0, 0xfe0, 0xfff0, 0xd8, 0xffe0, 0xffc0, 0xd0, 0x0};
-static const char *ifmap[] __initdata = {"UTP", "?", "BNC", "AUI"};
+static const char * const ifmap[] __initconst = {"UTP", "?", "BNC", "AUI"};
 static int ifmap_val[] __initdata = {
 		IF_PORT_10BASET,
 		IF_PORT_UNKNOWN,
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index d920a52..5b65992c 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -295,7 +295,7 @@ MODULE_DEVICE_TABLE(pci, starfire_pci_tbl);
 static const struct chip_info {
 	const char *name;
 	int drv_flags;
-} netdrv_tbl[] __devinitdata = {
+} netdrv_tbl[] __devinitconst = {
 	{ "Adaptec Starfire 6915", CanHaveMII },
 };
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1bf5bbf..aa5e41b 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -702,7 +702,7 @@ struct atl1c_platform_patch {
 	u32 patch_flag;
 #define ATL1C_LINK_PATCH	0x1
 };
-static const struct atl1c_platform_patch plats[] __devinitdata = {
+static const struct atl1c_platform_patch plats[] __devinitconst = {
 {0x2060, 0xC1, 0x1019, 0x8152, 0x1},
 {0x2060, 0xC1, 0x1019, 0x2060, 0x1},
 {0x2060, 0xC1, 0x1019, 0xE000, 0x1},
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 57d64b8..623dd86 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -2845,7 +2845,7 @@ static void atl2_force_ps(struct atl2_hw *hw)
  */
 
 #define ATL2_PARAM(X, desc) \
-    static const int __devinitdata X[ATL2_MAX_NIC + 1] = ATL2_PARAM_INIT; \
+    static const int __devinitconst X[ATL2_MAX_NIC + 1] = ATL2_PARAM_INIT; \
     MODULE_PARM(X, "1-" __MODULE_STRING(ATL2_MAX_NIC) "i"); \
     MODULE_PARM_DESC(X, desc);
 #else
diff --git a/drivers/net/ethernet/dec/tulip/eeprom.c b/drivers/net/ethernet/dec/tulip/eeprom.c
index ed7d1dc..44f7e8e 100644
--- a/drivers/net/ethernet/dec/tulip/eeprom.c
+++ b/drivers/net/ethernet/dec/tulip/eeprom.c
@@ -79,7 +79,7 @@ static struct eeprom_fixup eeprom_fixups[] __devinitdata = {
   {NULL}};
 
 
-static const char *block_name[] __devinitdata = {
+static const char *const block_name[] __devinitconst = {
 	"21140 non-MII",
 	"21140 MII PHY",
 	"21142 Serial PHY",
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 4d1ffca..7c1ec4d 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -236,7 +236,7 @@ struct pci_id_info {
         int drv_flags;		/* Driver use, intended as capability flags. */
 };
 
-static const struct pci_id_info pci_id_tbl[] __devinitdata = {
+static const struct pci_id_info pci_id_tbl[] __devinitconst = {
 	{ 				/* Sometime a Level-One switch card. */
 	  "Winbond W89c840",	CanHaveMII | HasBrokenTx | FDXOnNoMII},
 	{ "Winbond W89c840",	CanHaveMII | HasBrokenTx},
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index d7bb52a..3b83588 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -218,7 +218,7 @@ enum {
 struct pci_id_info {
         const char *name;
 };
-static const struct pci_id_info pci_id_tbl[] __devinitdata = {
+static const struct pci_id_info pci_id_tbl[] __devinitconst = {
 	{"D-Link DFE-550TX FAST Ethernet Adapter"},
 	{"D-Link DFE-550FX 100Mbps Fiber-optics Adapter"},
 	{"D-Link DFE-580TX 4 port Server Adapter"},
diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index 9d71c9c..0e4a0ac 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -150,7 +150,7 @@ struct chip_info {
 	int flags;
 };
 
-static const struct chip_info skel_netdrv_tbl[] __devinitdata = {
+static const struct chip_info skel_netdrv_tbl[] __devinitconst = {
  	{ "100/10M Ethernet PCI Adapter",	HAS_MII_XCVR },
 	{ "100/10M Ethernet PCI Adapter",	HAS_CHIP_XCVR },
 	{ "1000/100/10M Ethernet PCI Adapter",	HAS_MII_XCVR },
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index b528e52..2a0c9dc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -38,7 +38,7 @@ static inline void writeq(u64 val, void __iomem *addr)
 }
 #endif
 
-static const struct crb_128M_2M_block_map
+static struct crb_128M_2M_block_map
 crb_128M_2M_map[64] __cacheline_aligned_in_smp = {
     {{{0, 0,         0,         0} } },		/* 0: PCI */
     {{{1, 0x0100000, 0x0102000, 0x120000},	/* 1: PCIE */
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 1d83565..3ed7add 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -228,7 +228,7 @@ typedef enum {
 static const struct {
 	const char *name;
 	u32 hw_flags;
-} board_info[] __devinitdata = {
+} board_info[] __devinitconst = {
 	{ "RealTek RTL8139", RTL8139_CAPS },
 	{ "RealTek RTL8129", RTL8129_CAPS },
 };
diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 4613591..d816601 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1618,7 +1618,7 @@ static int __devinit sis190_get_mac_addr_from_eeprom(struct pci_dev *pdev,
 static int __devinit sis190_get_mac_addr_from_apc(struct pci_dev *pdev,
 						  struct net_device *dev)
 {
-	static const u16 __devinitdata ids[] = { 0x0965, 0x0966, 0x0968 };
+	static const u16 __devinitconst ids[] = { 0x0965, 0x0966, 0x0968 };
 	struct sis190_private *tp = netdev_priv(dev);
 	struct pci_dev *isa_bridge;
 	u8 reg, tmp8;
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 64783a0..d225a2a 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -811,9 +811,9 @@ static struct tty_ldisc_ops sp_ldisc = {
 
 /* Initialize 6pack control device -- register 6pack line discipline */
 
-static const char msg_banner[]  __initdata = KERN_INFO \
+static const char msg_banner[]  __initconst = KERN_INFO \
 	"AX.25: 6pack driver, " SIXPACK_VERSION "\n";
-static const char msg_regfail[] __initdata = KERN_ERR  \
+static const char msg_regfail[] __initconst = KERN_ERR  \
 	"6pack: can't register line discipline (err = %d)\n";
 
 static int __init sixpack_init_driver(void)
-- 
1.7.7.6

