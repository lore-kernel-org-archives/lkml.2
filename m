Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2H2NpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:45:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2H2NpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:45:23 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/rts_pstor: remove braces {} in rtsx_chip.c
Date: Wed, 29 Aug 2012 22:45:15 +0900
Message-Id: <1346247915-7776-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/rtsx_chip.c |  563 ++++++++++++++-------------------
 1 file changed, 246 insertions(+), 317 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_chip.c b/drivers/staging/rts_pstor/rtsx_chip.c
index 5452069..d8e691b 100644
--- a/drivers/staging/rts_pstor/rtsx_chip.c
+++ b/drivers/staging/rts_pstor/rtsx_chip.c
@@ -105,11 +105,10 @@ void rtsx_enable_bus_int(struct rtsx_chip *chip)
 		reg |= DELINK_INT_EN;
 #ifdef SUPPORT_OCP
 	if (CHECK_PID(chip, 0x5209)) {
-		if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
+		if (CHECK_LUN_MODE(chip, SD_MS_2LUN))
 			reg |= MS_OC_INT_EN | SD_OC_INT_EN;
-		} else {
+		else
 			reg |= SD_OC_INT_EN;
-		}
 	} else {
 		reg |= OC_INT_EN;
 	}
@@ -186,20 +185,20 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 		u8 cd_toggle_mask = 0;
 
 		RTSX_READ_REG(chip, TLPTISTAT, &tmp);
-		if (CHECK_PID(chip, 0x5209)) {
+		if (CHECK_PID(chip, 0x5209))
 			cd_toggle_mask = 0x10;
-		} else {
+		else
 			cd_toggle_mask = 0x08;
-		}
+
 		if (tmp & cd_toggle_mask) {
 			/* Disable sdio_bus_auto_switch */
-			if (CHECK_PID(chip, 0x5288)) {
+			if (CHECK_PID(chip, 0x5288))
 				RTSX_WRITE_REG(chip, 0xFE5A, 0x08, 0x00);
-			} else if (CHECK_PID(chip, 0x5208)) {
+			else if (CHECK_PID(chip, 0x5208))
 				RTSX_WRITE_REG(chip, 0xFE70, 0x80, 0x00);
-			} else {
+			else
 				RTSX_WRITE_REG(chip, SDIO_CFG, SDIO_BUS_AUTO_SWITCH, 0);
-			}
+
 			RTSX_WRITE_REG(chip, TLPTISTAT, 0xFF, tmp);
 
 			chip->need_reset |= SD_CARD;
@@ -208,16 +207,14 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 
 			if (chip->asic_code) {
 				retval = sd_pull_ctl_enable(chip);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			} else {
 				RTSX_WRITE_REG(chip, FPGA_PULL_CTL, FPGA_SD_PULL_CTL_BIT | 0x20, 0);
 			}
 			retval = card_share_mode(chip, SD_CARD);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			/* Enable sdio_bus_auto_switch */
 			if (CHECK_PID(chip, 0x5288)) {
@@ -232,11 +229,11 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 			chip->sd_io = 1;
 		}
 	} else {
-		if (CHECK_PID(chip, 0x5209)) {
+		if (CHECK_PID(chip, 0x5209))
 			RTSX_WRITE_REG(chip, TLPTISTAT, 0x10, 0x10);
-		} else {
+		else
 			RTSX_WRITE_REG(chip, TLPTISTAT, 0x08, 0x08);
-		}
+
 		chip->need_reset |= SD_CARD;
 	}
 
@@ -257,48 +254,47 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 		/* optimize PHY */
 		retval = rtsx_write_phy_register(chip, 0x00, 0xB966);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = rtsx_write_phy_register(chip, 0x01, 0x713F);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = rtsx_write_phy_register(chip, 0x03, 0xA549);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = rtsx_write_phy_register(chip, 0x06, 0xB235);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = rtsx_write_phy_register(chip, 0x07, 0xEF40);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = rtsx_write_phy_register(chip, 0x1E, 0xF8EB);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		retval = rtsx_write_phy_register(chip, 0x19, 0xFE6C);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		wait_timeout(1);
 		retval = rtsx_write_phy_register(chip, 0x0A, 0x05C0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 
 		retval = rtsx_write_cfg_dw(chip, 1, 0x110, 0xFFFF, 0xFFFF);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = rtsx_read_phy_register(chip, 0x08, &val);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		RTSX_DEBUGP("Read from phy 0x08: 0x%04x\n", val);
 
 		if (chip->phy_voltage) {
@@ -308,9 +304,9 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 			val |= chip->phy_voltage;
 			RTSX_DEBUGP("Write to phy 0x08: 0x%04x\n", val);
 			retval = rtsx_write_phy_register(chip, 0x08, val);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 		} else {
 			chip->phy_voltage = (u8)(val & 0x3F);
 			RTSX_DEBUGP("Default, chip->phy_voltage = 0x%x\n", chip->phy_voltage);
@@ -324,11 +320,11 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_OCP
 	/* SSC power on, OCD power on */
-	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
+	if (CHECK_LUN_MODE(chip, SD_MS_2LUN))
 		RTSX_WRITE_REG(chip, FPDCTL, OC_POWER_DOWN, 0);
-	} else {
+	else
 		RTSX_WRITE_REG(chip, FPDCTL, OC_POWER_DOWN, MS_OC_POWER_DOWN);
-	}
+
 	if (CHECK_PID(chip, 0x5209)) {
 		RTSX_WRITE_REG(chip, OCPPARA1, SD_OCP_TIME_MASK | MS_OCP_TIME_MASK,
 				    SD_OCP_TIME_800 | MS_OCP_TIME_800);
@@ -352,9 +348,8 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	RTSX_WRITE_REG(chip, FPDCTL, OC_POWER_DOWN, OC_POWER_DOWN);
 #endif
 
-	if (!CHECK_PID(chip, 0x5288)) {
+	if (!CHECK_PID(chip, 0x5288))
 		RTSX_WRITE_REG(chip, CARD_GPIO_DIR, 0xFF, 0x03);
-	}
 
 	/* Turn off LED */
 	RTSX_WRITE_REG(chip, CARD_GPIO, 0xFF, 0x03);
@@ -364,9 +359,8 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 	/* Card driving select */
 	RTSX_WRITE_REG(chip, CARD_DRIVE_SEL, 0xFF, chip->card_drive_sel);
-	if (CHECK_PID(chip, 0x5209)) {
+	if (CHECK_PID(chip, 0x5209))
 		RTSX_WRITE_REG(chip, SD30_DRIVE_SEL, 0x07, chip->sd30_drive_sel_3v3);
-	}
 
 #ifdef LED_AUTO_BLINK
 	RTSX_WRITE_REG(chip, CARD_AUTO_BLINK, 0xFF,
@@ -394,36 +388,34 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 			if (CHK_SDIO_EXIST(chip)) {
 				if (CHECK_PID(chip, 0x5209)) {
 					retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-					if (retval != STATUS_SUCCESS) {
+					if (retval != STATUS_SUCCESS)
 						TRACE_RET(chip, STATUS_FAIL);
-					}
+
 				} else if (CHECK_PID(chip, 0x5288)) {
 					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-					if (retval != STATUS_SUCCESS) {
+					if (retval != STATUS_SUCCESS)
 						TRACE_RET(chip, STATUS_FAIL);
-					}
 				}
 			}
 		} else {
-			if (CHECK_PID(chip, 0x5208)) {
+			if (CHECK_PID(chip, 0x5208))
 				RTSX_WRITE_REG(chip, ASPM_FORCE_CTL, 0xFF, 0x3F);
-			}
 
 			retval = rtsx_write_config_byte(chip, LCTLR, chip->aspm_l0s_l1_en);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 			chip->aspm_level[0] = chip->aspm_l0s_l1_en;
 			if (CHK_SDIO_EXIST(chip)) {
 				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
-				if (CHECK_PID(chip, 0x5288)) {
+				if (CHECK_PID(chip, 0x5288))
 					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-				} else {
+				else
 					retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-				}
-				if (retval != STATUS_SUCCESS) {
+
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 			}
 
 			chip->aspm_enabled = 1;
@@ -431,49 +423,45 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	} else {
 		if (chip->asic_code && CHECK_PID(chip, 0x5208)) {
 			retval = rtsx_write_phy_register(chip, 0x07, 0x0129);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 		retval = rtsx_write_config_byte(chip, LCTLR, chip->aspm_l0s_l1_en);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	retval = rtsx_write_config_byte(chip, 0x81, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (CHK_SDIO_EXIST(chip)) {
-		if (CHECK_PID(chip, 0x5288)) {
+		if (CHECK_PID(chip, 0x5288))
 			retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF00, 0x0100);
-		} else {
+		else
 			retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF00, 0x0100);
-		}
-		if (retval != STATUS_SUCCESS) {
+
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 	}
 
 	if (CHECK_PID(chip, 0x5209)) {
 		retval = rtsx_write_cfg_dw(chip, 0, 0x70C, 0xFF000000, 0x5B);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	if (CHECK_PID(chip, 0x5288)) {
 		if (!CHK_SDIO_EXIST(chip)) {
 			retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFFFF, 0x0103);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 			retval = rtsx_write_cfg_dw(chip, 2, 0x84, 0xFF, 0x03);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 		}
 	}
 
@@ -499,29 +487,29 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 			if (chip->ic_version >= IC_VER_D) {
 				u16 reg;
 				retval = rtsx_read_phy_register(chip, 0x00, &reg);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 				reg &= 0xFE7F;
 				reg |= 0x80;
 				retval = rtsx_write_phy_register(chip, 0x00, reg);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 				retval = rtsx_read_phy_register(chip, 0x1C, &reg);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 				reg &= 0xFFF7;
 				retval = rtsx_write_phy_register(chip, 0x1C, reg);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
+
 			}
 
-			if (chip->driver_first_load && (chip->ic_version < IC_VER_C)) {
+			if (chip->driver_first_load && (chip->ic_version < IC_VER_C))
 				rtsx_calibration(chip);
-			}
+
 		} else {
 			rtsx_enable_bus_int(chip);
 		}
@@ -550,18 +538,18 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	RTSX_DEBUGP("In rtsx_reset_chip, chip->int_reg = 0x%x\n", chip->int_reg);
 	if (chip->int_reg & SD_EXIST) {
 #ifdef HW_AUTO_SWITCH_SD_BUS
-		if (CHECK_PID(chip, 0x5208) && (chip->ic_version < IC_VER_C)) {
+		if (CHECK_PID(chip, 0x5208) && (chip->ic_version < IC_VER_C))
 			retval = rtsx_pre_handle_sdio_old(chip);
-		} else {
+		else
 			retval = rtsx_pre_handle_sdio_new(chip);
-		}
+
 		RTSX_DEBUGP("chip->need_reset = 0x%x (rtsx_reset_chip)\n", (unsigned int)(chip->need_reset));
 #else  /* HW_AUTO_SWITCH_SD_BUS */
 		retval = rtsx_pre_handle_sdio_old(chip);
 #endif  /* HW_AUTO_SWITCH_SD_BUS */
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 	} else {
 		chip->sd_io = 0;
 		RTSX_WRITE_REG(chip, SDIO_CTRL, SDIO_BUS_CTRL | SDIO_CD_CTRL, 0);
@@ -572,9 +560,8 @@ NextCard:
 		chip->need_reset |= XD_CARD;
 	if (chip->int_reg & MS_EXIST)
 		chip->need_reset |= MS_CARD;
-	if (chip->int_reg & CARD_EXIST) {
+	if (chip->int_reg & CARD_EXIST)
 		RTSX_WRITE_REG(chip, SSC_CTL1, SSC_RSTB, SSC_RSTB);
-	}
 
 	RTSX_DEBUGP("In rtsx_init_chip, chip->need_reset = 0x%x\n", (unsigned int)(chip->need_reset));
 
@@ -587,9 +574,8 @@ NextCard:
 
 	if (chip->remote_wakeup_en && !chip->auto_delink_en) {
 		RTSX_WRITE_REG(chip, WAKE_SEL_CTL, 0x07, 0x07);
-		if (chip->aux_pwr_exist) {
+		if (chip->aux_pwr_exist)
 			RTSX_WRITE_REG(chip, PME_FORCE_CTL, 0xFF, 0x33);
-		}
 	} else {
 		RTSX_WRITE_REG(chip, WAKE_SEL_CTL, 0x07, 0x04);
 		RTSX_WRITE_REG(chip, PME_FORCE_CTL, 0xFF, 0x30);
@@ -598,18 +584,16 @@ NextCard:
 	if (CHECK_PID(chip, 0x5208) && (chip->ic_version >= IC_VER_D)) {
 		RTSX_WRITE_REG(chip, PETXCFG, 0x1C, 0x14);
 	} else if (CHECK_PID(chip, 0x5209)) {
-		if (chip->force_clkreq_0) {
+		if (chip->force_clkreq_0)
 			RTSX_WRITE_REG(chip, PETXCFG, 0x08, 0x08);
-		} else {
+		else
 			RTSX_WRITE_REG(chip, PETXCFG, 0x08, 0x00);
-		}
 	}
 
 	if (chip->asic_code && CHECK_PID(chip, 0x5208)) {
 		retval = rtsx_clr_phy_reg_bit(chip, 0x1C, 2);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	if (chip->ft2_fast_mode) {
@@ -665,11 +649,10 @@ static int rts5209_init(struct rtsx_chip *chip)
 	u8 val = 0;
 
 	val = rtsx_readb(chip, 0x1C);
-	if ((val & 0x10) == 0) {
+	if ((val & 0x10) == 0)
 		chip->asic_code = 1;
-	} else {
+	else
 		chip->asic_code = 0;
-	}
 
 	chip->ic_version = val & 0x0F;
 	chip->phy_debug_mode = 0;
@@ -679,9 +662,9 @@ static int rts5209_init(struct rtsx_chip *chip)
 	chip->ms_power_class_en = 0x03;
 
 	retval = rtsx_read_cfg_dw(chip, 0, 0x724, &lval);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	RTSX_DEBUGP("dw in 0x724: 0x%x\n", lval);
 	val = (u8)lval;
 	if (!(val & 0x80)) {
@@ -690,17 +673,16 @@ static int rts5209_init(struct rtsx_chip *chip)
 		else
 			chip->lun_mode = SD_MS_2LUN;
 
-		if (val & 0x04) {
+		if (val & 0x04)
 			SET_SDIO_EXIST(chip);
-		} else {
+		else
 			CLR_SDIO_EXIST(chip);
-		}
 
-		if (val & 0x02) {
+		if (val & 0x02)
 			chip->hw_bypass_sd = 0;
-		} else {
+		else
 			chip->hw_bypass_sd = 1;
-		}
+
 	} else {
 		SET_SDIO_EXIST(chip);
 		chip->hw_bypass_sd = 0;
@@ -714,24 +696,21 @@ static int rts5209_init(struct rtsx_chip *chip)
 		val = (u8)(lval >> 8);
 
 		clk = (val >> 5) & 0x07;
-		if (clk != 0x07) {
+		if (clk != 0x07)
 			chip->asic_sd_sdr50_clk = 98 - clk * 2;
-		}
 
-		if (val & 0x10) {
+		if (val & 0x10)
 			chip->auto_delink_en = 1;
-		} else {
+		else
 			chip->auto_delink_en = 0;
-		}
 
 		if (chip->ss_en == 2) {
 			chip->ss_en = 0;
 		} else {
-			if (val & 0x08) {
+			if (val & 0x08)
 				chip->ss_en = 1;
-			} else {
+			else
 				chip->ss_en = 0;
-			}
 		}
 
 		clk = val & 0x07;
@@ -750,21 +729,21 @@ static int rts5209_init(struct rtsx_chip *chip)
 		if (clk != 0x03)
 			chip->asic_sd_ddr50_clk = (48 - clk * 2) * 2;
 
-		if (val & 0x01) {
+		if (val & 0x01)
 			chip->sdr104_en = 1;
-		} else {
+		else
 			chip->sdr104_en = 0;
-		}
-		if (val & 0x02) {
+
+		if (val & 0x02)
 			chip->ddr50_en = 1;
-		} else {
+		else
 			chip->ddr50_en = 0;
-		}
-		if (val & 0x04) {
+
+		if (val & 0x04)
 			chip->sdr50_en = 1;
-		} else {
+		else
 			chip->sdr50_en = 0;
-		}
+
 
 		val = (u8)(lval >> 24);
 
@@ -772,11 +751,10 @@ static int rts5209_init(struct rtsx_chip *chip)
 		if (clk != 0x07)
 			chip->asic_sd_sdr104_clk = 206 - clk * 3;
 
-		if (val & 0x10) {
+		if (val & 0x10)
 			chip->power_down_in_ss = 1;
-		} else {
+		else
 			chip->power_down_in_ss = 0;
-		}
 
 		chip->ms_power_class_en = val & 0x03;
 	}
@@ -786,20 +764,19 @@ static int rts5209_init(struct rtsx_chip *chip)
 
 		retval = rtsx_read_pci_cfg_byte(0x00,
 						0x1C, 0x02, 0x58, &reg58);
-		if (retval < 0) {
+		if (retval < 0)
 			return STATUS_SUCCESS;
-		}
+
 		retval = rtsx_read_pci_cfg_byte(0x00,
 						0x1C, 0x02, 0x5B, &reg5b);
-		if (retval < 0) {
+		if (retval < 0)
 			return STATUS_SUCCESS;
-		}
 
 		RTSX_DEBUGP("reg58 = 0x%x, reg5b = 0x%x\n", reg58, reg5b);
 
-		if ((reg58 == 0x00) && (reg5b == 0x01)) {
+		if ((reg58 == 0x00) && (reg5b == 0x01))
 			chip->auto_delink_en = 0;
-		}
+
 	}
 
 	return STATUS_SUCCESS;
@@ -813,24 +790,23 @@ static int rts5208_init(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, CLK_SEL, 0x03, 0x03);
 	RTSX_READ_REG(chip, CLK_SEL, &val);
-	if (val == 0) {
+	if (val == 0)
 		chip->asic_code = 1;
-	} else {
+	else
 		chip->asic_code = 0;
-	}
 
 	if (chip->asic_code) {
 		retval = rtsx_read_phy_register(chip, 0x1C, &reg);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		RTSX_DEBUGP("Value of phy register 0x1C is 0x%x\n", reg);
 		chip->ic_version = (reg >> 4) & 0x07;
-		if (reg & PHY_DEBUG_MODE) {
+		if (reg & PHY_DEBUG_MODE)
 			chip->phy_debug_mode = 1;
-		} else {
+		else
 			chip->phy_debug_mode = 0;
-		}
+
 	} else {
 		RTSX_READ_REG(chip, 0xFE80, &val);
 		chip->ic_version = val;
@@ -839,33 +815,29 @@ static int rts5208_init(struct rtsx_chip *chip)
 
 	RTSX_READ_REG(chip, PDINFO, &val);
 	RTSX_DEBUGP("PDINFO: 0x%x\n", val);
-	if (val & AUX_PWR_DETECTED) {
+	if (val & AUX_PWR_DETECTED)
 		chip->aux_pwr_exist = 1;
-	} else {
+	else
 		chip->aux_pwr_exist = 0;
-	}
 
 	RTSX_READ_REG(chip, 0xFE50, &val);
-	if (val & 0x01) {
+	if (val & 0x01)
 		chip->hw_bypass_sd = 1;
-	} else {
+	else
 		chip->hw_bypass_sd = 0;
-	}
 
 	rtsx_read_config_byte(chip, 0x0E, &val);
-	if (val & 0x80) {
+	if (val & 0x80)
 		SET_SDIO_EXIST(chip);
-	} else {
+	else
 		CLR_SDIO_EXIST(chip);
-	}
 
 	if (chip->use_hw_setting) {
 		RTSX_READ_REG(chip, CHANGE_LINK_STATE, &val);
-		if (val & 0x80) {
+		if (val & 0x80)
 			chip->auto_delink_en = 1;
-		} else {
+		else
 			chip->auto_delink_en = 0;
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -879,63 +851,57 @@ static int rts5288_init(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, CLK_SEL, 0x03, 0x03);
 	RTSX_READ_REG(chip, CLK_SEL, &val);
-	if (val == 0) {
+	if (val == 0)
 		chip->asic_code = 1;
-	} else {
+	else
 		chip->asic_code = 0;
-	}
 
 	chip->ic_version = 0;
 	chip->phy_debug_mode = 0;
 
 	RTSX_READ_REG(chip, PDINFO, &val);
 	RTSX_DEBUGP("PDINFO: 0x%x\n", val);
-	if (val & AUX_PWR_DETECTED) {
+	if (val & AUX_PWR_DETECTED)
 		chip->aux_pwr_exist = 1;
-	} else {
+	else
 		chip->aux_pwr_exist = 0;
-	}
 
 	RTSX_READ_REG(chip, CARD_SHARE_MODE, &val);
 	RTSX_DEBUGP("CARD_SHARE_MODE: 0x%x\n", val);
-	if (val & 0x04) {
+	if (val & 0x04)
 		chip->baro_pkg = QFN;
-	} else {
+	else
 		chip->baro_pkg = LQFP;
-	}
 
 	RTSX_READ_REG(chip, 0xFE5A, &val);
-	if (val & 0x10) {
+	if (val & 0x10)
 		chip->hw_bypass_sd = 1;
-	} else {
+	else
 		chip->hw_bypass_sd = 0;
-	}
 
 	retval = rtsx_read_cfg_dw(chip, 0, 0x718, &lval);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	max_func = (u8)((lval >> 29) & 0x07);
 	RTSX_DEBUGP("Max function number: %d\n", max_func);
-	if (max_func == 0x02) {
+	if (max_func == 0x02)
 		SET_SDIO_EXIST(chip);
-	} else {
+	else
 		CLR_SDIO_EXIST(chip);
-	}
 
 	if (chip->use_hw_setting) {
 		RTSX_READ_REG(chip, CHANGE_LINK_STATE, &val);
-		if (val & 0x80) {
+		if (val & 0x80)
 			chip->auto_delink_en = 1;
-		} else {
+		else
 			chip->auto_delink_en = 0;
-		}
 
-		if (CHECK_BARO_PKG(chip, LQFP)) {
+		if (CHECK_BARO_PKG(chip, LQFP))
 			chip->lun_mode = SD_MS_1LUN;
-		} else {
+		else
 			chip->lun_mode = DEFAULT_SINGLE;
-		}
+
 	}
 
 	return STATUS_SUCCESS;
@@ -990,22 +956,21 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 		chip->rw_fail_cnt[i] = 0;
 	}
 
-	if (!check_sd_speed_prior(chip->sd_speed_prior)) {
+	if (!check_sd_speed_prior(chip->sd_speed_prior))
 		chip->sd_speed_prior = 0x01040203;
-	}
+
 	RTSX_DEBUGP("sd_speed_prior = 0x%08x\n", chip->sd_speed_prior);
 
-	if (!check_sd_current_prior(chip->sd_current_prior)) {
+	if (!check_sd_current_prior(chip->sd_current_prior))
 		chip->sd_current_prior = 0x00010203;
-	}
+
 	RTSX_DEBUGP("sd_current_prior = 0x%08x\n", chip->sd_current_prior);
 
-	if ((chip->sd_ddr_tx_phase > 31) || (chip->sd_ddr_tx_phase < 0)) {
+	if ((chip->sd_ddr_tx_phase > 31) || (chip->sd_ddr_tx_phase < 0))
 		chip->sd_ddr_tx_phase = 0;
-	}
-	if ((chip->mmc_ddr_tx_phase > 31) || (chip->mmc_ddr_tx_phase < 0)) {
+
+	if ((chip->mmc_ddr_tx_phase > 31) || (chip->mmc_ddr_tx_phase < 0))
 		chip->mmc_ddr_tx_phase = 0;
-	}
 
 	RTSX_WRITE_REG(chip, FPDCTL, SSC_POWER_DOWN, 0);
 	wait_timeout(200);
@@ -1014,24 +979,23 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 
 	if (CHECK_PID(chip, 0x5209)) {
 		retval = rts5209_init(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 	} else if (CHECK_PID(chip, 0x5208)) {
 		retval = rts5208_init(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 	} else if (CHECK_PID(chip, 0x5288)) {
 		retval = rts5288_init(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 	}
 
-	if (chip->ss_en == 2) {
+	if (chip->ss_en == 2)
 		chip->ss_en = 0;
-	}
 
 	RTSX_DEBUGP("chip->asic_code = %d\n", chip->asic_code);
 	RTSX_DEBUGP("chip->ic_version = 0x%x\n", chip->ic_version);
@@ -1068,9 +1032,8 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 	}
 
 	retval = rtsx_reset_chip(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1118,19 +1081,19 @@ static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 			chip->aspm_level[1] = reg1;
 		}
 
-		if ((reg0 & 0x03) && (reg1 & 0x03)) {
+		if ((reg0 & 0x03) && (reg1 & 0x03))
 			maybe_support_aspm = 1;
-		}
+
 	} else {
-		if (reg0 & 0x03) {
+		if (reg0 & 0x03)
 			maybe_support_aspm = 1;
-		}
+
 	}
 
 	if (reg_changed) {
-		if (maybe_support_aspm) {
+		if (maybe_support_aspm)
 			chip->aspm_l0s_l1_en = 0x03;
-		}
+
 		RTSX_DEBUGP("aspm_level[0] = 0x%02x, aspm_level[1] = 0x%02x\n",
 			      chip->aspm_level[0], chip->aspm_level[1]);
 
@@ -1177,13 +1140,13 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 			if (chip->ocp_int & MS_OC_INT)
 				ms_power_off_card3v3(chip);
 		} else {
-			if (chip->card_exist & SD_CARD) {
+			if (chip->card_exist & SD_CARD)
 				sd_power_off_card3v3(chip);
-			} else if (chip->card_exist & MS_CARD) {
+			else if (chip->card_exist & MS_CARD)
 				ms_power_off_card3v3(chip);
-			} else if (chip->card_exist & XD_CARD) {
+			else if (chip->card_exist & XD_CARD)
 				xd_power_off_card3v3(chip);
-			}
+
 		}
 
 		chip->ocp_int = 0;
@@ -1226,9 +1189,9 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 			if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip)) {
 				u32 val;
 				rtsx_read_cfg_dw(chip, 1, 0x04, &val);
-				if (val & 0x07) {
+				if (val & 0x07)
 					ss_allowed = 0;
-				}
+
 			}
 		}
 	} else {
@@ -1284,9 +1247,9 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 			turn_off_led(chip, LED_GPIO);
 
-			if (chip->auto_power_down && !chip->card_ready && !chip->sd_io) {
+			if (chip->auto_power_down && !chip->card_ready && !chip->sd_io)
 				rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
-			}
+
 		}
 	}
 
@@ -1299,9 +1262,9 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		break;
 
 	case RTSX_STAT_IDLE:
-		if (chip->sd_io && !chip->sd_int) {
+		if (chip->sd_io && !chip->sd_int)
 			try_to_switch_sdio_ctrl(chip);
-		}
+
 		rtsx_enable_aspm(chip);
 		break;
 
@@ -1313,9 +1276,8 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 #ifdef SUPPORT_OCP
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
 #ifdef CONFIG_RTS_PSTOR_DEBUG
-		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER | MS_OC_NOW | MS_OC_EVER)) {
+		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER | MS_OC_NOW | MS_OC_EVER))
 			RTSX_DEBUGP("Over current, OCPSTAT is 0x%x\n", chip->ocp_stat);
-		}
 #endif
 
 		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER)) {
@@ -1362,28 +1324,27 @@ Delink_Stage:
 			if (chip->auto_delink_cnt == delink_stage1_cnt) {
 				rtsx_set_stat(chip, RTSX_STAT_DELINK);
 
-				if (chip->asic_code && CHECK_PID(chip, 0x5208)) {
+				if (chip->asic_code && CHECK_PID(chip, 0x5208))
 					rtsx_set_phy_reg_bit(chip, 0x1C, 2);
-				}
+
 				if (chip->card_exist) {
 					RTSX_DEBUGP("False card inserted, do force delink\n");
 
-					if (enter_L1) {
+					if (enter_L1)
 						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
-					}
+
 					rtsx_write_register(chip, CHANGE_LINK_STATE, 0x0A, 0x0A);
 
-					if (enter_L1) {
+					if (enter_L1)
 						rtsx_enter_L1(chip);
-					}
 
 					chip->auto_delink_cnt = delink_stage3_cnt + 1;
 				} else {
 					RTSX_DEBUGP("No card inserted, do delink\n");
 
-					if (enter_L1) {
+					if (enter_L1)
 						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
-					}
+
 #ifdef HW_INT_WRITE_CLR
 					if (CHECK_PID(chip, 0x5209)) {
 						rtsx_writel(chip, RTSX_BIPR, 0xFFFFFFFF);
@@ -1392,22 +1353,21 @@ Delink_Stage:
 #endif
 					rtsx_write_register(chip, CHANGE_LINK_STATE, 0x02, 0x02);
 
-					if (enter_L1) {
+					if (enter_L1)
 						rtsx_enter_L1(chip);
-					}
+
 				}
 			}
 
 			if (chip->auto_delink_cnt == delink_stage2_cnt) {
 				RTSX_DEBUGP("Try to do force delink\n");
 
-				if (enter_L1) {
+				if (enter_L1)
 					rtsx_exit_L1(chip);
-				}
 
-				if (chip->asic_code && CHECK_PID(chip, 0x5208)) {
+				if (chip->asic_code && CHECK_PID(chip, 0x5208))
 					rtsx_set_phy_reg_bit(chip, 0x1C, 2);
-				}
+
 				rtsx_write_register(chip, CHANGE_LINK_STATE, 0x0A, 0x0A);
 			}
 
@@ -1472,9 +1432,9 @@ int rtsx_write_register(struct rtsx_chip *chip, u16 addr, u8 mask, u8 data)
 	for (i = 0; i < MAX_RW_REG_CNT; i++) {
 		val = rtsx_readl(chip, RTSX_HAIMR);
 		if ((val & (1 << 31)) == 0) {
-			if (data != (u8)val) {
+			if (data != (u8)val)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 			return STATUS_SUCCESS;
 		}
 	}
@@ -1487,9 +1447,8 @@ int rtsx_read_register(struct rtsx_chip *chip, u16 addr, u8 *data)
 	u32 val = 2 << 30;
 	int i;
 
-	if (data) {
+	if (data)
 		*data = 0;
-	}
 
 	val |= (u32)(addr & 0x3FFF) << 16;
 
@@ -1497,18 +1456,15 @@ int rtsx_read_register(struct rtsx_chip *chip, u16 addr, u8 *data)
 
 	for (i = 0; i < MAX_RW_REG_CNT; i++) {
 		val = rtsx_readl(chip, RTSX_HAIMR);
-		if ((val & (1 << 31)) == 0) {
+		if ((val & (1 << 31)) == 0)
 			break;
-		}
 	}
 
-	if (i >= MAX_RW_REG_CNT) {
+	if (i >= MAX_RW_REG_CNT)
 		TRACE_RET(chip, STATUS_TIMEDOUT);
-	}
 
-	if (data) {
+	if (data)
 		*data = (u8)(val & 0xFF);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1537,9 +1493,8 @@ int rtsx_write_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 mask, u3
 
 		for (i = 0; i < MAX_RW_REG_CNT; i++) {
 			RTSX_READ_REG(chip, CFGRWCTL, &tmp);
-			if ((tmp & 0x80) == 0) {
+			if ((tmp & 0x80) == 0)
 				break;
-			}
 		}
 	}
 
@@ -1558,9 +1513,8 @@ int rtsx_read_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 *val)
 
 	for (i = 0; i < MAX_RW_REG_CNT; i++) {
 		RTSX_READ_REG(chip, CFGRWCTL, &tmp);
-		if ((tmp & 0x80) == 0) {
+		if ((tmp & 0x80) == 0)
 			break;
-		}
 	}
 
 	for (i = 0; i < 4; i++) {
@@ -1568,9 +1522,8 @@ int rtsx_read_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 *val)
 		data |= (u32)tmp << (i * 8);
 	}
 
-	if (val) {
+	if (val)
 		*val = data;
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1585,21 +1538,19 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf, int l
 
 	RTSX_DEBUGP("%s\n", __func__);
 
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, STATUS_NOMEM);
-	}
 
-	if ((len + offset) % 4) {
+	if ((len + offset) % 4)
 		dw_len = (len + offset) / 4 + 1;
-	} else {
+	else
 		dw_len = (len + offset) / 4;
-	}
+
 	RTSX_DEBUGP("dw_len = %d\n", dw_len);
 
 	data = vzalloc(dw_len * 4);
-	if (!data) {
+	if (!data)
 		TRACE_RET(chip, STATUS_NOMEM);
-	}
 
 	mask = vzalloc(dw_len * 4);
 	if (!mask) {
@@ -1645,17 +1596,16 @@ int rtsx_read_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf, int le
 
 	RTSX_DEBUGP("%s\n", __func__);
 
-	if ((len + offset) % 4) {
+	if ((len + offset) % 4)
 		dw_len = (len + offset) / 4 + 1;
-	} else {
+	else
 		dw_len = (len + offset) / 4;
-	}
+
 	RTSX_DEBUGP("dw_len = %d\n", dw_len);
 
 	data = (u32 *)vmalloc(dw_len * 4);
-	if (!data) {
+	if (!data)
 		TRACE_RET(chip, STATUS_NOMEM);
-	}
 
 	for (i = 0; i < dw_len; i++) {
 		retval = rtsx_read_cfg_dw(chip, func, aligned_addr + i * 4, data + i);
@@ -1700,9 +1650,8 @@ int rtsx_write_phy_register(struct rtsx_chip *chip, u8 addr, u16 val)
 		}
 	}
 
-	if (!finished) {
+	if (!finished)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1724,9 +1673,8 @@ int rtsx_read_phy_register(struct rtsx_chip *chip, u8 addr, u16 *val)
 		}
 	}
 
-	if (!finished) {
+	if (!finished)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_READ_REG(chip, PHYDATA0, &tmp);
 	data = tmp;
@@ -1753,9 +1701,8 @@ int rtsx_read_efuse(struct rtsx_chip *chip, u8 addr, u8 *val)
 		udelay(1);
 	}
 
-	if (data & 0x80) {
+	if (data & 0x80)
 		TRACE_RET(chip, STATUS_TIMEDOUT);
-	}
 
 	RTSX_READ_REG(chip, EFUSE_DATA, &data);
 	if (val)
@@ -1786,9 +1733,8 @@ int rtsx_write_efuse(struct rtsx_chip *chip, u8 addr, u8 val)
 			wait_timeout(3);
 		}
 
-		if (data & 0x80) {
+		if (data & 0x80)
 			TRACE_RET(chip, STATUS_TIMEDOUT);
-		}
 
 		wait_timeout(5);
 	}
@@ -1802,15 +1748,14 @@ int rtsx_clr_phy_reg_bit(struct rtsx_chip *chip, u8 reg, u8 bit)
 	u16 value;
 
 	retval = rtsx_read_phy_register(chip, reg, &value);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	if (value & (1 << bit)) {
 		value &= ~(1 << bit);
 		retval = rtsx_write_phy_register(chip, reg, value);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -1822,15 +1767,14 @@ int rtsx_set_phy_reg_bit(struct rtsx_chip *chip, u8 reg, u8 bit)
 	u16 value;
 
 	retval = rtsx_read_phy_register(chip, reg, &value);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	if (0 == (value & (1 << bit))) {
 		value |= (1 << bit);
 		retval = rtsx_write_phy_register(chip, reg, value);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -1861,11 +1805,11 @@ static void rtsx_handle_pm_dstate(struct rtsx_chip *chip, u8 dstate)
 	if (CHK_SDIO_EXIST(chip)) {
 		u8 func_no;
 
-		if (CHECK_PID(chip, 0x5288)) {
+		if (CHECK_PID(chip, 0x5288))
 			func_no = 2;
-		} else {
+		else
 			func_no = 1;
-		}
+
 		rtsx_read_cfg_dw(chip, func_no, 0x84, &ultmp);
 		RTSX_DEBUGP("pm_dstate of function %d: 0x%x\n", (int)func_no, ultmp);
 		rtsx_write_cfg_dw(chip, func_no, 0x84, 0xFF, dstate);
@@ -1898,11 +1842,10 @@ void rtsx_enter_ss(struct rtsx_chip *chip)
 	}
 
 	if (CHK_SDIO_EXIST(chip)) {
-		if (CHECK_PID(chip, 0x5288)) {
+		if (CHECK_PID(chip, 0x5288))
 			rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF00, 0x0100);
-		} else {
+		else
 			rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF00, 0x0100);
-		}
 	}
 
 	if (chip->auto_delink_en) {
@@ -1953,11 +1896,11 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 	u32 ocp_int = 0;
 
 	if (CHECK_PID(chip, 0x5209)) {
-		if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
+		if (CHECK_LUN_MODE(chip, SD_MS_2LUN))
 			ocp_int = MS_OC_INT | SD_OC_INT;
-		} else {
+		else
 			ocp_int = SD_OC_INT;
-		}
+
 	} else {
 		ocp_int = OC_INT;
 	}
@@ -1976,9 +1919,8 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 	chip->int_reg = rtsx_readl(chip, RTSX_BIPR);
 
 #ifdef HW_INT_WRITE_CLR
-	if (CHECK_PID(chip, 0x5209)) {
+	if (CHECK_PID(chip, 0x5209))
 		rtsx_writel(chip, RTSX_BIPR, chip->int_reg);
-	}
 #endif
 
 	if (((chip->int_reg & int_enable) == 0) || (chip->int_reg == 0xFFFFFFFF))
@@ -1988,9 +1930,8 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 		if (CHECK_PID(chip, 0x5209)) {
 			u8 val;
 			rtsx_read_config_byte(chip, 0x05, &val);
-			if (val & 0x04) {
+			if (val & 0x04)
 				return STATUS_FAIL;
-			}
 		}
 	}
 
@@ -2107,16 +2048,15 @@ void rtsx_do_before_power_down(struct rtsx_chip *chip, int pm_stat)
 		RTSX_DEBUGP("Host enter S1\n");
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, HOST_ENTER_S1);
 	} else if (pm_stat == PM_S3) {
-		if (chip->s3_pwr_off_delay > 0) {
+		if (chip->s3_pwr_off_delay > 0)
 			wait_timeout(chip->s3_pwr_off_delay);
-		}
+
 		RTSX_DEBUGP("Host enter S3\n");
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, HOST_ENTER_S3);
 	}
 
-	if (chip->do_delink_before_power_down && chip->auto_delink_en) {
+	if (chip->do_delink_before_power_down && chip->auto_delink_en)
 		rtsx_write_register(chip, CHANGE_LINK_STATE, 0x02, 2);
-	}
 
 	rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
 
@@ -2143,11 +2083,10 @@ void rtsx_enable_aspm(struct rtsx_chip *chip)
 
 			if (CHK_SDIO_EXIST(chip)) {
 				u16 val = chip->aspm_l0s_l1_en | 0x0100;
-				if (CHECK_PID(chip, 0x5288)) {
+				if (CHECK_PID(chip, 0x5288))
 					rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFFFF, val);
-				} else {
+				else
 					rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFFFF, val);
-				}
 			}
 		}
 	}
@@ -2167,11 +2106,11 @@ void rtsx_disable_aspm(struct rtsx_chip *chip)
 
 			if (chip->asic_code && CHECK_PID(chip, 0x5208))
 				rtsx_write_phy_register(chip, 0x07, 0x0129);
-			if (CHECK_PID(chip, 0x5208)) {
+			if (CHECK_PID(chip, 0x5208))
 				rtsx_write_register(chip, ASPM_FORCE_CTL, 0xF3, 0x30);
-			} else {
+			else
 				rtsx_write_config_byte(chip, LCTLR, 0x00);
-			}
+
 			wait_timeout(1);
 		}
 	}
@@ -2186,9 +2125,8 @@ int rtsx_read_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 	u16 reg_addr;
 	u8 *ptr;
 
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	ptr = buf;
 	reg_addr = PPBUF_BASE2;
@@ -2199,9 +2137,8 @@ int rtsx_read_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr++, 0, 0);
 
 		retval = rtsx_send_cmd(chip, 0, 250);
-		if (retval < 0) {
+		if (retval < 0)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		memcpy(ptr, rtsx_get_cmd_data(chip), 256);
 		ptr += 256;
@@ -2214,9 +2151,8 @@ int rtsx_read_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr++, 0, 0);
 
 		retval = rtsx_send_cmd(chip, 0, 250);
-		if (retval < 0) {
+		if (retval < 0)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	memcpy(ptr, rtsx_get_cmd_data(chip), buf_len%256);
@@ -2231,9 +2167,8 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 	u16 reg_addr;
 	u8 *ptr;
 
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	ptr = buf;
 	reg_addr = PPBUF_BASE2;
@@ -2246,9 +2181,8 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 		}
 
 		retval = rtsx_send_cmd(chip, 0, 250);
-		if (retval < 0) {
+		if (retval < 0)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	if (buf_len%256) {
@@ -2260,9 +2194,8 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 		}
 
 		retval = rtsx_send_cmd(chip, 0, 250);
-		if (retval < 0) {
+		if (retval < 0)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -2270,9 +2203,8 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 
 int rtsx_check_chip_exist(struct rtsx_chip *chip)
 {
-	if (rtsx_readl(chip, 0) == 0xFFFFFFFF) {
+	if (rtsx_readl(chip, 0) == 0xFFFFFFFF)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -2288,17 +2220,15 @@ int rtsx_force_power_on(struct rtsx_chip *chip, u8 ctl)
 #ifdef SUPPORT_OCP
 	if (ctl & OC_PDCTL) {
 		mask |= SD_OC_POWER_DOWN;
-		if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
+		if (CHECK_LUN_MODE(chip, SD_MS_2LUN))
 			mask |= MS_OC_POWER_DOWN;
-		}
 	}
 #endif
 
 	if (mask) {
 		retval = rtsx_write_register(chip, FPDCTL, mask, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if (CHECK_PID(chip, 0x5288))
 			wait_timeout(200);
@@ -2326,9 +2256,8 @@ int rtsx_force_power_down(struct rtsx_chip *chip, u8 ctl)
 	if (mask) {
 		val = mask;
 		retval = rtsx_write_register(chip, FPDCTL, mask, val);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
-- 
1.7.9.5

