Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab1FFSIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:08:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63244 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab1FFSHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=riGAPMB/oIIUtrYtfzcQoisIxzqcb548E1HGyx0WfWOONRnUqV7u1l9ytDFVQMEfbS
         6RU2Lw26xegoYU7ocyS5O1kYA1aCWRtJfsckSFXHDxB7Rwt9edLHkyoKXoQS9qtPVKZ6
         T9UDkBckHZpcTbAAPNL/edpCnoactANiSb/6g=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@lxorguk.ukuu.org.uk,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH v2 6/7] staging: et131x: Fixes multiple 'WARNING: do not add new typedefs'.
Date: Mon,  6 Jun 2011 19:07:03 +0100
Message-Id: <1307383624-8740-7-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
 <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unions, and uses definitions for bit manipulations.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_address_map.h |  195 ++++++++++-----------------
 drivers/staging/et131x/et1310_mac.c         |   92 +++++++-------
 drivers/staging/et131x/et1310_phy.c         |    4 +-
 drivers/staging/et131x/et131x_adapter.h     |    2 +-
 drivers/staging/et131x/et131x_isr.c         |    2 +-
 5 files changed, 123 insertions(+), 172 deletions(-)

diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index 6f52627..a925300 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -700,42 +700,27 @@ struct txmac_regs {			/* Location: */
 /*
  * structure for Wake On Lan Source Address Lo reg in rxmac address map
  * located at address 0x4010
+ *
+ * 31-24: sa3
+ * 23-16: sa4
+ * 15-8: sa5
+ * 7-0: sa6
  */
-union RXMAC_WOL_SA_LO_t {
-	u32 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u32 sa3:8;	/* bits 24-31 */
-		u32 sa4:8;	/* bits 16-23 */
-		u32 sa5:8;	/* bits 8-15 */
-		u32 sa6:8;	/* bits 0-7 */
-#else
-		u32 sa6:8;	/* bits 0-7 */
-		u32 sa5:8;	/* bits 8-15 */
-		u32 sa4:8;	/* bits 16-23 */
-		u32 sa3:8;	/* bits 24-31 */
-#endif
-	} bits;
-};
+
+#define ET_WOL_LO_SA3_SHIFT 24
+#define ET_WOL_LO_SA4_SHIFT 16
+#define ET_WOL_LO_SA5_SHIFT 8
 
 /*
  * structure for Wake On Lan Source Address Hi reg in rxmac address map
  * located at address 0x4014
+ *
+ * 31-16: reserved
+ * 15-8: sa1
+ * 7-0: sa2
  */
-union RXMAC_WOL_SA_HI_t {
-	u32 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u32 reserved:16;	/* bits 16-31 */
-		u32 sa1:8;		/* bits 8-15 */
-		u32 sa2:8;		/* bits 0-7 */
-#else
-		u32 sa2:8;		/* bits 0-7 */
-		u32 sa1:8;		/* bits 8-15 */
-		u32 reserved:16;	/* bits 16-31 */
-#endif
-	} bits;
-};
+
+#define ET_WOL_HI_SA1_SHIFT 8
 
 /*
  * structure for Wake On Lan mask reg in rxmac address map
@@ -746,65 +731,45 @@ union RXMAC_WOL_SA_HI_t {
 /*
  * structure for Unicast Paket Filter Address 1 reg in rxmac address map
  * located at address 0x4068
+ *
+ * 31-24: addr1_3
+ * 23-16: addr1_4
+ * 15-8: addr1_5
+ * 7-0: addr1_6
  */
-union RXMAC_UNI_PF_ADDR1_t {
-	u32 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u32 addr1_3:8;	/* bits 24-31 */
-		u32 addr1_4:8;	/* bits 16-23 */
-		u32 addr1_5:8;	/* bits 8-15 */
-		u32 addr1_6:8;	/* bits 0-7 */
-#else
-		u32 addr1_6:8;	/* bits 0-7 */
-		u32 addr1_5:8;	/* bits 8-15 */
-		u32 addr1_4:8;	/* bits 16-23 */
-		u32 addr1_3:8;	/* bits 24-31 */
-#endif
-	} bits;
-};
+
+#define ET_UNI_PF_ADDR1_3_SHIFT 24
+#define ET_UNI_PF_ADDR1_4_SHIFT 16
+#define ET_UNI_PF_ADDR1_5_SHIFT 8
 
 /*
  * structure for Unicast Paket Filter Address 2 reg in rxmac address map
  * located at address 0x406C
+ *
+ * 31-24: addr2_3
+ * 23-16: addr2_4
+ * 15-8: addr2_5
+ * 7-0: addr2_6
  */
-union RXMAC_UNI_PF_ADDR2_t {
-	u32 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u32 addr2_3:8;	/* bits 24-31 */
-		u32 addr2_4:8;	/* bits 16-23 */
-		u32 addr2_5:8;	/* bits 8-15 */
-		u32 addr2_6:8;	/* bits 0-7 */
-#else
-		u32 addr2_6:8;	/* bits 0-7 */
-		u32 addr2_5:8;	/* bits 8-15 */
-		u32 addr2_4:8;	/* bits 16-23 */
-		u32 addr2_3:8;	/* bits 24-31 */
-#endif
-	} bits;
-};
+
+#define ET_UNI_PF_ADDR2_3_SHIFT 24
+#define ET_UNI_PF_ADDR2_4_SHIFT 16
+#define ET_UNI_PF_ADDR2_5_SHIFT 8
 
 /*
  * structure for Unicast Paket Filter Address 1 & 2 reg in rxmac address map
  * located at address 0x4070
+ *
+ * 31-24: addr2_1
+ * 23-16: addr2_2
+ * 15-8: addr1_1
+ * 7-0: addr1_2
  */
-union RXMAC_UNI_PF_ADDR3_t {
-	u32 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u32 addr2_1:8;	/* bits 24-31 */
-		u32 addr2_2:8;	/* bits 16-23 */
-		u32 addr1_1:8;	/* bits 8-15 */
-		u32 addr1_2:8;	/* bits 0-7 */
-#else
-		u32 addr1_2:8;	/* bits 0-7 */
-		u32 addr1_1:8;	/* bits 8-15 */
-		u32 addr2_2:8;	/* bits 16-23 */
-		u32 addr2_1:8;	/* bits 24-31 */
-#endif
-	} bits;
-};
+
+#define ET_UNI_PF_ADDR2_1_SHIFT 24
+#define ET_UNI_PF_ADDR2_2_SHIFT 16
+#define ET_UNI_PF_ADDR1_1_SHIFT 8
+
 
 /*
  * structure for Multicast Hash reg in rxmac address map
@@ -888,13 +853,13 @@ union RXMAC_UNI_PF_ADDR3_t {
 /*
  * Rx MAC Module of JAGCore Address Mapping
  */
-struct RXMAC_t {					/* Location: */
+struct rxmac_regs {					/* Location: */
 	u32 ctrl;					/*  0x4000 */
 	u32 crc0;					/*  0x4004 */
 	u32 crc12;					/*  0x4008 */
 	u32 crc34;					/*  0x400C */
-	union RXMAC_WOL_SA_LO_t sa_lo;			/*  0x4010 */
-	union RXMAC_WOL_SA_HI_t sa_hi;			/*  0x4014 */
+	u32 sa_lo;					/*  0x4010 */
+	u32 sa_hi;					/*  0x4014 */
 	u32 mask0_word0;				/*  0x4018 */
 	u32 mask0_word1;				/*  0x401C */
 	u32 mask0_word2;				/*  0x4020 */
@@ -915,9 +880,9 @@ struct RXMAC_t {					/* Location: */
 	u32 mask4_word1;				/*  0x405C */
 	u32 mask4_word2;				/*  0x4060 */
 	u32 mask4_word3;				/*  0x4064 */
-	union RXMAC_UNI_PF_ADDR1_t uni_pf_addr1;	/*  0x4068 */
-	union RXMAC_UNI_PF_ADDR2_t uni_pf_addr2;	/*  0x406C */
-	union RXMAC_UNI_PF_ADDR3_t uni_pf_addr3;	/*  0x4070 */
+	u32 uni_pf_addr1;				/*  0x4068 */
+	u32 uni_pf_addr2;				/*  0x406C */
+	u32 uni_pf_addr3;				/*  0x4070 */
 	u32 multi_hash1;				/*  0x4074 */
 	u32 multi_hash2;				/*  0x4078 */
 	u32 multi_hash3;				/*  0x407C */
@@ -1123,47 +1088,33 @@ struct RXMAC_t {					/* Location: */
 /*
  * structure for Mac Station Address, Part 1 reg in mac address map.
  * located at address 0x5040
+ *
+ * 31-24: Octet6
+ * 23-16: Octet5
+ * 15-8: Octet4
+ * 7-0: Octet3
  */
-union MAC_STATION_ADDR1_t {
-	u32 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u32 Octet6:8;	/* bits 24-31 */
-		u32 Octet5:8;	/* bits 16-23 */
-		u32 Octet4:8;	/* bits 8-15 */
-		u32 Octet3:8;	/* bits 0-7 */
-#else
-		u32 Octet3:8;	/* bits 0-7 */
-		u32 Octet4:8;	/* bits 8-15 */
-		u32 Octet5:8;	/* bits 16-23 */
-		u32 Octet6:8;	/* bits 24-31 */
-#endif
-	} bits;
-};
+
+#define ET_MAC_STATION_ADDR1_OC6_SHIFT 24
+#define ET_MAC_STATION_ADDR1_OC5_SHIFT 16
+#define ET_MAC_STATION_ADDR1_OC4_SHIFT 8
 
 /*
  * structure for Mac Station Address, Part 2 reg in mac address map.
  * located at address 0x5044
+ *
+ * 31-24: Octet2
+ * 23-16: Octet1
+ * 15-0: reserved
  */
-union MAC_STATION_ADDR2_t {
-	u32 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u32 Octet2:8;	/* bits 24-31 */
-		u32 Octet1:8;	/* bits 16-23 */
-		u32 reserved:16;	/* bits 0-15 */
-#else
-		u32 reserved:16;	/* bit 0-15 */
-		u32 Octet1:8;	/* bits 16-23 */
-		u32 Octet2:8;	/* bits 24-31 */
-#endif
-	} bits;
-};
+
+#define ET_MAC_STATION_ADDR2_OC2_SHIFT 24
+#define ET_MAC_STATION_ADDR2_OC1_SHIFT 16
 
 /*
  * MAC Module of JAGCore Address Mapping
  */
-struct MAC_t {						/* Location: */
+struct mac_regs {					/* Location: */
 	u32 cfg1;					/*  0x5000 */
 	u32 cfg2;					/*  0x5004 */
 	u32 ipg;					/*  0x5008 */
@@ -1180,8 +1131,8 @@ struct MAC_t {						/* Location: */
 	u32 mii_mgmt_indicator;				/*  0x5034 */
 	u32 if_ctrl;					/*  0x5038 */
 	u32 if_stat;					/*  0x503C */
-	union MAC_STATION_ADDR1_t station_addr_1;	/*  0x5040 */
-	union MAC_STATION_ADDR2_t station_addr_2;	/*  0x5044 */
+	u32 station_addr_1;				/*  0x5040 */
+	u32 station_addr_2;				/*  0x5044 */
 };
 
 /* END OF MAC REGISTER ADDRESS MAP */
@@ -1448,7 +1399,7 @@ struct mmc_regs {		/* Location: */
 /*
  * JAGCore Address Mapping
  */
-struct ADDRESS_MAP_t {
+struct address_map {
 	struct global_regs global;
 	/* unused section of global address map */
 	u8 unused_global[4096 - sizeof(struct global_regs)];
@@ -1461,12 +1412,12 @@ struct ADDRESS_MAP_t {
 	struct txmac_regs txmac;
 	/* unused section of txmac address map */
 	u8 unused_txmac[4096 - sizeof(struct txmac_regs)];
-	struct RXMAC_t rxmac;
+	struct rxmac_regs rxmac;
 	/* unused section of rxmac address map */
-	u8 unused_rxmac[4096 - sizeof(struct RXMAC_t)];
-	struct MAC_t mac;
+	u8 unused_rxmac[4096 - sizeof(struct rxmac_regs)];
+	struct mac_regs mac;
 	/* unused section of mac address map */
-	u8 unused_mac[4096 - sizeof(struct MAC_t)];
+	u8 unused_mac[4096 - sizeof(struct mac_regs)];
 	struct macstat_regs macstat;
 	/* unused section of mac stat address map */
 	u8 unused_mac_stat[4096 - sizeof(struct macstat_regs)];
diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 1425af2..5a745cf 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -104,9 +104,9 @@
  */
 void ConfigMACRegs1(struct et131x_adapter *etdev)
 {
-	struct MAC_t __iomem *pMac = &etdev->regs->mac;
-	union MAC_STATION_ADDR1_t station1;
-	union MAC_STATION_ADDR2_t station2;
+	struct mac_regs __iomem *pMac = &etdev->regs->mac;
+	u32 station1;
+	u32 station2;
 	u32 ipg;
 
 	/* First we need to reset everything.  Write to MAC configuration
@@ -136,14 +136,14 @@ void ConfigMACRegs1(struct et131x_adapter *etdev)
 	 * station address is used for generating and checking pause control
 	 * packets.
 	 */
-	station2.bits.Octet1 = etdev->addr[0];
-	station2.bits.Octet2 = etdev->addr[1];
-	station1.bits.Octet3 = etdev->addr[2];
-	station1.bits.Octet4 = etdev->addr[3];
-	station1.bits.Octet5 = etdev->addr[4];
-	station1.bits.Octet6 = etdev->addr[5];
-	writel(station1.value, &pMac->station_addr_1.value);
-	writel(station2.value, &pMac->station_addr_2.value);
+	station2 = (etdev->addr[1] << ET_MAC_STATION_ADDR2_OC2_SHIFT) |
+		   (etdev->addr[0] << ET_MAC_STATION_ADDR2_OC1_SHIFT);
+	station1 = (etdev->addr[5] << ET_MAC_STATION_ADDR1_OC6_SHIFT) |
+		   (etdev->addr[4] << ET_MAC_STATION_ADDR1_OC5_SHIFT) |
+		   (etdev->addr[3] << ET_MAC_STATION_ADDR1_OC4_SHIFT) |
+		    etdev->addr[2];
+	writel(station1, &pMac->station_addr_1);
+	writel(station2, &pMac->station_addr_2);
 
 	/* Max ethernet packet in bytes that will passed by the mac without
 	 * being truncated.  Allow the MAC to pass 4 more than our max packet
@@ -165,7 +165,7 @@ void ConfigMACRegs1(struct et131x_adapter *etdev)
 void ConfigMACRegs2(struct et131x_adapter *etdev)
 {
 	int32_t delay = 0;
-	struct MAC_t __iomem *pMac = &etdev->regs->mac;
+	struct mac_regs __iomem *pMac = &etdev->regs->mac;
 	u32 cfg1;
 	u32 cfg2;
 	u32 ifctrl;
@@ -237,9 +237,9 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 
 void ConfigRxMacRegs(struct et131x_adapter *etdev)
 {
-	struct RXMAC_t __iomem *pRxMac = &etdev->regs->rxmac;
-	union RXMAC_WOL_SA_LO_t sa_lo;
-	union RXMAC_WOL_SA_HI_t sa_hi;
+	struct rxmac_regs __iomem *pRxMac = &etdev->regs->rxmac;
+	u32 sa_lo;
+	u32 sa_hi = 0;
 	u32 pf_ctrl = 0;
 
 	/* Disable the MAC while it is being configured (also disable WOL) */
@@ -280,15 +280,15 @@ void ConfigRxMacRegs(struct et131x_adapter *etdev)
 	writel(0, &pRxMac->mask4_word3);
 
 	/* Lets setup the WOL Source Address */
-	sa_lo.bits.sa3 = etdev->addr[2];
-	sa_lo.bits.sa4 = etdev->addr[3];
-	sa_lo.bits.sa5 = etdev->addr[4];
-	sa_lo.bits.sa6 = etdev->addr[5];
-	writel(sa_lo.value, &pRxMac->sa_lo.value);
+	sa_lo = (etdev->addr[2] << ET_WOL_LO_SA3_SHIFT) |
+		(etdev->addr[3] << ET_WOL_LO_SA4_SHIFT) |
+		(etdev->addr[4] << ET_WOL_LO_SA5_SHIFT) |
+		 etdev->addr[5];
+	writel(sa_lo, &pRxMac->sa_lo);
 
-	sa_hi.bits.sa1 = etdev->addr[0];
-	sa_hi.bits.sa2 = etdev->addr[1];
-	writel(sa_hi.value, &pRxMac->sa_hi.value);
+	sa_hi = (u32) (etdev->addr[0] << ET_WOL_HI_SA1_SHIFT) |
+	               etdev->addr[1];
+	writel(sa_hi, &pRxMac->sa_hi);
 
 	/* Disable all Packet Filtering */
 	writel(0, &pRxMac->pf_ctrl);
@@ -298,9 +298,9 @@ void ConfigRxMacRegs(struct et131x_adapter *etdev)
 		SetupDeviceForUnicast(etdev);
 		pf_ctrl |= 4;	/* Unicast filter */
 	} else {
-		writel(0, &pRxMac->uni_pf_addr1.value);
-		writel(0, &pRxMac->uni_pf_addr2.value);
-		writel(0, &pRxMac->uni_pf_addr3.value);
+		writel(0, &pRxMac->uni_pf_addr1);
+		writel(0, &pRxMac->uni_pf_addr2);
+		writel(0, &pRxMac->uni_pf_addr3);
 	}
 
 	/* Let's initialize the Multicast hash */
@@ -534,7 +534,7 @@ void HandleMacStatInterrupt(struct et131x_adapter *etdev)
 
 void SetupDeviceForMulticast(struct et131x_adapter *etdev)
 {
-	struct RXMAC_t __iomem *rxmac = &etdev->regs->rxmac;
+	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
 	uint32_t nIndex;
 	uint32_t result;
 	uint32_t hash1 = 0;
@@ -582,10 +582,10 @@ void SetupDeviceForMulticast(struct et131x_adapter *etdev)
 
 void SetupDeviceForUnicast(struct et131x_adapter *etdev)
 {
-	struct RXMAC_t __iomem *rxmac = &etdev->regs->rxmac;
-	union RXMAC_UNI_PF_ADDR1_t uni_pf1;
-	union RXMAC_UNI_PF_ADDR2_t uni_pf2;
-	union RXMAC_UNI_PF_ADDR3_t uni_pf3;
+	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
+	u32 uni_pf1;
+	u32 uni_pf2;
+	u32 uni_pf3;
 	u32 pm_csr;
 
 	/* Set up unicast packet filter reg 3 to be the first two octets of
@@ -597,25 +597,25 @@ void SetupDeviceForUnicast(struct et131x_adapter *etdev)
 	 * Set up unicast packet filter reg 3 to be the octets 2 - 5 of the
 	 * MAC address for first address
 	 */
-	uni_pf3.bits.addr1_1 = etdev->addr[0];
-	uni_pf3.bits.addr1_2 = etdev->addr[1];
-	uni_pf3.bits.addr2_1 = etdev->addr[0];
-	uni_pf3.bits.addr2_2 = etdev->addr[1];
+	uni_pf3 = (etdev->addr[0] << ET_UNI_PF_ADDR2_1_SHIFT) |
+		  (etdev->addr[1] << ET_UNI_PF_ADDR2_2_SHIFT) |
+		  (etdev->addr[0] << ET_UNI_PF_ADDR1_1_SHIFT) |
+		   etdev->addr[1];
 
-	uni_pf2.bits.addr2_3 = etdev->addr[2];
-	uni_pf2.bits.addr2_4 = etdev->addr[3];
-	uni_pf2.bits.addr2_5 = etdev->addr[4];
-	uni_pf2.bits.addr2_6 = etdev->addr[5];
+	uni_pf2 = (etdev->addr[2] << ET_UNI_PF_ADDR2_3_SHIFT) |
+		  (etdev->addr[3] << ET_UNI_PF_ADDR2_4_SHIFT) |
+		  (etdev->addr[4] << ET_UNI_PF_ADDR2_5_SHIFT) |
+		   etdev->addr[5];
 
-	uni_pf1.bits.addr1_3 = etdev->addr[2];
-	uni_pf1.bits.addr1_4 = etdev->addr[3];
-	uni_pf1.bits.addr1_5 = etdev->addr[4];
-	uni_pf1.bits.addr1_6 = etdev->addr[5];
+	uni_pf1 = (etdev->addr[2] << ET_UNI_PF_ADDR1_3_SHIFT) |
+		  (etdev->addr[3] << ET_UNI_PF_ADDR1_4_SHIFT) |
+		  (etdev->addr[4] << ET_UNI_PF_ADDR1_5_SHIFT) |
+		   etdev->addr[5];
 
 	pm_csr = readl(&etdev->regs->global.pm_csr);
 	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
-		writel(uni_pf1.value, &rxmac->uni_pf_addr1.value);
-		writel(uni_pf2.value, &rxmac->uni_pf_addr2.value);
-		writel(uni_pf3.value, &rxmac->uni_pf_addr3.value);
+		writel(uni_pf1, &rxmac->uni_pf_addr1);
+		writel(uni_pf2, &rxmac->uni_pf_addr2);
+		writel(uni_pf3, &rxmac->uni_pf_addr3);
 	}
 }
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index bc8d385..190db0b 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -108,7 +108,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev);
 int PhyMiRead(struct et131x_adapter *etdev, u8 xcvrAddr,
 	      u8 xcvrReg, u16 *value)
 {
-	struct MAC_t __iomem *mac = &etdev->regs->mac;
+	struct mac_regs __iomem *mac = &etdev->regs->mac;
 	int status = 0;
 	u32 delay;
 	u32 miiAddr;
@@ -176,7 +176,7 @@ int PhyMiRead(struct et131x_adapter *etdev, u8 xcvrAddr,
  */
 int MiWrite(struct et131x_adapter *etdev, u8 xcvrReg, u16 value)
 {
-	struct MAC_t __iomem *mac = &etdev->regs->mac;
+	struct mac_regs __iomem *mac = &etdev->regs->mac;
 	int status = 0;
 	u8 xcvrAddr = etdev->Stats.xcvr_addr;
 	u32 delay;
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 87905e7..0cbf699 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -186,7 +186,7 @@ struct et131x_adapter {
 	u8 MCList[NIC_MAX_MCAST_LIST][ETH_ALEN];
 
 	/* Pointer to the device's PCI register space */
-	struct ADDRESS_MAP_t __iomem *regs;
+	struct address_map __iomem *regs;
 
 	/* Registry parameters */
 	u8 SpeedDuplex;		/* speed/duplex */
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 7c7b464..11700b5 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -245,7 +245,7 @@ void et131x_isr_handler(struct work_struct *work)
 	struct et131x_adapter *etdev =
 		container_of(work, struct et131x_adapter, task);
 	u32 status = etdev->Stats.InterruptStatus;
-	struct ADDRESS_MAP_t __iomem *iomem = etdev->regs;
+	struct address_map __iomem *iomem = etdev->regs;
 
 	/*
 	 * These first two are by far the most common.  Once handled, we clear
-- 
1.7.4.4

