Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2HaMXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:23:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59903 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2HaMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:23:37 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/rts_pstor: remove braces {} in rtsx_card.c
Date: Fri, 31 Aug 2012 21:23:29 +0900
Message-Id: <1346415809-20182-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/rtsx_card.c |  186 ++++++++++++++-------------------
 1 file changed, 81 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_card.c b/drivers/staging/rts_pstor/rtsx_card.c
index 4f971f2..539aa6a 100644
--- a/drivers/staging/rts_pstor/rtsx_card.c
+++ b/drivers/staging/rts_pstor/rtsx_card.c
@@ -309,11 +309,10 @@ static void release_sdio(struct rtsx_chip *chip)
 		if (chip->chip_insert_with_sdio) {
 			chip->chip_insert_with_sdio = 0;
 
-			if (CHECK_PID(chip, 0x5288)) {
+			if (CHECK_PID(chip, 0x5288))
 				rtsx_write_register(chip, 0xFE5A, 0x08, 0x00);
-			} else {
+			else
 				rtsx_write_register(chip, 0xFE70, 0x80, 0x00);
-			}
 		}
 
 		rtsx_write_register(chip, SDIO_CTRL, SDIO_CD_CTRL, 0);
@@ -379,11 +378,10 @@ void rtsx_reset_cards(struct rtsx_chip *chip)
 	if (chip->need_reset & XD_CARD) {
 		chip->card_exist |= XD_CARD;
 
-		if (chip->xd_show_cnt >= MAX_SHOW_CNT) {
+		if (chip->xd_show_cnt >= MAX_SHOW_CNT)
 			do_reset_xd_card(chip);
-		} else {
+		else
 			chip->xd_show_cnt++;
-		}
 	}
 	if (CHECK_PID(chip, 0x5288) && CHECK_BARO_PKG(chip, QFN)) {
 		if (chip->card_exist & XD_CARD) {
@@ -404,11 +402,10 @@ void rtsx_reset_cards(struct rtsx_chip *chip)
 	if (chip->need_reset & MS_CARD) {
 		chip->card_exist |= MS_CARD;
 
-		if (chip->ms_show_cnt >= MAX_SHOW_CNT) {
+		if (chip->ms_show_cnt >= MAX_SHOW_CNT)
 			do_reset_ms_card(chip);
-		} else {
+		else
 			chip->ms_show_cnt++;
-		}
 	}
 }
 
@@ -473,13 +470,12 @@ void card_cd_debounce(struct rtsx_chip *chip, unsigned long *need_reset, unsigne
 				release_map |= MS_CARD;
 		}
 	} else {
-		if (chip->int_reg & XD_EXIST) {
+		if (chip->int_reg & XD_EXIST)
 			reset_map |= XD_CARD;
-		} else if (chip->int_reg & SD_EXIST) {
+		else if (chip->int_reg & SD_EXIST)
 			reset_map |= SD_CARD;
-		} else if (chip->int_reg & MS_EXIST) {
+		else if (chip->int_reg & MS_EXIST)
 			reset_map |= MS_CARD;
-		}
 	}
 
 	if (reset_map) {
@@ -489,21 +485,21 @@ void card_cd_debounce(struct rtsx_chip *chip, unsigned long *need_reset, unsigne
 		for (i = 0; i < (DEBOUNCE_CNT); i++) {
 			chip->int_reg = rtsx_readl(chip, RTSX_BIPR);
 
-			if (chip->int_reg & XD_EXIST) {
+			if (chip->int_reg & XD_EXIST)
 				xd_cnt++;
-			} else {
+			else
 				xd_cnt = 0;
-			}
-			if (chip->int_reg & SD_EXIST) {
+
+			if (chip->int_reg & SD_EXIST)
 				sd_cnt++;
-			} else {
+			else
 				sd_cnt = 0;
-			}
-			if (chip->int_reg & MS_EXIST) {
+
+			if (chip->int_reg & MS_EXIST)
 				ms_cnt++;
-			} else {
+			else
 				ms_cnt = 0;
-			}
+
 			wait_timeout(30);
 		}
 
@@ -677,9 +673,8 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 
 	RTSX_DEBUGP("Switch SSC clock to %dMHz (cur_clk = %d)\n", clk, chip->cur_clk);
 
-	if ((clk <= 2) || (N > max_N)) {
+	if ((clk <= 2) || (N > max_N))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	mcu_cnt = (u8)(125/clk + 3);
 	if (CHECK_PID(chip, 0x5209)) {
@@ -700,32 +695,29 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 	if (chip->ssc_en) {
 		if (CHECK_PID(chip, 0x5209)) {
 			if (chip->cur_card == SD_CARD) {
-				if (CHK_SD_SDR104(sd_card)) {
+				if (CHK_SD_SDR104(sd_card))
 					ssc_depth = chip->ssc_depth_sd_sdr104;
-				} else if (CHK_SD_SDR50(sd_card)) {
+				else if (CHK_SD_SDR50(sd_card))
 					ssc_depth = chip->ssc_depth_sd_sdr50;
-				} else if (CHK_SD_DDR50(sd_card)) {
+				else if (CHK_SD_DDR50(sd_card))
 					ssc_depth = double_depth(chip->ssc_depth_sd_ddr50);
-				} else if (CHK_SD_HS(sd_card)) {
+				else if (CHK_SD_HS(sd_card))
 					ssc_depth = double_depth(chip->ssc_depth_sd_hs);
-				} else if (CHK_MMC_52M(sd_card) || CHK_MMC_DDR52(sd_card)) {
+				else if (CHK_MMC_52M(sd_card) || CHK_MMC_DDR52(sd_card))
 					ssc_depth = double_depth(chip->ssc_depth_mmc_52m);
-				} else {
+				else
 					ssc_depth = double_depth(chip->ssc_depth_low_speed);
-				}
 			} else if (chip->cur_card == MS_CARD) {
 				if (CHK_MSPRO(ms_card)) {
-					if (CHK_HG8BIT(ms_card)) {
+					if (CHK_HG8BIT(ms_card))
 						ssc_depth = double_depth(chip->ssc_depth_ms_hg);
-					} else {
+					else
 						ssc_depth = double_depth(chip->ssc_depth_ms_4bit);
-					}
 				} else {
-					if (CHK_MS4BIT(ms_card)) {
+					if (CHK_MS4BIT(ms_card))
 						ssc_depth = double_depth(chip->ssc_depth_ms_4bit);
-					} else {
+					else
 						ssc_depth = double_depth(chip->ssc_depth_low_speed);
-					}
 				}
 			} else {
 				ssc_depth = double_depth(chip->ssc_depth_low_speed);
@@ -733,23 +725,23 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 
 			if (ssc_depth) {
 				if (div == CLK_DIV_2) {
-					if (ssc_depth > 1) {
+					if (ssc_depth > 1)
 						ssc_depth -= 1;
-					} else {
+					else
 						ssc_depth = SSC_DEPTH_4M;
-					}
+
 				} else if (div == CLK_DIV_4) {
-					if (ssc_depth > 2) {
+					if (ssc_depth > 2)
 						ssc_depth -= 2;
-					} else {
+					else
 						ssc_depth = SSC_DEPTH_4M;
-					}
+
 				} else if (div == CLK_DIV_8) {
-					if (ssc_depth > 3) {
+					if (ssc_depth > 3)
 						ssc_depth -= 3;
-					} else {
+					else
 						ssc_depth = SSC_DEPTH_4M;
-					}
+
 				}
 			}
 		} else {
@@ -760,11 +752,10 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 		ssc_depth = 0;
 	}
 
-	if (CHECK_PID(chip, 0x5209)) {
+	if (CHECK_PID(chip, 0x5209))
 		ssc_depth_mask = SSC_DEPTH_MASK;
-	} else {
+	else
 		ssc_depth_mask = 0x03;
-	}
 
 	RTSX_DEBUGP("ssc_depth = %d\n", ssc_depth);
 
@@ -781,9 +772,8 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 	}
 
 	retval = rtsx_send_cmd(chip, 0, WAIT_TIME);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	udelay(10);
 	RTSX_WRITE_REG(chip, CLK_CTL, CLK_LOW_FREQ, 0);
@@ -976,25 +966,23 @@ int card_power_on(struct rtsx_chip *chip, u8 card)
 
 	rtsx_init_cmd(chip);
 	rtsx_add_cmd(chip, WRITE_REG_CMD, CARD_PWR_CTL, mask, val1);
-	if (CHECK_PID(chip, 0x5209) && (card == SD_CARD)) {
+	if (CHECK_PID(chip, 0x5209) && (card == SD_CARD))
 		rtsx_add_cmd(chip, WRITE_REG_CMD, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_SUSPEND);
-	}
+
 	retval = rtsx_send_cmd(chip, 0, 100);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	udelay(chip->pmos_pwr_on_interval);
 
 	rtsx_init_cmd(chip);
 	rtsx_add_cmd(chip, WRITE_REG_CMD, CARD_PWR_CTL, mask, val2);
-	if (CHECK_PID(chip, 0x5209) && (card == SD_CARD)) {
+	if (CHECK_PID(chip, 0x5209) && (card == SD_CARD))
 		rtsx_add_cmd(chip, WRITE_REG_CMD, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_ON);
-	}
+
 	retval = rtsx_send_cmd(chip, 0, 100);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1016,9 +1004,8 @@ int card_power_off(struct rtsx_chip *chip, u8 card)
 	}
 
 	RTSX_WRITE_REG(chip, CARD_PWR_CTL, mask, val);
-	if (CHECK_PID(chip, 0x5209) && (card == SD_CARD)) {
+	if (CHECK_PID(chip, 0x5209) && (card == SD_CARD))
 		RTSX_WRITE_REG(chip, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_OFF);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1029,9 +1016,8 @@ int card_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 sec_addr, u16 sec
 	unsigned int lun = SCSI_LUN(srb);
 	int i;
 
-	if (chip->rw_card[lun] == NULL) {
+	if (chip->rw_card[lun] == NULL)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	for (i = 0; i < 3; i++) {
 		chip->rw_need_retry = 0;
@@ -1042,9 +1028,9 @@ int card_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 sec_addr, u16 sec
 				rtsx_release_chip(chip);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
-			if (detect_card_cd(chip, chip->cur_card) != STATUS_SUCCESS) {
+			if (detect_card_cd(chip, chip->cur_card) != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 			if (!chip->rw_need_retry) {
 				RTSX_DEBUGP("RW fail, but no need to retry\n");
 				break;
@@ -1066,26 +1052,26 @@ int card_share_mode(struct rtsx_chip *chip, int card)
 
 	if (CHECK_PID(chip, 0x5209) || CHECK_PID(chip, 0x5208)) {
 		mask = CARD_SHARE_MASK;
-		if (card == SD_CARD) {
+		if (card == SD_CARD)
 			value = CARD_SHARE_48_SD;
-		} else if (card == MS_CARD) {
+		else if (card == MS_CARD)
 			value = CARD_SHARE_48_MS;
-		} else if (card == XD_CARD) {
+		else if (card == XD_CARD)
 			value = CARD_SHARE_48_XD;
-		} else {
+		else
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 	} else if (CHECK_PID(chip, 0x5288)) {
 		mask = 0x03;
-		if (card == SD_CARD) {
+		if (card == SD_CARD)
 			value = CARD_SHARE_BAROSSA_SD;
-		} else if (card == MS_CARD) {
+		else if (card == MS_CARD)
 			value = CARD_SHARE_BAROSSA_MS;
-		} else if (card == XD_CARD) {
+		else if (card == XD_CARD)
 			value = CARD_SHARE_BAROSSA_XD;
-		} else {
+		else
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 	} else {
 		TRACE_RET(chip, STATUS_FAIL);
 	}
@@ -1103,24 +1089,23 @@ int select_card(struct rtsx_chip *chip, int card)
 	if (chip->cur_card != card) {
 		u8 mod;
 
-		if (card == SD_CARD) {
+		if (card == SD_CARD)
 			mod = SD_MOD_SEL;
-		} else if (card == MS_CARD) {
+		else if (card == MS_CARD)
 			mod = MS_MOD_SEL;
-		} else if (card == XD_CARD) {
+		else if (card == XD_CARD)
 			mod = XD_MOD_SEL;
-		} else if (card == SPI_CARD) {
+		else if (card == SPI_CARD)
 			mod = SPI_MOD_SEL;
-		} else {
+		else
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		RTSX_WRITE_REG(chip, CARD_SELECT, 0x07, mod);
 		chip->cur_card = card;
 
 		retval =  card_share_mode(chip, card);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -1137,20 +1122,18 @@ void toggle_gpio(struct rtsx_chip *chip, u8 gpio)
 
 void turn_on_led(struct rtsx_chip *chip, u8 gpio)
 {
-	if (CHECK_PID(chip, 0x5288)) {
+	if (CHECK_PID(chip, 0x5288))
 		rtsx_write_register(chip, CARD_GPIO, (u8)(1 << gpio), (u8)(1 << gpio));
-	} else {
+	else
 		rtsx_write_register(chip, CARD_GPIO, (u8)(1 << gpio), 0);
-	}
 }
 
 void turn_off_led(struct rtsx_chip *chip, u8 gpio)
 {
-	if (CHECK_PID(chip, 0x5288)) {
+	if (CHECK_PID(chip, 0x5288))
 		rtsx_write_register(chip, CARD_GPIO, (u8)(1 << gpio), 0);
-	} else {
+	else
 		rtsx_write_register(chip, CARD_GPIO, (u8)(1 << gpio), (u8)(1 << gpio));
-	}
 }
 
 int detect_card_cd(struct rtsx_chip *chip, int card)
@@ -1169,67 +1152,60 @@ int detect_card_cd(struct rtsx_chip *chip, int card)
 	}
 
 	status = rtsx_readl(chip, RTSX_BIPR);
-	if (!(status & card_cd)) {
+	if (!(status & card_cd))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
 
 int check_card_exist(struct rtsx_chip *chip, unsigned int lun)
 {
-	if (chip->card_exist & chip->lun2card[lun]) {
+	if (chip->card_exist & chip->lun2card[lun])
 		return 1;
-	}
 
 	return 0;
 }
 
 int check_card_ready(struct rtsx_chip *chip, unsigned int lun)
 {
-	if (chip->card_ready & chip->lun2card[lun]) {
+	if (chip->card_ready & chip->lun2card[lun])
 		return 1;
-	}
 
 	return 0;
 }
 
 int check_card_wp(struct rtsx_chip *chip, unsigned int lun)
 {
-	if (chip->card_wp & chip->lun2card[lun]) {
+	if (chip->card_wp & chip->lun2card[lun])
 		return 1;
-	}
 
 	return 0;
 }
 
 int check_card_fail(struct rtsx_chip *chip, unsigned int lun)
 {
-	if (chip->card_fail & chip->lun2card[lun]) {
+	if (chip->card_fail & chip->lun2card[lun])
 		return 1;
-	}
 
 	return 0;
 }
 
 int check_card_ejected(struct rtsx_chip *chip, unsigned int lun)
 {
-	if (chip->card_ejected & chip->lun2card[lun]) {
+	if (chip->card_ejected & chip->lun2card[lun])
 		return 1;
-	}
 
 	return 0;
 }
 
 u8 get_lun_card(struct rtsx_chip *chip, unsigned int lun)
 {
-	if ((chip->card_ready & chip->lun2card[lun]) == XD_CARD) {
+	if ((chip->card_ready & chip->lun2card[lun]) == XD_CARD)
 		return (u8)XD_CARD;
-	} else if ((chip->card_ready & chip->lun2card[lun]) == SD_CARD) {
+	else if ((chip->card_ready & chip->lun2card[lun]) == SD_CARD)
 		return (u8)SD_CARD;
-	} else if ((chip->card_ready & chip->lun2card[lun]) == MS_CARD) {
+	else if ((chip->card_ready & chip->lun2card[lun]) == MS_CARD)
 		return (u8)MS_CARD;
-	}
 
 	return 0;
 }
-- 
1.7.9.5

