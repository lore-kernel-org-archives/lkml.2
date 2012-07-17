Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2GQWoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:44:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52365 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2GQWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:44:12 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH v3] staging: sbe-2t3e3: Remove code that will never execute
Date: Tue, 17 Jul 2012 19:41:25 -0300
Message-Id: <1342564885-6678-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all references of "if 0" blocks in the sbe-2t3e3 driver.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 Changes from v2-v1:
	Just fix the typo sbr-2t3e3 for sbe-2t3e3.

 Greg, here is the update patch with the comments in the right place.

 drivers/staging/sbe-2t3e3/2t3e3.h    |    3 --
 drivers/staging/sbe-2t3e3/cpld.c     |   15 ---------
 drivers/staging/sbe-2t3e3/ctrl.c     |   19 +++--------
 drivers/staging/sbe-2t3e3/dc.c       |   17 ----------
 drivers/staging/sbe-2t3e3/exar7250.c |   40 +++--------------------
 drivers/staging/sbe-2t3e3/exar7300.c |   17 ----------
 drivers/staging/sbe-2t3e3/intr.c     |   60 ++--------------------------------
 drivers/staging/sbe-2t3e3/io.c       |   21 ------------
 8 files changed, 10 insertions(+), 182 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/2t3e3.h b/drivers/staging/sbe-2t3e3/2t3e3.h
index fe9f086..383f2cf 100644
--- a/drivers/staging/sbe-2t3e3/2t3e3.h
+++ b/drivers/staging/sbe-2t3e3/2t3e3.h


@@ -801,9 +801,6 @@ u32 cpld_read(struct channel *sc, u32 reg);
 void cpld_set_crc(struct channel *, u32);
 void cpld_start_intr(struct channel *);
 void cpld_stop_intr(struct channel *);
-#if 0
-void cpld_led_onoff(struct channel *, u32, u32, u32, u32);
-#endif
 void cpld_set_clock(struct channel *sc, u32 mode);
 void cpld_set_scrambler(struct channel *, u32);
 void cpld_select_panel(struct channel *, u32);
diff --git a/drivers/staging/sbe-2t3e3/cpld.c b/drivers/staging/sbe-2t3e3/cpld.c
index b0fc2dd..cc2b54d 100644
--- a/drivers/staging/sbe-2t3e3/cpld.c
+++ b/drivers/staging/sbe-2t3e3/cpld.c
@@ -41,14 +41,6 @@ static inline void cpld_clear_bit(struct channel *channel, unsigned reg, u32 bit
 void cpld_init(struct channel *sc)
 {
 	u32 val;
-#if 0
-	/* reset LIU and Framer */
-	val = cpld_val_map[SBE_2T3E3_CPLD_VAL_LIU_FRAMER_RESET][sc->h.slot];
-	cpld_write(sc, SBE_2T3E3_CPLD_REG_STATIC_RESET, val);
-	udelay(10000); /* TODO - how long? */
-	val = 0;
-	cpld_write(sc, SBE_2T3E3_CPLD_REG_STATIC_RESET, val);
-#endif
 
 	/* PCRA */
 	val = SBE_2T3E3_CPLD_VAL_CRC32 |
@@ -109,13 +101,6 @@ void cpld_start_intr(struct channel *sc)
 	val = SBE_2T3E3_CPLD_VAL_INTERRUPT_FROM_ETHERNET_ENABLE |
 		SBE_2T3E3_CPLD_VAL_INTERRUPT_FROM_FRAMER_ENABLE;
 	cpld_write(sc, SBE_2T3E3_CPLD_REG_PIER, val);
-#if 0
-	/*
-	  do you want to hang up your computer?
-	  ENABLE REST OF INTERRUPTS !!!
-	  you have been warned :).
-	*/
-#endif
 }
 
 void cpld_stop_intr(struct channel *sc)
diff --git a/drivers/staging/sbe-2t3e3/ctrl.c b/drivers/staging/sbe-2t3e3/ctrl.c
index d9dd216..a5825d7 100644
--- a/drivers/staging/sbe-2t3e3/ctrl.c
+++ b/drivers/staging/sbe-2t3e3/ctrl.c
@@ -230,11 +230,9 @@ void t3e3_port_get_stats(struct channel *sc,
 		result = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_E3_RX_CONFIGURATION_STATUS_2);
 		sc->s.LOF = result & SBE_2T3E3_FRAMER_VAL_E3_RX_LOF ? 1 : 0;
 		sc->s.OOF = result & SBE_2T3E3_FRAMER_VAL_E3_RX_OOF ? 1 : 0;
-#if 0
-		sc->s.LOS = result & SBE_2T3E3_FRAMER_VAL_E3_RX_LOS ? 1 : 0;
-#else
+
 		cpld_LOS_update(sc);
-#endif
+
 		sc->s.AIS = result & SBE_2T3E3_FRAMER_VAL_E3_RX_AIS ? 1 : 0;
 		sc->s.FERF = result & SBE_2T3E3_FRAMER_VAL_E3_RX_FERF ? 1 : 0;
 		break;
@@ -243,11 +241,9 @@ void t3e3_port_get_stats(struct channel *sc,
 	case SBE_2T3E3_FRAME_TYPE_T3_M13:
 		result = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_T3_RX_CONFIGURATION_STATUS);
 		sc->s.AIS = result & SBE_2T3E3_FRAMER_VAL_T3_RX_AIS ? 1 : 0;
-#if 0
-		sc->s.LOS = result & SBE_2T3E3_FRAMER_VAL_T3_RX_LOS ? 1 : 0;
-#else
+
 		cpld_LOS_update(sc);
-#endif
+
 		sc->s.IDLE = result & SBE_2T3E3_FRAMER_VAL_T3_RX_IDLE ? 1 : 0;
 		sc->s.OOF = result & SBE_2T3E3_FRAMER_VAL_T3_RX_OOF ? 1 : 0;
 
@@ -322,10 +318,6 @@ void t3e3_if_config(struct channel *sc, u32 cmd, char *set,
 		*rlen = sizeof(ret->u.data);
 		break;
 	case SBE_2T3E3_PORT_WRITE_REGS:
-#if 0
-		printk(KERN_DEBUG "SBE_2T3E3_PORT_WRITE_REGS, 0x%x, 0x%x, 0x%x\n",
-		       ((int*)data)[0], ((int*)data)[1], ((int*)data)[2]);
-#endif
 		t3e3_reg_write(sc, data);
 		*rlen = 0;
 		break;
@@ -336,9 +328,6 @@ void t3e3_if_config(struct channel *sc, u32 cmd, char *set,
 		*rlen = 0;
 		break;
 	}
-
-	/* turn on interrupt */
-	/* cpld_start_intr(sc); */
 }
 
 void t3e3_sc_init(struct channel *sc)
diff --git a/drivers/staging/sbe-2t3e3/dc.c b/drivers/staging/sbe-2t3e3/dc.c
index e897a43..9e81d90 100644
--- a/drivers/staging/sbe-2t3e3/dc.c
+++ b/drivers/staging/sbe-2t3e3/dc.c
@@ -63,14 +63,6 @@ void dc_init(struct channel *sc)
 	if (sc->p.loopback == SBE_2T3E3_LOOPBACK_ETHERNET)
 		sc->p.loopback = SBE_2T3E3_LOOPBACK_NONE;
 
-#if 0 /* No need to clear this register - and it may be in use */
-	/*
-	 * BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT (CSR9)
-	 */
-	val = 0;
-	dc_write(sc->addr, SBE_2T3E3_21143_REG_BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT, val);
-#endif
-
 	/*
 	 * GENERAL_PURPOSE_TIMER_AND_INTERRUPT_MITIGATION_CONTROL (CSR11)
 	 */
@@ -301,15 +293,6 @@ void dc_set_loopback(struct channel *sc, u32 mode)
 		return;
 	}
 
-#if 0
-	/* restart SIA */
-	dc_clear_bits(sc->addr, SBE_2T3E3_21143_REG_SIA_CONNECTIVITY,
-		      SBE_2T3E3_21143_VAL_SIA_RESET);
-	udelay(1000);
-	dc_set_bits(sc->addr, SBE_2T3E3_21143_REG_SIA_CONNECTIVITY,
-		    SBE_2T3E3_21143_VAL_SIA_RESET);
-#endif
-
 	/* select loopback mode */
 	val = dc_read(sc->addr, SBE_2T3E3_21143_REG_OPERATION_MODE) &
 		~SBE_2T3E3_21143_VAL_OPERATING_MODE;
diff --git a/drivers/staging/sbe-2t3e3/exar7250.c b/drivers/staging/sbe-2t3e3/exar7250.c
index 809f446..e3ddd14 100644
--- a/drivers/staging/sbe-2t3e3/exar7250.c
+++ b/drivers/staging/sbe-2t3e3/exar7250.c
@@ -78,64 +78,32 @@ void exar7250_start_intr(struct channel *sc, u32 type)
 	case SBE_2T3E3_FRAME_TYPE_E3_G751:
 	case SBE_2T3E3_FRAME_TYPE_E3_G832:
 		val = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_E3_RX_CONFIGURATION_STATUS_2);
-#if 0
-		sc->s.LOS = val & SBE_2T3E3_FRAMER_VAL_E3_RX_LOS ? 1 : 0;
-#else
+
 		cpld_LOS_update(sc);
-#endif
+
 		sc->s.OOF = val & SBE_2T3E3_FRAMER_VAL_E3_RX_OOF ? 1 : 0;
 		exar7250_read(sc, SBE_2T3E3_FRAMER_REG_E3_RX_INTERRUPT_STATUS_1);
 		exar7250_write(sc, SBE_2T3E3_FRAMER_REG_E3_RX_INTERRUPT_ENABLE_1,
 			       SBE_2T3E3_FRAMER_VAL_E3_RX_OOF_INTERRUPT_ENABLE |
 			       SBE_2T3E3_FRAMER_VAL_E3_RX_LOS_INTERRUPT_ENABLE);
-#if 0
-		/*SBE_2T3E3_FRAMER_VAL_E3_RX_COFA_INTERRUPT_ENABLE |
-		  SBE_2T3E3_FRAMER_VAL_E3_RX_OOF_INTERRUPT_ENABLE |
-		  SBE_2T3E3_FRAMER_VAL_E3_RX_LOF_INTERRUPT_ENABLE |
-		  SBE_2T3E3_FRAMER_VAL_E3_RX_LOS_INTERRUPT_ENABLE |
-		  SBE_2T3E3_FRAMER_VAL_E3_RX_AIS_INTERRUPT_ENABLE);*/
-#endif
 
 		exar7250_read(sc, SBE_2T3E3_FRAMER_REG_E3_RX_INTERRUPT_STATUS_2);
-#if 0
-		exar7250_write(sc, SBE_2T3E3_FRAMER_REG_E3_RX_INTERRUPT_ENABLE_2,
-			       SBE_2T3E3_FRAMER_VAL_E3_RX_FEBE_INTERRUPT_ENABLE |
-			       SBE_2T3E3_FRAMER_VAL_E3_RX_FERF_INTERRUPT_ENABLE |
-			       SBE_2T3E3_FRAMER_VAL_E3_RX_FRAMING_BYTE_ERROR_INTERRUPT_ENABLE);
-#endif
 		break;
 
 	case SBE_2T3E3_FRAME_TYPE_T3_CBIT:
 	case SBE_2T3E3_FRAME_TYPE_T3_M13:
 		val = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_T3_RX_CONFIGURATION_STATUS);
-#if 0
-		sc->s.LOS = val & SBE_2T3E3_FRAMER_VAL_T3_RX_LOS ? 1 : 0;
-#else
+
 		cpld_LOS_update(sc);
-#endif
+
 		sc->s.OOF = val & SBE_2T3E3_FRAMER_VAL_T3_RX_OOF ? 1 : 0;
 
 		exar7250_read(sc, SBE_2T3E3_FRAMER_REG_T3_RX_INTERRUPT_STATUS);
 		exar7250_write(sc, SBE_2T3E3_FRAMER_REG_T3_RX_INTERRUPT_ENABLE,
 			       SBE_2T3E3_FRAMER_VAL_T3_RX_LOS_INTERRUPT_ENABLE |
 			       SBE_2T3E3_FRAMER_VAL_T3_RX_OOF_INTERRUPT_ENABLE);
-#if 0
-		/* SBE_2T3E3_FRAMER_VAL_T3_RX_CP_BIT_ERROR_INTERRUPT_ENABLE |
-		   SBE_2T3E3_FRAMER_VAL_T3_RX_LOS_INTERRUPT_ENABLE |
-		   SBE_2T3E3_FRAMER_VAL_T3_RX_AIS_INTERRUPT_ENABLE |
-		   SBE_2T3E3_FRAMER_VAL_T3_RX_IDLE_INTERRUPT_ENABLE |
-		   SBE_2T3E3_FRAMER_VAL_T3_RX_FERF_INTERRUPT_ENABLE |
-		   SBE_2T3E3_FRAMER_VAL_T3_RX_AIC_INTERRUPT_ENABLE |
-		   SBE_2T3E3_FRAMER_VAL_T3_RX_OOF_INTERRUPT_ENABLE |
-		   SBE_2T3E3_FRAMER_VAL_T3_RX_P_BIT_INTERRUPT_ENABLE);*/
-#endif
 
 		exar7250_read(sc, SBE_2T3E3_FRAMER_REG_T3_RX_FEAC_INTERRUPT_ENABLE_STATUS);
-#if 0
-		exar7250_write(sc, SBE_2T3E3_FRAMER_REG_T3_RX_FEAC_INTERRUPT_ENABLE_STATUS,
-			       SBE_2T3E3_FRAMER_VAL_T3_RX_FEAC_REMOVE_INTERRUPT_ENABLE |
-			       SBE_2T3E3_FRAMER_VAL_T3_RX_FEAC_VALID_INTERRUPT_ENABLE);
-#endif
 
 		exar7250_write(sc, SBE_2T3E3_FRAMER_REG_T3_RX_LAPD_CONTROL, 0);
 		break;
diff --git a/drivers/staging/sbe-2t3e3/exar7300.c b/drivers/staging/sbe-2t3e3/exar7300.c
index d10d696..cd22999 100644
--- a/drivers/staging/sbe-2t3e3/exar7300.c
+++ b/drivers/staging/sbe-2t3e3/exar7300.c
@@ -43,23 +43,6 @@ void exar7300_set_loopback(struct channel *sc, u32 mode)
 	val &= ~(SBE_2T3E3_LIU_VAL_LOCAL_LOOPBACK | SBE_2T3E3_LIU_VAL_REMOTE_LOOPBACK);
 	val |= mode;
 	exar7300_write(sc, SBE_2T3E3_LIU_REG_REG4, val);
-
-#if 0
-	/* TODO - is it necessary? idea from 2T3E3_HW_Test_code */
-	switch (mode) {
-	case SBE_2T3E3_LIU_VAL_LOOPBACK_OFF:
-		break;
-	case SBE_2T3E3_LIU_VAL_LOOPBACK_REMOTE:
-		exar7300_receive_equalization_onoff(sc, SBE_2T3E3_ON);
-		break;
-	case SBE_2T3E3_LIU_VAL_LOOPBACK_ANALOG:
-		exar7300_receive_equalization_onoff(sc, SBE_2T3E3_OFF);
-		break;
-	case SBE_2T3E3_LIU_VAL_LOOPBACK_DIGITAL:
-		exar7300_receive_equalization_onoff(sc, SBE_2T3E3_ON);
-		break;
-	}
-#endif
 }
 
 void exar7300_set_frame_type(struct channel *sc, u32 type)
diff --git a/drivers/staging/sbe-2t3e3/intr.c b/drivers/staging/sbe-2t3e3/intr.c
index 1336aab..efdeb75 100644
--- a/drivers/staging/sbe-2t3e3/intr.c
+++ b/drivers/staging/sbe-2t3e3/intr.c
@@ -434,11 +434,6 @@ void exar7250_intr(struct channel *sc)
 {
 	u32 status, old_OOF;
 
-#if 0
-	/* disable interrupts */
-	exar7250_write(sc, SBE_2T3E3_FRAMER_REG_BLOCK_INTERRUPT_ENABLE, 0);
-#endif
-
 	old_OOF = sc->s.OOF;
 
 	status = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_BLOCK_INTERRUPT_STATUS);
@@ -479,13 +474,6 @@ void exar7250_intr(struct channel *sc)
 			dc_start_intr(sc);
 		}
 	}
-#if 0
-	/* reenable interrupts */
-	exar7250_write(sc, SBE_2T3E3_FRAMER_REG_BLOCK_INTERRUPT_ENABLE,
-		       SBE_2T3E3_FRAMER_VAL_RX_INTERRUPT_ENABLE |
-		       SBE_2T3E3_FRAMER_VAL_TX_INTERRUPT_ENABLE
-		);
-#endif
 }
 
 
@@ -503,16 +491,8 @@ void exar7250_T3_intr(struct channel *sc, u32 block_status)
 
 			result = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_T3_RX_CONFIGURATION_STATUS);
 
-#if 0
-			if (status & SBE_2T3E3_FRAMER_VAL_T3_RX_LOS_INTERRUPT_STATUS) {
-				dev_dbg(&sc->pdev->dev,
-					"Framer interrupt T3: LOS\n");
-				sc->s.LOS = result & SBE_2T3E3_FRAMER_VAL_T3_RX_LOS ? 1 : 0;
-
-			}
-#else
 			cpld_LOS_update(sc);
-#endif
+
 			if (status & SBE_2T3E3_FRAMER_VAL_T3_RX_OOF_INTERRUPT_STATUS) {
 				sc->s.OOF = result & SBE_2T3E3_FRAMER_VAL_T3_RX_OOF ? 1 : 0;
 				dev_dbg(&sc->pdev->dev,
@@ -523,16 +503,6 @@ void exar7250_T3_intr(struct channel *sc, u32 block_status)
 			exar7250_write(sc, SBE_2T3E3_FRAMER_REG_T3_RX_INTERRUPT_ENABLE,
 				       SBE_2T3E3_FRAMER_VAL_T3_RX_LOS_INTERRUPT_ENABLE |
 				       SBE_2T3E3_FRAMER_VAL_T3_RX_OOF_INTERRUPT_ENABLE);
-#if 0
-			SBE_2T3E3_FRAMER_VAL_T3_RX_CP_BIT_ERROR_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_T3_RX_LOS_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_T3_RX_AIS_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_T3_RX_IDLE_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_T3_RX_FERF_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_T3_RX_AIC_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_T3_RX_OOF_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_T3_RX_P_BIT_INTERRUPT_ENABLE
-#endif
 				}
 
 		status = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_T3_RX_FEAC_INTERRUPT_ENABLE_STATUS);
@@ -540,12 +510,6 @@ void exar7250_T3_intr(struct channel *sc, u32 block_status)
 			dev_dbg(&sc->pdev->dev,
 				"Framer interrupt T3 RX (REG[0x17] = %02X)\n",
 				status);
-#if 0
-			exar7250_write(sc, SBE_2T3E3_FRAMER_REG_T3_RX_FEAC_INTERRUPT_ENABLE_STATUS,
-				       SBE_2T3E3_FRAMER_VAL_T3_RX_FEAC_REMOVE_INTERRUPT_ENABLE |
-				       SBE_2T3E3_FRAMER_VAL_T3_RX_FEAC_VALID_INTERRUPT_ENABLE
-				);
-#endif
 		}
 
 		status = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_T3_RX_LAPD_CONTROL);
@@ -582,15 +546,8 @@ void exar7250_E3_intr(struct channel *sc, u32 block_status)
 
 			result = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_E3_RX_CONFIGURATION_STATUS_2);
 
-#if 0
-			if (status & SBE_2T3E3_FRAMER_VAL_E3_RX_LOS_INTERRUPT_STATUS) {
-				dev_dbg(&sc->pdev->dev,
-					"Framer interrupt E3: LOS\n");
-				sc->s.LOS = result & SBE_2T3E3_FRAMER_VAL_E3_RX_LOS ? 1 : 0;
-			}
-#else
 			cpld_LOS_update(sc);
-#endif
+
 			if (status & SBE_2T3E3_FRAMER_VAL_E3_RX_OOF_INTERRUPT_STATUS) {
 				sc->s.OOF = result & SBE_2T3E3_FRAMER_VAL_E3_RX_OOF ? 1 : 0;
 				dev_dbg(&sc->pdev->dev,
@@ -602,13 +559,6 @@ void exar7250_E3_intr(struct channel *sc, u32 block_status)
 				       SBE_2T3E3_FRAMER_VAL_E3_RX_OOF_INTERRUPT_ENABLE |
 				       SBE_2T3E3_FRAMER_VAL_E3_RX_LOS_INTERRUPT_ENABLE
 				);
-#if 0
-			SBE_2T3E3_FRAMER_VAL_E3_RX_COFA_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_E3_RX_OOF_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_E3_RX_LOF_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_E3_RX_LOS_INTERRUPT_ENABLE |
-				SBE_2T3E3_FRAMER_VAL_E3_RX_AIS_INTERRUPT_ENABLE
-#endif
 				}
 
 		status = exar7250_read(sc, SBE_2T3E3_FRAMER_REG_E3_RX_INTERRUPT_STATUS_2);
@@ -617,12 +567,6 @@ void exar7250_E3_intr(struct channel *sc, u32 block_status)
 				"Framer interrupt E3 RX (REG[0x15] = %02X)\n",
 				status);
 
-#if 0
-			exar7250_write(sc, SBE_2T3E3_FRAMER_REG_E3_RX_INTERRUPT_ENABLE_2,
-				       SBE_2T3E3_FRAMER_VAL_E3_RX_FEBE_INTERRUPT_ENABLE |
-				       SBE_2T3E3_FRAMER_VAL_E3_RX_FERF_INTERRUPT_ENABLE |
-				       SBE_2T3E3_FRAMER_VAL_E3_RX_FRAMING_BYTE_ERROR_INTERRUPT_ENABLE);
-#endif
 		}
 
 	}
diff --git a/drivers/staging/sbe-2t3e3/io.c b/drivers/staging/sbe-2t3e3/io.c
index d2391cb..c9947b1 100644
--- a/drivers/staging/sbe-2t3e3/io.c
+++ b/drivers/staging/sbe-2t3e3/io.c
@@ -199,15 +199,6 @@ u32 exar7250_read(struct channel *channel, u32 reg)
 	u32 result;
 	unsigned long flags;
 
-#if 0
-	switch (reg) {
-	case SBE_2T3E3_FRAMER_REG_OPERATING_MODE:
-		return channel->framer_regs[reg];
-		break;
-	default:
-	}
-#endif
-
 	spin_lock_irqsave(&channel->card->bootrom_lock, flags);
 
 	result = bootrom_read(channel, cpld_reg_map[SBE_2T3E3_CPLD_REG_FRAMER_BASE_ADDRESS]
@@ -243,18 +234,6 @@ u32 exar7300_read(struct channel *channel, u32 reg)
 	unsigned long addr = channel->card->bootrom_addr, flags;
 	u32 i, val;
 
-#if 0
-	switch (reg) {
-	case SBE_2T3E3_LIU_REG_REG1:
-	case SBE_2T3E3_LIU_REG_REG2:
-	case SBE_2T3E3_LIU_REG_REG3:
-	case SBE_2T3E3_LIU_REG_REG4:
-		return channel->liu_regs[reg];
-		break;
-	default:
-	}
-#endif
-
 	/* select correct Serial Chip */
 
 	spin_lock_irqsave(&channel->card->bootrom_lock, flags);
-- 
1.7.10.4

