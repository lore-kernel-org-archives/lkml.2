Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2IINBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 09:01:45 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34341 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2IINBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 09:01:43 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/rts_pstor: remove braces {} in ms.c
Date: Sun,  9 Sep 2012 22:01:35 +0900
Message-Id: <1347195695-7214-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/ms.c |  872 ++++++++++++++++------------------------
 1 file changed, 340 insertions(+), 532 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 7cc2b53..16a5c16 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -109,9 +109,8 @@ static int ms_transfer_data(struct rtsx_chip *chip, u8 trans_mode, u8 tpc, u16 s
 	u8 val, err_code = 0;
 	enum dma_data_direction dir;
 
-	if (!buf || !buf_len) {
+	if (!buf || !buf_len)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (trans_mode == MS_TM_AUTO_READ) {
 		dir = DMA_FROM_DEVICE;
@@ -151,18 +150,17 @@ static int ms_transfer_data(struct rtsx_chip *chip, u8 trans_mode, u8 tpc, u16 s
 				    use_sg, dir, chip->mspro_timeout);
 	if (retval < 0) {
 		ms_set_err_code(chip, err_code);
-		if (retval == -ETIMEDOUT) {
+		if (retval == -ETIMEDOUT)
 			retval = STATUS_TIMEDOUT;
-		} else {
+		else
 			retval = STATUS_FAIL;
-		}
+
 		TRACE_RET(chip, retval);
 	}
 
 	RTSX_READ_REG(chip, MS_TRANS_CFG, &val);
-	if (val & (MS_INT_CMDNK | MS_INT_ERR | MS_CRC16_ERR | MS_RDY_TIMEOUT)) {
+	if (val & (MS_INT_CMDNK | MS_INT_ERR | MS_CRC16_ERR | MS_RDY_TIMEOUT))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -173,9 +171,8 @@ static int ms_write_bytes(struct rtsx_chip *chip,
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval, i;
 
-	if (!data || (data_len < cnt)) {
+	if (!data || (data_len < cnt))
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -183,9 +180,8 @@ static int ms_write_bytes(struct rtsx_chip *chip,
 		rtsx_add_cmd(chip, WRITE_REG_CMD,
 			     PPBUF_BASE2 + i, 0xFF, data[i]);
 	}
-	if (cnt % 2) {
+	if (cnt % 2)
 		rtsx_add_cmd(chip, WRITE_REG_CMD, PPBUF_BASE2 + i, 0xFF, 0xFF);
-	}
 
 	rtsx_add_cmd(chip, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
 	rtsx_add_cmd(chip, WRITE_REG_CMD, MS_BYTE_CNT, 0xFF, cnt);
@@ -238,9 +234,8 @@ static int ms_read_bytes(struct rtsx_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 *dat
 	int retval, i;
 	u8 *ptr;
 
-	if (!data) {
+	if (!data)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -252,14 +247,13 @@ static int ms_read_bytes(struct rtsx_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 *dat
 	rtsx_add_cmd(chip, WRITE_REG_CMD, MS_TRANSFER, 0xFF, MS_TRANSFER_START | MS_TM_READ_BYTES);
 	rtsx_add_cmd(chip, CHECK_REG_CMD, MS_TRANSFER, MS_TRANSFER_END, MS_TRANSFER_END);
 
-	for (i = 0; i < data_len - 1; i++) {
+	for (i = 0; i < data_len - 1; i++)
 	       rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2 + i, 0, 0);
-	}
-	if (data_len % 2) {
+
+	if (data_len % 2)
 		rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2 + data_len, 0, 0);
-	} else {
+	else
 		rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2 + data_len - 1, 0, 0);
-	}
 
 	retval = rtsx_send_cmd(chip, MS_CARD, 5000);
 	if (retval < 0) {
@@ -293,9 +287,8 @@ static int ms_read_bytes(struct rtsx_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 *dat
 
 	ptr = rtsx_get_cmd_data(chip) + 1;
 
-	for (i = 0; i < data_len; i++) {
+	for (i = 0; i < data_len; i++)
 		data[i] = ptr[i];
-	}
 
 	if ((tpc == PRO_READ_SHORT_DATA) && (data_len == 8)) {
 		RTSX_DEBUGP("Read format progress:\n");
@@ -343,34 +336,31 @@ static int ms_set_init_para(struct rtsx_chip *chip)
 	int retval;
 
 	if (CHK_HG8BIT(ms_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			ms_card->ms_clock = chip->asic_ms_hg_clk;
-		} else {
+		else
 			ms_card->ms_clock = chip->fpga_ms_hg_clk;
-		}
+
 	} else if (CHK_MSPRO(ms_card) || CHK_MS4BIT(ms_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			ms_card->ms_clock = chip->asic_ms_4bit_clk;
-		} else {
+		else
 			ms_card->ms_clock = chip->fpga_ms_4bit_clk;
-		}
+
 	} else {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			ms_card->ms_clock = chip->asic_ms_1bit_clk;
-		} else {
+		else
 			ms_card->ms_clock = chip->fpga_ms_1bit_clk;
-		}
 	}
 
 	retval = switch_clock(chip, ms_card->ms_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = select_card(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -381,14 +371,12 @@ static int ms_switch_clock(struct rtsx_chip *chip)
 	int retval;
 
 	retval = select_card(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = switch_clock(chip, ms_card->ms_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -461,9 +449,8 @@ static int ms_pull_ctl_enable(struct rtsx_chip *chip)
 	}
 
 	retval = rtsx_send_cmd(chip, MS_CARD, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -482,40 +469,37 @@ static int ms_prepare_reset(struct rtsx_chip *chip)
 	ms_card->pro_under_formatting = 0;
 
 	retval = ms_power_off_card3v3(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (!chip->ft2_fast_mode)
 		wait_timeout(250);
 
 	retval = enable_card_clock(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (chip->asic_code) {
 		retval = ms_pull_ctl_enable(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		RTSX_WRITE_REG(chip, FPGA_PULL_CTL, FPGA_MS_PULL_CTL_BIT | 0x20, 0);
 	}
 
 	if (!chip->ft2_fast_mode) {
 		retval = card_power_on(chip, MS_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		wait_timeout(150);
 
 #ifdef SUPPORT_OCP
-		if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
+		if (CHECK_LUN_MODE(chip, SD_MS_2LUN))
 			oc_mask = MS_OC_NOW | MS_OC_EVER;
-		} else {
+		else
 			oc_mask = SD_OC_NOW | SD_OC_EVER;
-		}
+
 		if (chip->ocp_stat & oc_mask) {
 			RTSX_DEBUGP("Over current, OCPSTAT is 0x%x\n",
 				     chip->ocp_stat);
@@ -539,9 +523,8 @@ static int ms_prepare_reset(struct rtsx_chip *chip)
 	RTSX_WRITE_REG(chip, CARD_STOP, MS_STOP | MS_CLR_ERR, MS_STOP | MS_CLR_ERR);
 
 	retval = ms_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -553,26 +536,23 @@ static int ms_identify_media_type(struct rtsx_chip *chip, int switch_8bit_bus)
 	u8 val;
 
 	retval = ms_set_rw_reg_addr(chip, Pro_StatusReg, 6, SystemParm, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 		retval = ms_transfer_tpc(chip, MS_TM_READ_BYTES, READ_REG, 6, NO_WAIT_INT);
-		if (retval == STATUS_SUCCESS) {
+		if (retval == STATUS_SUCCESS)
 			break;
-		}
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_READ_REG(chip, PPBUF_BASE2 + 2, &val);
 	RTSX_DEBUGP("Type register: 0x%x\n", val);
 	if (val != 0x01) {
-		if (val != 0x02) {
+		if (val != 0x02)
 			ms_card->check_ms_flow = 1;
-		}
+
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
@@ -587,11 +567,11 @@ static int ms_identify_media_type(struct rtsx_chip *chip, int switch_8bit_bus)
 	RTSX_DEBUGP("Class register: 0x%x\n", val);
 	if (val == 0) {
 		RTSX_READ_REG(chip, PPBUF_BASE2, &val);
-		if (val & WRT_PRTCT) {
+		if (val & WRT_PRTCT)
 			chip->card_wp |= MS_CARD;
-		} else {
+		else
 			chip->card_wp &= ~MS_CARD;
-		}
+
 	} else if ((val == 0x01) || (val == 0x02) || (val == 0x03)) {
 		chip->card_wp |= MS_CARD;
 	} else {
@@ -606,11 +586,11 @@ static int ms_identify_media_type(struct rtsx_chip *chip, int switch_8bit_bus)
 	if (val == 0) {
 		ms_card->ms_type &= 0x0F;
 	} else if (val == 7) {
-		if (switch_8bit_bus) {
+		if (switch_8bit_bus)
 			ms_card->ms_type |= MS_HG;
-		} else {
+		else
 			ms_card->ms_type &= 0x0F;
-		}
+
 	} else {
 		TRACE_RET(chip, STATUS_FAIL);
 	}
@@ -633,17 +613,15 @@ static int ms_confirm_cpu_startup(struct rtsx_chip *chip)
 
 		for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 			retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-			if (retval == STATUS_SUCCESS) {
+			if (retval == STATUS_SUCCESS)
 				break;
-			}
 		}
-		if (i == MS_MAX_RETRY_COUNT) {
+		if (i == MS_MAX_RETRY_COUNT)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
-		if (k > 100) {
+		if (k > 100)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		k++;
 		wait_timeout(100);
 	} while (!(val & INT_REG_CED));
@@ -653,16 +631,14 @@ static int ms_confirm_cpu_startup(struct rtsx_chip *chip)
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (val & INT_REG_ERR) {
-		if (val & INT_REG_CMDNK) {
+		if (val & INT_REG_CMDNK)
 			chip->card_wp |= (MS_CARD);
-		} else {
+		else
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 	/* --  end confirm CPU startup */
 
@@ -681,9 +657,8 @@ static int ms_switch_parallel_bus(struct rtsx_chip *chip)
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -698,26 +673,22 @@ static int ms_switch_8bit_bus(struct rtsx_chip *chip)
 	data[1] = 0;
 	for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 		retval = ms_write_bytes(chip, WRITE_REG, 1, NO_WAIT_INT, data, 2);
-		if (retval == STATUS_SUCCESS) {
+		if (retval == STATUS_SUCCESS)
 			break;
-		}
 	}
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, MS_CFG, 0x98, MS_BUS_WIDTH_8 | SAMPLE_TIME_FALLING);
 	ms_card->ms_type |= MS_8BIT;
 	retval = ms_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 		retval = ms_transfer_tpc(chip, MS_TM_READ_BYTES, GET_INT, 1, NO_WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -730,19 +701,16 @@ static int ms_pro_reset_flow(struct rtsx_chip *chip, int switch_8bit_bus)
 
 	for (i = 0; i < 3; i++) {
 		retval = ms_prepare_reset(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = ms_identify_media_type(chip, switch_8bit_bus);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = ms_confirm_cpu_startup(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = ms_switch_parallel_bus(chip);
 		if (retval != STATUS_SUCCESS) {
@@ -756,18 +724,16 @@ static int ms_pro_reset_flow(struct rtsx_chip *chip, int switch_8bit_bus)
 		}
 	}
 
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	/* Switch MS-PRO into Parallel mode */
 	RTSX_WRITE_REG(chip, MS_CFG, 0x18, MS_BUS_WIDTH_4);
 	RTSX_WRITE_REG(chip, MS_CFG, PUSH_TIME_ODD, PUSH_TIME_ODD);
 
 	retval = ms_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	/* If MSPro HG Card, We shall try to switch to 8-bit bus */
 	if (CHK_MSHG(ms_card) && chip->support_ms_8bit && switch_8bit_bus) {
@@ -790,9 +756,8 @@ static int msxc_change_power(struct rtsx_chip *chip, u8 mode)
 	ms_cleanup_work(chip);
 
 	retval = ms_set_rw_reg_addr(chip, 0, 0, Pro_DataCount1, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	buf[0] = 0;
 	buf[1] = mode;
@@ -802,19 +767,16 @@ static int msxc_change_power(struct rtsx_chip *chip, u8 mode)
 	buf[5] = 0;
 
 	retval = ms_write_bytes(chip, PRO_WRITE_REG , 6, NO_WAIT_INT, buf, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_send_cmd(chip, XC_CHG_POWER, WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_READ_REG(chip, MS_TRANS_CFG, buf);
-	if (buf[0] & (MS_INT_CMDNK | MS_INT_ERR)) {
+	if (buf[0] & (MS_INT_CMDNK | MS_INT_ERR))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -836,15 +798,14 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 #endif
 
 	retval = ms_set_rw_reg_addr(chip, Pro_IntReg, 2, Pro_SystemParm, 7);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (CHK_MS8BIT(ms_card)) {
+	if (CHK_MS8BIT(ms_card))
 		data[0] = PARALLEL_8BIT_IF;
-	} else {
+	else
 		data[0] = PARALLEL_4BIT_IF;
-	}
+
 	data[1] = 0;
 
 	data[2] = 0x40;
@@ -856,24 +817,21 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 
 	for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 		retval = ms_write_bytes(chip, PRO_WRITE_REG, 7, NO_WAIT_INT, data, 8);
-		if (retval == STATUS_SUCCESS) {
+		if (retval == STATUS_SUCCESS)
 			break;
-		}
 	}
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	buf = kmalloc(64 * 512, GFP_KERNEL);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 		retval = ms_send_cmd(chip, PRO_READ_ATRB, WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			continue;
-		}
+
 		retval = rtsx_read_register(chip, MS_TRANS_CFG, &val);
 		if (retval != STATUS_SUCCESS) {
 			kfree(buf);
@@ -885,11 +843,10 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 		}
 		retval = ms_transfer_data(chip, MS_TM_AUTO_READ, PRO_READ_LONG_DATA,
 				0x40, WAIT_INT, 0, 0, buf, 64 * 512);
-		if (retval == STATUS_SUCCESS) {
+		if (retval == STATUS_SUCCESS)
 			break;
-		} else {
+		else
 			rtsx_clear_ms_error(chip);
-		}
 	}
 	if (retval != STATUS_SUCCESS) {
 		kfree(buf);
@@ -963,9 +920,8 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 			}
 
 #ifdef SUPPORT_MSXC
-			if (buf[cur_addr_off + 8] == 0x13) {
+			if (buf[cur_addr_off + 8] == 0x13)
 				ms_card->ms_type |= MS_XC;
-			}
 #endif
 #ifdef SUPPORT_PCGL_1P18
 			found_sys_info = 1;
@@ -1046,18 +1002,15 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_MSXC
 	if (CHK_MSXC(ms_card)) {
-		if (class_code != 0x03) {
+		if (class_code != 0x03)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
-		if (class_code != 0x02) {
+		if (class_code != 0x02)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 #else
-	if (class_code != 0x02) {
+	if (class_code != 0x02)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 #endif
 
 	if (device_type != 0x00) {
@@ -1069,9 +1022,8 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 		}
 	}
 
-	if (sub_class & 0xC0) {
+	if (sub_class & 0xC0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_DEBUGP("class_code: 0x%x, device_type: 0x%x, sub_class: 0x%x\n",
 		class_code, device_type, sub_class);
@@ -1117,23 +1069,20 @@ Retry:
 	if (retval != STATUS_SUCCESS) {
 		if (ms_card->switch_8bit_fail) {
 			retval = ms_pro_reset_flow(chip, 0);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		} else {
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 	}
 
 	retval = ms_read_attribute_info(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 #ifdef XC_POWERCLASS
-	if (CHK_HG8BIT(ms_card)) {
+	if (CHK_HG8BIT(ms_card))
 		change_power_class = 0;
-	}
 
 	if (change_power_class && CHK_MSXC(ms_card)) {
 		u8 power_class_en = chip->ms_power_class_en;
@@ -1141,11 +1090,10 @@ Retry:
 		RTSX_DEBUGP("power_class_en = 0x%x\n", power_class_en);
 		RTSX_DEBUGP("change_power_class = %d\n", change_power_class);
 
-		if (change_power_class) {
+		if (change_power_class)
 			power_class_en &= (1 << (change_power_class - 1));
-		} else {
+		else
 			power_class_en = 0;
-		}
 
 		if (power_class_en) {
 			u8 power_class_mode = (ms_card->raw_sys_info[46] & 0x18) >> 3;
@@ -1165,16 +1113,14 @@ Retry:
 
 #ifdef SUPPORT_MAGIC_GATE
 	retval = mg_set_tpc_para_sub(chip, 0, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 #endif
 
-	if (CHK_HG8BIT(ms_card)) {
+	if (CHK_HG8BIT(ms_card))
 		chip->card_bus_width[chip->card2lun[MS_CARD]] = 8;
-	} else {
+	else
 		chip->card_bus_width[chip->card2lun[MS_CARD]] = 4;
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1185,14 +1131,12 @@ static int ms_read_status_reg(struct rtsx_chip *chip)
 	u8 val[2];
 
 	retval = ms_set_rw_reg_addr(chip, StatusReg0, 2, 0, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_read_bytes(chip, READ_REG, 2, NO_WAIT_INT, val, 2);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (val[1] & (STS_UCDT | STS_UCEX | STS_UCFG)) {
 		ms_set_err_code(chip, MS_FLASH_READ_ERROR);
@@ -1211,9 +1155,8 @@ static int ms_read_extra_data(struct rtsx_chip *chip,
 	u8 val, data[10];
 
 	retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (CHK_MS4BIT(ms_card)) {
 		/* Parallel interface */
@@ -1233,9 +1176,8 @@ static int ms_read_extra_data(struct rtsx_chip *chip,
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 
@@ -1244,15 +1186,14 @@ static int ms_read_extra_data(struct rtsx_chip *chip,
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 	retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	if (val & INT_REG_CMDNK) {
 		ms_set_err_code(chip, MS_CMD_NK);
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1260,20 +1201,18 @@ static int ms_read_extra_data(struct rtsx_chip *chip,
 	if (val & INT_REG_CED) {
 		if (val & INT_REG_ERR) {
 			retval = ms_read_status_reg(chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 			retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 6);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 	}
 
 	retval = ms_read_bytes(chip, READ_REG, MS_EXTRA_SIZE, NO_WAIT_INT, data, MS_EXTRA_SIZE);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (buf && buf_len) {
 		if (buf_len > MS_EXTRA_SIZE)
@@ -1291,45 +1230,40 @@ static int ms_write_extra_data(struct rtsx_chip *chip,
 	int retval, i;
 	u8 val, data[16];
 
-	if (!buf || (buf_len < MS_EXTRA_SIZE)) {
+	if (!buf || (buf_len < MS_EXTRA_SIZE))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 6 + MS_EXTRA_SIZE);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (CHK_MS4BIT(ms_card)) {
+	if (CHK_MS4BIT(ms_card))
 		data[0] = 0x88;
-	} else {
+	else
 		data[0] = 0x80;
-	}
+
 	data[1] = 0;
 	data[2] = (u8)(block_addr >> 8);
 	data[3] = (u8)block_addr;
 	data[4] = 0x40;
 	data[5] = page_num;
 
-	for (i = 6; i < MS_EXTRA_SIZE + 6; i++) {
+	for (i = 6; i < MS_EXTRA_SIZE + 6; i++)
 		data[i] = buf[i - 6];
-	}
 
 	retval = ms_write_bytes(chip, WRITE_REG , (6+MS_EXTRA_SIZE), NO_WAIT_INT, data, 16);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_send_cmd(chip, BLOCK_WRITE, WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 	retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	if (val & INT_REG_CMDNK) {
 		ms_set_err_code(chip, MS_CMD_NK);
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1352,15 +1286,14 @@ static int ms_read_page(struct rtsx_chip *chip, u16 block_addr, u8 page_num)
 	u8 val, data[6];
 
 	retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (CHK_MS4BIT(ms_card)) {
+	if (CHK_MS4BIT(ms_card))
 		data[0] = 0x88;
-	} else {
+	else
 		data[0] = 0x80;
-	}
+
 	data[1] = 0;
 	data[2] = (u8)(block_addr >> 8);
 	data[3] = (u8)block_addr;
@@ -1368,20 +1301,18 @@ static int ms_read_page(struct rtsx_chip *chip, u16 block_addr, u8 page_num)
 	data[5] = page_num;
 
 	retval = ms_write_bytes(chip, WRITE_REG , 6, NO_WAIT_INT, data, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_send_cmd(chip, BLOCK_READ, WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 	retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	if (val & INT_REG_CMDNK) {
 		ms_set_err_code(chip, MS_CMD_NK);
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1394,9 +1325,9 @@ static int ms_read_page(struct rtsx_chip *chip, u16 block_addr, u8 page_num)
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 			retval = ms_read_status_reg(chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				ms_set_err_code(chip,  MS_FLASH_WRITE_ERROR);
-			}
+
 		} else {
 			if (!(val & INT_REG_BREQ)) {
 				ms_set_err_code(chip, MS_BREQ_ERROR);
@@ -1406,13 +1337,11 @@ static int ms_read_page(struct rtsx_chip *chip, u16 block_addr, u8 page_num)
 	}
 
 	retval = ms_transfer_tpc(chip, MS_TM_NORMAL_READ, READ_PAGE_DATA, 0, NO_WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (ms_check_err_code(chip, MS_FLASH_WRITE_ERROR)) {
+	if (ms_check_err_code(chip, MS_FLASH_WRITE_ERROR))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1425,22 +1354,20 @@ static int ms_set_bad_block(struct rtsx_chip *chip, u16 phy_blk)
 	u8 val, data[8], extra[MS_EXTRA_SIZE];
 
 	retval = ms_read_extra_data(chip, phy_blk, 0, extra, MS_EXTRA_SIZE);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 7);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 
-	if (CHK_MS4BIT(ms_card)) {
+	if (CHK_MS4BIT(ms_card))
 		data[0] = 0x88;
-	} else {
+	else
 		data[0] = 0x80;
-	}
+
 	data[1] = 0;
 	data[2] = (u8)(phy_blk >> 8);
 	data[3] = (u8)phy_blk;
@@ -1450,20 +1377,17 @@ static int ms_set_bad_block(struct rtsx_chip *chip, u16 phy_blk)
 	data[7] = 0xFF;
 
 	retval = ms_write_bytes(chip, WRITE_REG , 7, NO_WAIT_INT, data, 7);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_send_cmd(chip, BLOCK_WRITE, WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 	retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (val & INT_REG_CMDNK) {
 		ms_set_err_code(chip, MS_CMD_NK);
@@ -1488,17 +1412,16 @@ static int ms_erase_block(struct rtsx_chip *chip, u16 phy_blk)
 	u8 val, data[6];
 
 	retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 
-	if (CHK_MS4BIT(ms_card)) {
+	if (CHK_MS4BIT(ms_card))
 		data[0] = 0x88;
-	} else {
+	else
 		data[0] = 0x80;
-	}
+
 	data[1] = 0;
 	data[2] = (u8)(phy_blk >> 8);
 	data[3] = (u8)phy_blk;
@@ -1506,21 +1429,18 @@ static int ms_erase_block(struct rtsx_chip *chip, u16 phy_blk)
 	data[5] = 0;
 
 	retval = ms_write_bytes(chip, WRITE_REG, 6, NO_WAIT_INT, data, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 ERASE_RTY:
 	retval = ms_send_cmd(chip, BLOCK_ERASE, WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 	retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (val & INT_REG_CMDNK) {
 		if (i < 3) {
@@ -1546,9 +1466,8 @@ ERASE_RTY:
 
 static void ms_set_page_status(u16 log_blk, u8 type, u8 *extra, int extra_len)
 {
-	if (!extra || (extra_len < MS_EXTRA_SIZE)) {
+	if (!extra || (extra_len < MS_EXTRA_SIZE))
 		return;
-	}
 
 	memset(extra, 0xFF, MS_EXTRA_SIZE);
 
@@ -1583,9 +1502,8 @@ static int ms_init_page(struct rtsx_chip *chip, u16 phy_blk, u16 log_blk, u8 sta
 		}
 
 		retval = ms_write_extra_data(chip, phy_blk, i, extra, MS_EXTRA_SIZE);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -1603,27 +1521,23 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 	RTSX_DEBUGP("start_page = %d, end_page = %d\n", start_page, end_page);
 
 	retval = ms_read_extra_data(chip, new_blk, 0, extra, MS_EXTRA_SIZE);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_read_status_reg(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_READ_REG(chip, PPBUF_BASE2, &val);
 
 	if (val & BUF_FULL) {
 		retval = ms_send_cmd(chip, CLEAR_BUF, WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if (!(val & INT_REG_CED)) {
 			ms_set_err_code(chip, MS_FLASH_WRITE_ERROR);
@@ -1640,17 +1554,16 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 		ms_read_extra_data(chip, old_blk, i, extra, MS_EXTRA_SIZE);
 
 		retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 6);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		ms_set_err_code(chip, MS_NO_ERROR);
 
-		if (CHK_MS4BIT(ms_card)) {
+		if (CHK_MS4BIT(ms_card))
 			data[0] = 0x88;
-		} else {
+		else
 			data[0] = 0x80;
-		}
+
 		data[1] = 0;
 		data[2] = (u8)(old_blk >> 8);
 		data[3] = (u8)old_blk;
@@ -1658,20 +1571,17 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 		data[5] = i;
 
 		retval = ms_write_bytes(chip, WRITE_REG , 6, NO_WAIT_INT, data, 6);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = ms_send_cmd(chip, BLOCK_READ, WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		ms_set_err_code(chip, MS_NO_ERROR);
 		retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if (val & INT_REG_CMDNK) {
 			ms_set_err_code(chip, MS_CMD_NK);
@@ -1689,15 +1599,14 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 				}
 
 				retval = ms_transfer_tpc(chip, MS_TM_NORMAL_READ, READ_PAGE_DATA, 0, NO_WAIT_INT);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 
 				if (uncorrect_flag) {
 					ms_set_page_status(log_blk, setPS_NG, extra, MS_EXTRA_SIZE);
-					if (i == 0) {
+					if (i == 0)
 						extra[0] &= 0xEF;
-					}
+
 					ms_write_extra_data(chip, old_blk, i, extra, MS_EXTRA_SIZE);
 					RTSX_DEBUGP("page %d : extra[0] = 0x%x\n", i, extra[0]);
 					MS_SET_BAD_BLOCK_FLG(ms_card);
@@ -1710,13 +1619,11 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 				for (rty_cnt = 0; rty_cnt < MS_MAX_RETRY_COUNT; rty_cnt++) {
 					retval = ms_transfer_tpc(chip, MS_TM_NORMAL_WRITE,
 							WRITE_PAGE_DATA, 0, NO_WAIT_INT);
-					if (retval == STATUS_SUCCESS) {
+					if (retval == STATUS_SUCCESS)
 						break;
-					}
 				}
-				if (rty_cnt == MS_MAX_RETRY_COUNT) {
+				if (rty_cnt == MS_MAX_RETRY_COUNT)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 
 			if (!(val & INT_REG_BREQ)) {
@@ -1730,45 +1637,41 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 
 		ms_set_err_code(chip, MS_NO_ERROR);
 
-		if (CHK_MS4BIT(ms_card)) {
+		if (CHK_MS4BIT(ms_card))
 			data[0] = 0x88;
-		} else {
+		else
 			data[0] = 0x80;
-		}
+
 		data[1] = 0;
 		data[2] = (u8)(new_blk >> 8);
 		data[3] = (u8)new_blk;
 		data[4] = 0x20;
 		data[5] = i;
 
-		if ((extra[0] & 0x60) != 0x60) {
+		if ((extra[0] & 0x60) != 0x60)
 			data[6] = extra[0];
-		} else {
+		else
 			data[6] = 0xF8;
-		}
+
 		data[6 + 1] = 0xFF;
 		data[6 + 2] = (u8)(log_blk >> 8);
 		data[6 + 3] = (u8)log_blk;
 
-		for (j = 4; j <= MS_EXTRA_SIZE; j++) {
+		for (j = 4; j <= MS_EXTRA_SIZE; j++)
 			data[6 + j] = 0xFF;
-		}
 
 		retval = ms_write_bytes(chip, WRITE_REG, (6 + MS_EXTRA_SIZE), NO_WAIT_INT, data, 16);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = ms_send_cmd(chip, BLOCK_WRITE, WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		ms_set_err_code(chip, MS_NO_ERROR);
 		retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if (val & INT_REG_CMDNK) {
 			ms_set_err_code(chip, MS_CMD_NK);
@@ -1784,17 +1687,16 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 
 		if (i == 0) {
 			retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 7);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			ms_set_err_code(chip, MS_NO_ERROR);
 
-			if (CHK_MS4BIT(ms_card)) {
+			if (CHK_MS4BIT(ms_card))
 				data[0] = 0x88;
-			} else {
+			else
 				data[0] = 0x80;
-			}
+
 			data[1] = 0;
 			data[2] = (u8)(old_blk >> 8);
 			data[3] = (u8)old_blk;
@@ -1804,20 +1706,17 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 			data[7] = 0xFF;
 
 			retval = ms_write_bytes(chip, WRITE_REG, 7, NO_WAIT_INT, data, 8);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			retval = ms_send_cmd(chip, BLOCK_WRITE, WAIT_INT);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			ms_set_err_code(chip, MS_NO_ERROR);
 			retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			if (val & INT_REG_CMDNK) {
 				ms_set_err_code(chip, MS_CMD_NK);
@@ -1848,28 +1747,24 @@ static int reset_ms(struct rtsx_chip *chip)
 #endif
 
 	retval = ms_prepare_reset(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_card->ms_type |= TYPE_MS;
 
 	retval = ms_send_cmd(chip, MS_RESET, NO_WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_read_status_reg(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_READ_REG(chip, PPBUF_BASE2, &val);
-	if (val & WRT_PRTCT) {
+	if (val & WRT_PRTCT)
 		chip->card_wp |= MS_CARD;
-	} else {
+	else
 		chip->card_wp &= ~MS_CARD;
-	}
 
 	i = 0;
 
@@ -1913,21 +1808,18 @@ RE_SEARCH:
 	}
 
 	retval = ms_read_page(chip, ms_card->boot_block, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	/* Read MS system information as sys_info */
 	rtsx_init_cmd(chip);
 
-	for (i = 0; i < 96; i++) {
+	for (i = 0; i < 96; i++)
 		rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2 + 0x1A0 + i, 0, 0);
-	}
 
 	retval = rtsx_send_cmd(chip, MS_CARD, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ptr = rtsx_get_cmd_data(chip);
 	memcpy(ms_card->raw_sys_info, ptr, 96);
@@ -1938,21 +1830,18 @@ RE_SEARCH:
 	rtsx_add_cmd(chip, READ_REG_CMD, HEADER_ID0, 0, 0);
 	rtsx_add_cmd(chip, READ_REG_CMD, HEADER_ID1, 0, 0);
 
-	for (reg_addr = DISABLED_BLOCK0; reg_addr <= DISABLED_BLOCK3; reg_addr++) {
+	for (reg_addr = DISABLED_BLOCK0; reg_addr <= DISABLED_BLOCK3; reg_addr++)
 		rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
-	}
 
-	for (reg_addr = BLOCK_SIZE_0; reg_addr <= PAGE_SIZE_1; reg_addr++) {
+	for (reg_addr = BLOCK_SIZE_0; reg_addr <= PAGE_SIZE_1; reg_addr++)
 		rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
-	}
 
 	rtsx_add_cmd(chip, READ_REG_CMD, MS_Device_Type, 0, 0);
 	rtsx_add_cmd(chip, READ_REG_CMD, MS_4bit_Support, 0, 0);
 
 	retval = rtsx_send_cmd(chip, MS_CARD, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ptr = rtsx_get_cmd_data(chip);
 
@@ -1975,9 +1864,8 @@ RE_SEARCH:
 		goto RE_SEARCH;
 	}
 
-	if ((ptr[14] == 1) || (ptr[14] == 3)) {
+	if ((ptr[14] == 1) || (ptr[14] == 3))
 		chip->card_wp |= MS_CARD;
-	}
 
 	/* BLOCK_SIZE_0, BLOCK_SIZE_1 */
 	block_size = ((u16)ptr[6] << 8) | ptr[7];
@@ -2026,17 +1914,15 @@ RE_SEARCH:
 	/* Switch I/F Mode */
 	if (ptr[15]) {
 		retval = ms_set_rw_reg_addr(chip, 0, 0, SystemParm, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		RTSX_WRITE_REG(chip, PPBUF_BASE2, 0xFF, 0x88);
 		RTSX_WRITE_REG(chip, PPBUF_BASE2 + 1, 0xFF, 0);
 
 		retval = ms_transfer_tpc(chip, MS_TM_WRITE_BYTES, WRITE_REG , 1, NO_WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		RTSX_WRITE_REG(chip, MS_CFG, 0x58 | MS_NO_CHECK_INT,
 				MS_BUS_WIDTH_4 | PUSH_TIME_ODD | MS_NO_CHECK_INT);
@@ -2044,11 +1930,10 @@ RE_SEARCH:
 		ms_card->ms_type |= MS_4BIT;
 	}
 
-	if (CHK_MS4BIT(ms_card)) {
+	if (CHK_MS4BIT(ms_card))
 		chip->card_bus_width[chip->card2lun[MS_CARD]] = 4;
-	} else {
+	else
 		chip->card_bus_width[chip->card2lun[MS_CARD]] = 1;
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -2065,30 +1950,27 @@ static int ms_init_l2p_tbl(struct rtsx_chip *chip)
 
 	size = ms_card->segment_cnt * sizeof(struct zone_entry);
 	ms_card->segment = vzalloc(size);
-	if (ms_card->segment == NULL) {
+	if (ms_card->segment == NULL)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_read_page(chip, ms_card->boot_block, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_GOTO(chip, INIT_FAIL);
-	}
 
 	reg_addr = PPBUF_BASE2;
 	for (i = 0; i < (((ms_card->total_block >> 9) * 10) + 1); i++) {
 		retval = rtsx_read_register(chip, reg_addr++, &val1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, INIT_FAIL);
-		}
+
 		retval = rtsx_read_register(chip, reg_addr++, &val2);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, INIT_FAIL);
-		}
 
 		defect_block = ((u16)val1 << 8) | val2;
-		if (defect_block == 0xFFFF) {
+		if (defect_block == 0xFFFF)
 			break;
-		}
+
 		seg_no = defect_block / 512;
 		ms_card->segment[seg_no].defect_list[ms_card->segment[seg_no].disable_count++] = defect_block;
 	}
@@ -2141,9 +2023,8 @@ static void ms_set_l2p_tbl(struct rtsx_chip *chip, int seg_no, u16 log_off, u16
 		return;
 
 	segment = &(ms_card->segment[seg_no]);
-	if (segment->l2p_table) {
+	if (segment->l2p_table)
 		segment->l2p_table[log_off] = phy_blk;
-	}
 }
 
 static void ms_set_unused_block(struct rtsx_chip *chip, u16 phy_blk)
@@ -2156,9 +2037,9 @@ static void ms_set_unused_block(struct rtsx_chip *chip, u16 phy_blk)
 	segment = &(ms_card->segment[seg_no]);
 
 	segment->free_table[segment->set_index++] = phy_blk;
-	if (segment->set_index >= MS_FREE_TABLE_CNT) {
+	if (segment->set_index >= MS_FREE_TABLE_CNT)
 		segment->set_index = 0;
-	}
+
 	segment->unused_blk_cnt++;
 }
 
@@ -2175,9 +2056,9 @@ static u16 ms_get_unused_block(struct rtsx_chip *chip, int seg_no)
 
 	phy_blk = segment->free_table[segment->get_index];
 	segment->free_table[segment->get_index++] = 0xFFFF;
-	if (segment->get_index >= MS_FREE_TABLE_CNT) {
+	if (segment->get_index >= MS_FREE_TABLE_CNT)
 		segment->get_index = 0;
-	}
+
 	segment->unused_blk_cnt--;
 
 	return phy_blk;
@@ -2199,27 +2080,27 @@ static int ms_arbitrate_l2p(struct rtsx_chip *chip, u16 phy_blk, u16 log_off, u8
 
 	if (us1 != us2) {
 		if (us1 == 0) {
-			if (!(chip->card_wp & MS_CARD)) {
+			if (!(chip->card_wp & MS_CARD))
 				ms_erase_block(chip, tmp_blk);
-			}
+
 			ms_set_unused_block(chip, tmp_blk);
 			segment->l2p_table[log_off] = phy_blk;
 		} else {
-			if (!(chip->card_wp & MS_CARD)) {
+			if (!(chip->card_wp & MS_CARD))
 				ms_erase_block(chip, phy_blk);
-			}
+
 			ms_set_unused_block(chip, phy_blk);
 		}
 	} else {
 		if (phy_blk < tmp_blk) {
-			if (!(chip->card_wp & MS_CARD)) {
+			if (!(chip->card_wp & MS_CARD))
 				ms_erase_block(chip, phy_blk);
-			}
+
 			ms_set_unused_block(chip, phy_blk);
 		} else {
-			if (!(chip->card_wp & MS_CARD)) {
+			if (!(chip->card_wp & MS_CARD))
 				ms_erase_block(chip, tmp_blk);
-			}
+
 			ms_set_unused_block(chip, tmp_blk);
 			segment->l2p_table[log_off] = phy_blk;
 		}
@@ -2240,9 +2121,8 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 
 	if (ms_card->segment == NULL) {
 		retval = ms_init_l2p_tbl(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, retval);
-		}
 	}
 
 	if (ms_card->segment[seg_no].build_flag) {
@@ -2250,27 +2130,24 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 		return STATUS_SUCCESS;
 	}
 
-	if (seg_no == 0) {
+	if (seg_no == 0)
 		table_size = 494;
-	} else {
+	else
 		table_size = 496;
-	}
 
 	segment = &(ms_card->segment[seg_no]);
 
 	if (segment->l2p_table == NULL) {
 		segment->l2p_table = (u16 *)vmalloc(table_size * 2);
-		if (segment->l2p_table == NULL) {
+		if (segment->l2p_table == NULL)
 			TRACE_GOTO(chip, BUILD_FAIL);
-		}
 	}
 	memset((u8 *)(segment->l2p_table), 0xff, table_size * 2);
 
 	if (segment->free_table == NULL) {
 		segment->free_table = (u16 *)vmalloc(MS_FREE_TABLE_CNT * 2);
-		if (segment->free_table == NULL) {
+		if (segment->free_table == NULL)
 			TRACE_GOTO(chip, BUILD_FAIL);
-		}
 	}
 	memset((u8 *)(segment->free_table), 0xff, MS_FREE_TABLE_CNT * 2);
 
@@ -2368,13 +2245,11 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 
 	/* Logical Address Confirmation Process */
 	if (seg_no == ms_card->segment_cnt - 1) {
-		if (segment->unused_blk_cnt < 2) {
+		if (segment->unused_blk_cnt < 2)
 			chip->card_wp |= MS_CARD;
-		}
 	} else {
-		if (segment->unused_blk_cnt < 1) {
+		if (segment->unused_blk_cnt < 1)
 			chip->card_wp |= MS_CARD;
-		}
 	}
 
 	if (chip->card_wp & MS_CARD)
@@ -2388,9 +2263,9 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 				return STATUS_SUCCESS;
 			}
 			retval = ms_init_page(chip, phy_blk, log_blk, 0, 1);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_GOTO(chip, BUILD_FAIL);
-			}
+
 			segment->l2p_table[log_blk-ms_start_idx[seg_no]] = phy_blk;
 			if (seg_no == ms_card->segment_cnt - 1) {
 				if (segment->unused_blk_cnt < 2) {
@@ -2419,16 +2294,14 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 				phy_blk = ms_get_unused_block(chip, 0);
 				retval = ms_copy_page(chip, tmp_blk, phy_blk,
 						log_blk, 0, ms_card->page_off + 1);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 
 				segment->l2p_table[log_blk] = phy_blk;
 
 				retval = ms_set_bad_block(chip, tmp_blk);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 		}
 	}
@@ -2458,14 +2331,12 @@ int reset_ms_card(struct rtsx_chip *chip)
 	memset(ms_card, 0, sizeof(struct ms_info));
 
 	retval = enable_card_clock(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = select_card(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_card->ms_type = 0;
 
@@ -2473,27 +2344,24 @@ int reset_ms_card(struct rtsx_chip *chip)
 	if (retval != STATUS_SUCCESS) {
 		if (ms_card->check_ms_flow) {
 			retval = reset_ms(chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		} else {
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 	}
 
 	retval = ms_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (!CHK_MSPRO(ms_card)) {
 		/* Build table for the last segment,
 		 * to check if L2P table block exists, erasing it
 		 */
 		retval = ms_build_l2p_tbl(chip, ms_card->total_block / 512 - 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	RTSX_DEBUGP("ms_card->ms_type = 0x%x\n", ms_card->ms_type);
@@ -2520,9 +2388,8 @@ static int mspro_set_rw_cmd(struct rtsx_chip *chip, u32 start_sec, u16 sec_cnt,
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -2556,21 +2423,18 @@ static inline int ms_auto_tune_clock(struct rtsx_chip *chip)
 	RTSX_DEBUGP("--%s--\n", __func__);
 
 	if (chip->asic_code) {
-		if (ms_card->ms_clock > 30) {
+		if (ms_card->ms_clock > 30)
 			ms_card->ms_clock -= 20;
-		}
 	} else {
-		if (ms_card->ms_clock == CLK_80) {
+		if (ms_card->ms_clock == CLK_80)
 			ms_card->ms_clock = CLK_60;
-		} else if (ms_card->ms_clock == CLK_60) {
+		else if (ms_card->ms_clock == CLK_60)
 			ms_card->ms_clock = CLK_40;
-		}
 	}
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -2616,15 +2480,13 @@ static int mspro_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 	}
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (srb->sc_data_direction == DMA_FROM_DEVICE) {
+	if (srb->sc_data_direction == DMA_FROM_DEVICE)
 		trans_mode = MS_TM_AUTO_READ;
-	} else {
+	else
 		trans_mode = MS_TM_AUTO_WRITE;
-	}
 
 	RTSX_READ_REG(chip, MS_TRANS_CFG, &val);
 
@@ -2639,9 +2501,8 @@ static int mspro_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 			ms_card->total_sec_cnt = 0;
 			if (val & MS_INT_BREQ) {
 				retval = ms_send_cmd(chip, PRO_STOP, WAIT_INT);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 
 				rtsx_write_register(chip, RBCTL, RB_FLUSH, RB_FLUSH);
 			}
@@ -2651,17 +2512,16 @@ static int mspro_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 	if (!ms_card->seq_mode) {
 		ms_card->total_sec_cnt = 0;
 		if (sector_cnt >= SEQ_START_CRITERIA) {
-			if ((ms_card->capacity - start_sector) > 0xFE00) {
+			if ((ms_card->capacity - start_sector) > 0xFE00)
 				count = 0xFE00;
-			} else {
+			else
 				count = (u16)(ms_card->capacity - start_sector);
-			}
+
 			if (count > sector_cnt) {
-				if (mode_2k) {
+				if (mode_2k)
 					ms_card->seq_mode |= MODE_2K_SEQ;
-				} else {
+				else
 					ms_card->seq_mode |= MODE_512_SEQ;
-				}
 			}
 		} else {
 			count = sector_cnt;
@@ -2686,9 +2546,9 @@ static int mspro_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
-		if (val & MS_INT_BREQ) {
+		if (val & MS_INT_BREQ)
 			ms_send_cmd(chip, PRO_STOP, WAIT_INT);
-		}
+
 		if (val & (MS_CRC16_ERR | MS_RDY_TIMEOUT)) {
 			RTSX_DEBUGP("MSPro CRC error, tune clock!\n");
 			chip->rw_need_retry = 1;
@@ -2739,11 +2599,10 @@ static int mspro_read_format_progress(struct rtsx_chip *chip, const int short_da
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
-	if (short_data_len >= 256) {
+	if (short_data_len >= 256)
 		cnt = 0;
-	} else {
+	else
 		cnt = (u8)short_data_len;
-	}
 
 	retval = rtsx_write_register(chip, MS_CFG, MS_NO_CHECK_INT, MS_NO_CHECK_INT);
 	if (retval != STATUS_SUCCESS) {
@@ -2778,9 +2637,8 @@ static int mspro_read_format_progress(struct rtsx_chip *chip, const int short_da
 			ms_card->format_status = FORMAT_FAIL;
 			TRACE_RET(chip, STATUS_FAIL);
 		}
-		if (tmp & (MS_INT_CED | MS_INT_CMDNK | MS_INT_BREQ | MS_INT_ERR)) {
+		if (tmp & (MS_INT_CED | MS_INT_CMDNK | MS_INT_BREQ | MS_INT_ERR))
 			break;
-		}
 
 		wait_timeout(1);
 	}
@@ -2843,14 +2701,12 @@ int mspro_format(struct scsi_cmnd *srb, struct rtsx_chip *chip, int short_data_l
 	RTSX_DEBUGP("--%s--\n", __func__);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_set_rw_reg_addr(chip, 0x00, 0x00, Pro_TPCParm, 0x01);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	memset(buf, 0, 2);
 	switch (short_data_len) {
@@ -2874,25 +2730,22 @@ int mspro_format(struct scsi_cmnd *srb, struct rtsx_chip *chip, int short_data_l
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (quick_format) {
+	if (quick_format)
 		para = 0x0000;
-	} else {
+	else
 		para = 0x0001;
-	}
+
 	retval = mspro_set_rw_cmd(chip, 0, para, PRO_FORMAT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_READ_REG(chip, MS_TRANS_CFG, &tmp);
 
-	if (tmp & (MS_INT_CMDNK | MS_INT_ERR)) {
+	if (tmp & (MS_INT_CMDNK | MS_INT_ERR))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if ((tmp & (MS_INT_BREQ | MS_INT_CED)) == MS_INT_BREQ) {
 		ms_card->pro_under_formatting = 1;
@@ -2930,15 +2783,14 @@ static int ms_read_multiple_pages(struct rtsx_chip *chip, u16 phy_blk, u16 log_b
 	}
 
 	retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (CHK_MS4BIT(ms_card)) {
+	if (CHK_MS4BIT(ms_card))
 		data[0] = 0x88;
-	} else {
+	else
 		data[0] = 0x80;
-	}
+
 	data[1] = 0;
 	data[2] = (u8)(phy_blk >> 8);
 	data[3] = (u8)phy_blk;
@@ -2950,16 +2802,14 @@ static int ms_read_multiple_pages(struct rtsx_chip *chip, u16 phy_blk, u16 log_b
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 
 	retval = ms_send_cmd(chip, BLOCK_READ, WAIT_INT);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ptr = buf;
 
@@ -2972,9 +2822,9 @@ static int ms_read_multiple_pages(struct rtsx_chip *chip, u16 phy_blk, u16 log_b
 		}
 
 		retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
+
 		if (val & INT_REG_CMDNK) {
 			ms_set_err_code(chip, MS_CMD_NK);
 			TRACE_RET(chip, STATUS_FAIL);
@@ -3006,15 +2856,14 @@ static int ms_read_multiple_pages(struct rtsx_chip *chip, u16 phy_blk, u16 log_b
 		if (page_addr == (end_page - 1)) {
 			if (!(val & INT_REG_CED)) {
 				retval = ms_send_cmd(chip, BLOCK_END, WAIT_INT);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 
 			retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
+
 			if (!(val & INT_REG_CED)) {
 				ms_set_err_code(chip, MS_FLASH_READ_ERROR);
 				TRACE_RET(chip, STATUS_FAIL);
@@ -3079,15 +2928,14 @@ static int ms_write_multiple_pages(struct rtsx_chip *chip, u16 old_blk, u16 new_
 
 	if (!start_page) {
 		retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, 7);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
-		if (CHK_MS4BIT(ms_card)) {
+		if (CHK_MS4BIT(ms_card))
 			data[0] = 0x88;
-		} else {
+		else
 			data[0] = 0x80;
-		}
+
 		data[1] = 0;
 		data[2] = (u8)(old_blk >> 8);
 		data[3] = (u8)old_blk;
@@ -3097,74 +2945,66 @@ static int ms_write_multiple_pages(struct rtsx_chip *chip, u16 old_blk, u16 new_
 		data[7] = 0xFF;
 
 		retval = ms_write_bytes(chip, WRITE_REG, 7, NO_WAIT_INT, data, 8);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = ms_send_cmd(chip, BLOCK_WRITE, WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		ms_set_err_code(chip, MS_NO_ERROR);
 		retval = ms_transfer_tpc(chip, MS_TM_READ_BYTES, GET_INT, 1, NO_WAIT_INT);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	retval = ms_set_rw_reg_addr(chip, OverwriteFlag, MS_EXTRA_SIZE, SystemParm, (6 + MS_EXTRA_SIZE));
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 
-	if (CHK_MS4BIT(ms_card)) {
+	if (CHK_MS4BIT(ms_card))
 		data[0] = 0x88;
-	} else {
+	else
 		data[0] = 0x80;
-	}
+
 	data[1] = 0;
 	data[2] = (u8)(new_blk >> 8);
 	data[3] = (u8)new_blk;
-	if ((end_page - start_page) == 1) {
+	if ((end_page - start_page) == 1)
 		data[4] = 0x20;
-	} else {
+	else
 		data[4] = 0;
-	}
+
 	data[5] = start_page;
 	data[6] = 0xF8;
 	data[7] = 0xFF;
 	data[8] = (u8)(log_blk >> 8);
 	data[9] = (u8)log_blk;
 
-	for (i = 0x0A; i < 0x10; i++) {
+	for (i = 0x0A; i < 0x10; i++)
 		data[i] = 0xFF;
-	}
 
 	for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 		retval = ms_write_bytes(chip, WRITE_REG, 6 + MS_EXTRA_SIZE, NO_WAIT_INT, data, 16);
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	for (i = 0; i < MS_MAX_RETRY_COUNT; i++) {
 		retval = ms_send_cmd(chip, BLOCK_WRITE, WAIT_INT);
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ptr = buf;
 	for (page_addr = start_page; page_addr < end_page; page_addr++) {
@@ -3210,17 +3050,15 @@ static int ms_write_multiple_pages(struct rtsx_chip *chip, u16 old_blk, u16 new_
 			ms_set_err_code(chip, MS_TO_ERROR);
 			rtsx_clear_ms_error(chip);
 
-			if (retval == -ETIMEDOUT) {
+			if (retval == -ETIMEDOUT)
 				TRACE_RET(chip, STATUS_TIMEDOUT);
-			} else {
+			else
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 
 		retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if ((end_page - start_page) == 1) {
 			if (!(val & INT_REG_CED)) {
@@ -3231,15 +3069,13 @@ static int ms_write_multiple_pages(struct rtsx_chip *chip, u16 old_blk, u16 new_
 			if (page_addr == (end_page - 1)) {
 				if (!(val & INT_REG_CED)) {
 					retval = ms_send_cmd(chip, BLOCK_END, WAIT_INT);
-					if (retval != STATUS_SUCCESS) {
+					if (retval != STATUS_SUCCESS)
 						TRACE_RET(chip, STATUS_FAIL);
-					}
 				}
 
 				retval = ms_read_bytes(chip, GET_INT, 1, NO_WAIT_INT, &val, 1);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 
 			if ((page_addr == (end_page - 1)) || (page_addr == ms_card->page_off)) {
@@ -3266,9 +3102,8 @@ static int ms_finish_write(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 
 	retval = ms_copy_page(chip, old_blk, new_blk, log_blk,
 			page_off, ms_card->page_off + 1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	seg_no = old_blk >> 9;
 
@@ -3277,9 +3112,8 @@ static int ms_finish_write(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 		ms_set_bad_block(chip, old_blk);
 	} else {
 		retval = ms_erase_block(chip, old_blk);
-		if (retval == STATUS_SUCCESS) {
+		if (retval == STATUS_SUCCESS)
 			ms_set_unused_block(chip, old_blk);
-		}
 	}
 
 	ms_set_l2p_tbl(chip, seg_no, log_blk - ms_start_idx[seg_no], new_blk);
@@ -3294,9 +3128,8 @@ static int ms_prepare_write(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 
 	if (start_page) {
 		retval = ms_copy_page(chip, old_blk, new_blk, log_blk, 0, start_page);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -3311,17 +3144,15 @@ int ms_delay_write(struct rtsx_chip *chip)
 
 	if (delay_write->delay_write_flag) {
 		retval = ms_set_init_para(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		delay_write->delay_write_flag = 0;
 		retval = ms_finish_write(chip,
 				delay_write->old_phyblock, delay_write->new_phyblock,
 				delay_write->logblock, delay_write->pageoff);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -3330,11 +3161,10 @@ int ms_delay_write(struct rtsx_chip *chip)
 
 static inline void ms_rw_fail(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 {
-	if (srb->sc_data_direction == DMA_FROM_DEVICE) {
+	if (srb->sc_data_direction == DMA_FROM_DEVICE)
 		set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
-	} else {
+	else
 		set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_MEDIA_WRITE_ERR);
-	}
 }
 
 static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 sector_cnt)
@@ -3449,11 +3279,11 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32
 	RTSX_DEBUGP("seg_no = %d, old_blk = 0x%x, new_blk = 0x%x\n", seg_no, old_blk, new_blk);
 
 	while (total_sec_cnt) {
-		if ((start_page + total_sec_cnt) > (ms_card->page_off + 1)) {
+		if ((start_page + total_sec_cnt) > (ms_card->page_off + 1))
 			end_page = ms_card->page_off + 1;
-		} else {
+		else
 			end_page = start_page + (u8)total_sec_cnt;
-		}
+
 		page_cnt = end_page - start_page;
 
 		RTSX_DEBUGP("start_page = %d, end_page = %d, page_cnt = %d\n",
@@ -3482,9 +3312,9 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32
 		if (srb->sc_data_direction == DMA_TO_DEVICE) {
 			if (end_page == (ms_card->page_off + 1)) {
 				retval = ms_erase_block(chip, old_blk);
-				if (retval == STATUS_SUCCESS) {
+				if (retval == STATUS_SUCCESS)
 					ms_set_unused_block(chip, old_blk);
-				}
+
 				ms_set_l2p_tbl(chip, seg_no, log_blk - ms_start_idx[seg_no], new_blk);
 			}
 		}
@@ -3565,11 +3395,10 @@ int ms_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	if (CHK_MSPRO(ms_card)) {
+	if (CHK_MSPRO(ms_card))
 		retval = mspro_rw_multi_sector(srb, chip, start_sector, sector_cnt);
-	} else {
+	else
 		retval = ms_rw_multi_sector(srb, chip, start_sector, sector_cnt);
-	}
 
 	return retval;
 }
@@ -3609,14 +3438,12 @@ static int ms_poll_int(struct rtsx_chip *chip)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, MS_TRANS_CFG, MS_INT_CED, MS_INT_CED);
 
 	retval = rtsx_send_cmd(chip, MS_CARD, 5000);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	val = *rtsx_get_cmd_data(chip);
-	if (val & MS_INT_ERR) {
+	if (val & MS_INT_ERR)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -3678,9 +3505,8 @@ static int mg_send_ex_cmd(struct rtsx_chip *chip, u8 cmd, u8 entry_num)
 		if (retval == STATUS_SUCCESS)
 			break;
 	}
-	if (i == MS_MAX_RETRY_COUNT) {
+	if (i == MS_MAX_RETRY_COUNT)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (check_ms_err(chip)) {
 		rtsx_clear_ms_error(chip);
@@ -3697,14 +3523,13 @@ static int mg_set_tpc_para_sub(struct rtsx_chip *chip, int type, u8 mg_entry_num
 
 	RTSX_DEBUGP("--%s--\n", __func__);
 
-	if (type == 0) {
+	if (type == 0)
 		retval = ms_set_rw_reg_addr(chip, 0, 0, Pro_TPCParm, 1);
-	} else {
+	else
 		retval = ms_set_rw_reg_addr(chip, 0, 0, Pro_DataCount1, 6);
-	}
-	if (retval != STATUS_SUCCESS) {
+
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	buf[0] = 0;
 	buf[1] = 0;
@@ -3715,9 +3540,8 @@ static int mg_set_tpc_para_sub(struct rtsx_chip *chip, int type, u8 mg_entry_num
 		buf[5] = mg_entry_num;
 	}
 	retval = ms_write_bytes(chip, PRO_WRITE_REG, (type == 0) ? 1 : 6, NO_WAIT_INT, buf, 6);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -3739,9 +3563,8 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = mg_send_ex_cmd(chip, MG_SET_LID, 0);
 	if (retval != STATUS_SUCCESS) {
@@ -3751,9 +3574,9 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	memset(buf1, 0, 32);
 	rtsx_stor_get_xfer_buf(buf2, min(12, (int)scsi_bufflen(srb)), srb);
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++)
 		buf1[8+i] = buf2[4+i];
-	}
+
 	retval = ms_write_bytes(chip, PRO_WRITE_SHORT_DATA, 32, WAIT_INT, buf1, 32);
 	if (retval != STATUS_SUCCESS) {
 		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
@@ -3780,14 +3603,12 @@ int mg_get_local_EKB(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	buf = kmalloc(1540, GFP_KERNEL);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	buf[0] = 0x04;
 	buf[1] = 0x1A;
@@ -3835,9 +3656,8 @@ int mg_chg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = mg_send_ex_cmd(chip, MG_GET_ID, 0);
 	if (retval != STATUS_SUCCESS) {
@@ -3875,12 +3695,12 @@ int mg_chg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	bufflen = min(12, (int)scsi_bufflen(srb));
 	rtsx_stor_get_xfer_buf(buf, bufflen, srb);
 
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++)
 		buf[i] = buf[4+i];
-	}
-	for (i = 0; i < 24; i++) {
+
+	for (i = 0; i < 24; i++)
 		buf[8+i] = 0;
-	}
+
 	retval = ms_write_bytes(chip, PRO_WRITE_SHORT_DATA,
 				32, WAIT_INT, buf, 32);
 	if (retval != STATUS_SUCCESS) {
@@ -3911,9 +3731,8 @@ int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = mg_send_ex_cmd(chip, MG_MAKE_RMS, 0);
 	if (retval != STATUS_SUCCESS) {
@@ -3968,9 +3787,8 @@ int mg_rsp(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = mg_send_ex_cmd(chip, MG_MAKE_KSE, 0);
 	if (retval != STATUS_SUCCESS) {
@@ -3981,12 +3799,12 @@ int mg_rsp(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	bufflen = min(12, (int)scsi_bufflen(srb));
 	rtsx_stor_get_xfer_buf(buf, bufflen, srb);
 
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++)
 		buf[i] = buf[4+i];
-	}
-	for (i = 0; i < 24; i++) {
+
+	for (i = 0; i < 24; i++)
 		buf[8+i] = 0;
-	}
+
 	retval = ms_write_bytes(chip, PRO_WRITE_SHORT_DATA, 32, WAIT_INT, buf, 32);
 	if (retval != STATUS_SUCCESS) {
 		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
@@ -4016,14 +3834,12 @@ int mg_get_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	buf = kmalloc(1028, GFP_KERNEL);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	buf[0] = 0x04;
 	buf[1] = 0x02;
@@ -4073,14 +3889,12 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	buf = kmalloc(1028, GFP_KERNEL);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	bufflen = min(1028, (int)scsi_bufflen(srb));
 	rtsx_stor_get_xfer_buf(buf, bufflen, srb);
@@ -4088,11 +3902,10 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	retval = mg_send_ex_cmd(chip, MG_SET_IBD, ms_card->mg_entry_num);
 	if (retval != STATUS_SUCCESS) {
 		if (ms_card->mg_auth == 0) {
-			if ((buf[5] & 0xC0) != 0) {
+			if ((buf[5] & 0xC0) != 0)
 				set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
-			} else {
+			else
 				set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
-			}
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
 		}
@@ -4121,11 +3934,10 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		if ((retval < 0) || check_ms_err(chip)) {
 			rtsx_clear_ms_error(chip);
 			if (ms_card->mg_auth == 0) {
-				if ((buf[5] & 0xC0) != 0) {
+				if ((buf[5] & 0xC0) != 0)
 					set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
-				} else {
+				else
 					set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
-				}
 			} else {
 				set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
 			}
@@ -4139,11 +3951,10 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	if ((retval != STATUS_SUCCESS) || check_ms_err(chip)) {
 		rtsx_clear_ms_error(chip);
 		if (ms_card->mg_auth == 0) {
-			if ((buf[5] & 0xC0) != 0) {
+			if ((buf[5] & 0xC0) != 0)
 				set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
-			} else {
+			else
 				set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
-			}
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
 		}
@@ -4187,14 +3998,13 @@ int ms_power_off_card3v3(struct rtsx_chip *chip)
 	int retval;
 
 	retval = disable_card_clock(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	if (chip->asic_code) {
 		retval = ms_pull_ctl_disable(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		RTSX_WRITE_REG(chip, FPGA_PULL_CTL,
 			FPGA_MS_PULL_CTL_BIT | 0x20, FPGA_MS_PULL_CTL_BIT);
@@ -4202,9 +4012,8 @@ int ms_power_off_card3v3(struct rtsx_chip *chip)
 	RTSX_WRITE_REG(chip, CARD_OE, MS_OUTPUT_EN, 0);
 	if (!chip->ft2_fast_mode) {
 		retval = card_power_off(chip, MS_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -4234,9 +4043,8 @@ int release_ms_card(struct rtsx_chip *chip)
 #endif
 
 	retval = ms_power_off_card3v3(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

