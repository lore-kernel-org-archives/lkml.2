Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2IHMxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 08:53:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2IHMxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 08:53:35 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/rts_pstor: remove braces {} in rtsx_scsi.c
Date: Sat,  8 Sep 2012 21:53:24 +0900
Message-Id: <1347108804-4775-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/rtsx_scsi.c |  403 ++++++++++++++-------------------
 1 file changed, 168 insertions(+), 235 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_scsi.c b/drivers/staging/rts_pstor/rtsx_scsi.c
index f2e5842..4f6b00a 100644
--- a/drivers/staging/rts_pstor/rtsx_scsi.c
+++ b/drivers/staging/rts_pstor/rtsx_scsi.c
@@ -135,9 +135,9 @@ void scsi_show_command(struct scsi_cmnd *srb)
 	default: what = "(unknown command)"; unknown_cmd = 1; break;
 	}
 
-	if (srb->cmnd[0] != TEST_UNIT_READY) {
+	if (srb->cmnd[0] != TEST_UNIT_READY)
 		RTSX_DEBUGP("Command %s (%d bytes)\n", what, srb->cmd_len);
-	}
+
 	if (unknown_cmd) {
 		RTSX_DEBUGP("");
 		for (i = 0; i < srb->cmd_len && i < 16; i++)
@@ -317,11 +317,11 @@ static int inquiry(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	};
 
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
-		if (chip->lun2card[lun] == SD_CARD) {
+		if (chip->lun2card[lun] == SD_CARD)
 			inquiry_string = inquiry_sd;
-		} else {
+		else
 			inquiry_string = inquiry_ms;
-		}
+
 	} else if (CHECK_LUN_MODE(chip, SD_MS_1LUN)) {
 		inquiry_string = inquiry_sdms;
 	} else {
@@ -329,9 +329,8 @@ static int inquiry(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	buf = vmalloc(scsi_bufflen(srb));
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 #ifdef SUPPORT_MAGIC_GATE
 	if ((chip->mspro_formatter_enable) &&
@@ -340,23 +339,21 @@ static int inquiry(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	if (chip->mspro_formatter_enable)
 #endif
 	{
-		if (!card || (card == MS_CARD)) {
+		if (!card || (card == MS_CARD))
 			pro_formatter_flag = 1;
-		}
 	}
 
 	if (pro_formatter_flag) {
-		if (scsi_bufflen(srb) < 56) {
+		if (scsi_bufflen(srb) < 56)
 			sendbytes = (unsigned char)(scsi_bufflen(srb));
-		} else {
+		else
 			sendbytes = 56;
-		}
+
 	} else {
-		if (scsi_bufflen(srb) < 36) {
+		if (scsi_bufflen(srb) < 36)
 			sendbytes = (unsigned char)(scsi_bufflen(srb));
-		} else {
+		else
 			sendbytes = 36;
-		}
 	}
 
 	if (sendbytes > 8) {
@@ -371,9 +368,8 @@ static int inquiry(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	if (pro_formatter_flag) {
-		if (sendbytes > 36) {
+		if (sendbytes > 36)
 			memcpy(buf + 36, formatter_inquiry_str, sendbytes - 36);
-		}
 	}
 
 	scsi_set_resid(srb, 0);
@@ -467,9 +463,8 @@ static int request_sense(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	buf = vmalloc(scsi_bufflen(srb));
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	tmp = (unsigned char *)sense;
 	memcpy(buf, tmp, scsi_bufflen(srb));
@@ -494,15 +489,15 @@ static void ms_mode_sense(struct rtsx_chip *chip, u8 cmd,
 
 	if (cmd == MODE_SENSE) {
 		sys_info_offset = 8;
-		if (data_size > 0x68) {
+		if (data_size > 0x68)
 			data_size = 0x68;
-		}
+
 		buf[i++] = 0x67;  /* Mode Data Length */
 	} else {
 		sys_info_offset = 12;
-		if (data_size > 0x6C) {
+		if (data_size > 0x6C)
 			data_size = 0x6C;
-		}
+
 		buf[i++] = 0x00;  /* Mode Data Length (MSB) */
 		buf[i++] = 0x6A;  /* Mode Data Length (LSB) */
 	}
@@ -520,11 +515,11 @@ static void ms_mode_sense(struct rtsx_chip *chip, u8 cmd,
 		}
 
 		/* WP */
-		if (check_card_wp(chip, lun)) {
+		if (check_card_wp(chip, lun))
 			buf[i++] = 0x80;
-		} else {
+		else
 			buf[i++] = 0x00;
-		}
+
 	} else {
 		buf[i++] = 0x00;	/* MediaType */
 		buf[i++] = 0x00;	/* WP */
@@ -545,11 +540,10 @@ static void ms_mode_sense(struct rtsx_chip *chip, u8 cmd,
 		if (data_size >= 11)
 			buf[i++] = 0x00;		/* No Access Control */
 		if (data_size >= 12) {
-			if (support_format) {
+			if (support_format)
 				buf[i++] = 0xC0;	/* SF, SGM */
-			} else {
+			else
 				buf[i++] = 0x00;
-			}
 		}
 	} else {
 		/* The Following Data is the content of "Page 0x20" */
@@ -560,11 +554,10 @@ static void ms_mode_sense(struct rtsx_chip *chip, u8 cmd,
 		if (data_size >= 7)
 			buf[i++] = 0x00;		/* No Access Control */
 		if (data_size >= 8) {
-			if (support_format) {
+			if (support_format)
 				buf[i++] = 0xC0;	/* SF, SGM */
-			} else {
+			else
 				buf[i++] = 0x00;
-			}
 		}
 	}
 
@@ -600,9 +593,8 @@ static int mode_sense(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	if ((chip->lun2card[lun] & MS_CARD)) {
 		if (!card || (card == MS_CARD)) {
 			dataSize = 108;
-			if (chip->mspro_formatter_enable) {
+			if (chip->mspro_formatter_enable)
 				pro_formatter_flag = 1;
-			}
 		}
 	}
 #else
@@ -615,9 +607,8 @@ static int mode_sense(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 #endif
 
 	buf = kmalloc(dataSize, GFP_KERNEL);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	pageCode = srb->cmnd[2] & 0x3f;
 
@@ -632,11 +623,11 @@ static int mode_sense(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 				dataSize = 4;
 				buf[0] = 0x03;
 				buf[1] = 0x00;
-				if (check_card_wp(chip, lun)) {
+				if (check_card_wp(chip, lun))
 					buf[2] = 0x80;
-				} else {
+				else
 					buf[2] = 0x00;
-				}
+
 				buf[3] = 0x00;
 			}
 		} else {
@@ -648,11 +639,10 @@ static int mode_sense(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 				buf[0] = 0x00;
 				buf[1] = 0x06;
 				buf[2] = 0x00;
-				if (check_card_wp(chip, lun)) {
+				if (check_card_wp(chip, lun))
 					buf[3] = 0x80;
-				} else {
+				else
 					buf[3] = 0x00;
-				}
 				buf[4] = 0x00;
 				buf[5] = 0x00;
 				buf[6] = 0x00;
@@ -759,11 +749,11 @@ static int read_write(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if (chip->rw_fail_cnt[lun] == 3) {
 		RTSX_DEBUGP("read/write fail three times in succession\n");
-		if (srb->sc_data_direction == DMA_FROM_DEVICE) {
+		if (srb->sc_data_direction == DMA_FROM_DEVICE)
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
-		} else {
+		else
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
-		}
+
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -776,9 +766,8 @@ static int read_write(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		if (CHECK_PID(chip, 0x5209) && chip->max_payload) {
 			u8 val = 0x10 | (chip->max_payload << 5);
 			retval = rtsx_write_cfg_dw(chip, 0, 0x78, 0xFF, val);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_ERROR);
-			}
 		}
 	}
 
@@ -789,11 +778,10 @@ static int read_write(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		} else {
 			chip->rw_fail_cnt[lun]++;
-			if (srb->sc_data_direction == DMA_FROM_DEVICE) {
+			if (srb->sc_data_direction == DMA_FROM_DEVICE)
 				set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
-			} else {
+			else
 				set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
-			}
 		}
 		retval = TRANSPORT_FAILED;
 		TRACE_GOTO(chip, Exit);
@@ -808,9 +796,8 @@ Exit:
 	if (srb->sc_data_direction == DMA_TO_DEVICE) {
 		if (CHECK_PID(chip, 0x5209) && chip->max_payload) {
 			retval = rtsx_write_cfg_dw(chip, 0, 0x78, 0xFF, 0x10);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_ERROR);
-			}
 		}
 	}
 
@@ -837,9 +824,8 @@ static int read_format_capacity(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	buf_len = (scsi_bufflen(srb) > 12) ? 0x14 : 12;
 
 	buf = kmalloc(buf_len, GFP_KERNEL);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	buf[i++] = 0;
 	buf[i++] = 0;
@@ -864,22 +850,20 @@ static int read_format_capacity(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			buf[i++] = (unsigned char)(card_size >> 8);
 			buf[i++] = (unsigned char)card_size;
 
-			if (desc_cnt == 2) {
+			if (desc_cnt == 2)
 				buf[i++] = 2;
-			} else {
+			else
 				buf[i++] = 0;
-			}
 		} else {
 			buf[i++] = 0xFF;
 			buf[i++] = 0xFF;
 			buf[i++] = 0xFF;
 			buf[i++] = 0xFF;
 
-			if (desc_cnt == 2) {
+			if (desc_cnt == 2)
 				buf[i++] = 3;
-			} else {
+			else
 				buf[i++] = 0;
-			}
 		}
 
 		buf[i++] = 0x00;
@@ -916,9 +900,8 @@ static int read_capacity(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	buf = kmalloc(8, GFP_KERNEL);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	card_size = get_card_size(chip, lun);
 	buf[0] = (unsigned char)((card_size - 1) >> 24);
@@ -956,9 +939,8 @@ static int read_eeprom(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	len = ((u16)srb->cmnd[4] << 8) | srb->cmnd[5];
 
 	buf = (u8 *)vmalloc(len);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	retval = rtsx_force_power_on(chip, SSC_PDCTL);
 	if (retval != STATUS_SUCCESS) {
@@ -1016,9 +998,8 @@ static int write_eeprom(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	} else {
 		len = (unsigned short)min(scsi_bufflen(srb), (unsigned int)len);
 		buf = (u8 *)vmalloc(len);
-		if (buf == NULL) {
+		if (buf == NULL)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 
 		rtsx_stor_get_xfer_buf(buf, len, srb);
 		scsi_set_resid(srb, scsi_bufflen(srb) - len);
@@ -1061,9 +1042,8 @@ static int read_mem(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	buf = (u8 *)vmalloc(len);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	retval = rtsx_force_power_on(chip, SSC_PDCTL);
 	if (retval != STATUS_SUCCESS) {
@@ -1114,9 +1094,8 @@ static int write_mem(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	len = (unsigned short)min(scsi_bufflen(srb), (unsigned int)len);
 	buf = (u8 *)vmalloc(len);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	rtsx_stor_get_xfer_buf(buf, len, srb);
 	scsi_set_resid(srb, scsi_bufflen(srb) - len);
@@ -1200,16 +1179,15 @@ static int trace_msg_cmd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	clear = srb->cmnd[2];
 
 	buf = (unsigned char *)vmalloc(scsi_bufflen(srb));
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 	ptr = buf;
 
-	if (chip->trace_msg[chip->msg_idx].valid) {
+	if (chip->trace_msg[chip->msg_idx].valid)
 		msg_cnt = TRACE_ITEM_CNT;
-	} else {
+	else
 		msg_cnt = chip->msg_idx;
-	}
+
 	*(ptr++) = (u8)(msg_cnt >> 24);
 	*(ptr++) = (u8)(msg_cnt >> 16);
 	*(ptr++) = (u8)(msg_cnt >> 8);
@@ -1225,15 +1203,14 @@ static int trace_msg_cmd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 		*(ptr++) = (u8)(chip->trace_msg[idx].line >> 8);
 		*(ptr++) = (u8)(chip->trace_msg[idx].line);
-		for (j = 0; j < MSG_FUNC_LEN; j++) {
+		for (j = 0; j < MSG_FUNC_LEN; j++)
 			*(ptr++) = chip->trace_msg[idx].func[j];
-		}
-		for (j = 0; j < MSG_FILE_LEN; j++) {
+
+		for (j = 0; j < MSG_FILE_LEN; j++)
 			*(ptr++) = chip->trace_msg[idx].file[j];
-		}
-		for (j = 0; j < TIME_VAL_LEN; j++) {
+
+		for (j = 0; j < TIME_VAL_LEN; j++)
 			*(ptr++) = chip->trace_msg[idx].timeval_buf[j];
-		}
 	}
 
 	rtsx_stor_set_xfer_buf(buf, scsi_bufflen(srb), srb);
@@ -1424,20 +1401,19 @@ static int dma_access_ring_buffer(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	len = ((u16)(srb->cmnd[4]) << 8) | srb->cmnd[5];
 	len = min(len, (u16)scsi_bufflen(srb));
 
-	if (srb->sc_data_direction == DMA_FROM_DEVICE) {
+	if (srb->sc_data_direction == DMA_FROM_DEVICE)
 		RTSX_DEBUGP("Read from device\n");
-	} else {
+	else
 		RTSX_DEBUGP("Write to device\n");
-	}
 
 	retval = rtsx_transfer_data(chip, 0, scsi_sglist(srb), len,
 			scsi_sg_count(srb), srb->sc_data_direction, 1000);
 	if (retval < 0) {
-		if (srb->sc_data_direction == DMA_FROM_DEVICE) {
+		if (srb->sc_data_direction == DMA_FROM_DEVICE)
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
-		} else {
+		else
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
-		}
+
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 	scsi_set_resid(srb, 0);
@@ -1462,22 +1438,20 @@ static int get_dev_status(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	status[0] = (u8)(chip->product_id);
 	status[1] = chip->ic_version;
 
-	if (chip->auto_delink_en) {
+	if (chip->auto_delink_en)
 		status[2] = 0x10;
-	} else {
+	else
 		status[2] = 0x00;
-	}
 
 	status[3] = 20;
 	status[4] = 10;
 	status[5] = 05;
 	status[6] = 21;
 
-	if (chip->card_wp) {
+	if (chip->card_wp)
 		status[7] = 0x20;
-	} else {
+	else
 		status[7] = 0x00;
-	}
 
 #ifdef SUPPORT_OCP
 	status[8] = 0;
@@ -1489,67 +1463,60 @@ static int get_dev_status(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		oc_ever_mask = SD_OC_EVER;
 	}
 
-	if (chip->ocp_stat & oc_now_mask) {
+	if (chip->ocp_stat & oc_now_mask)
 		status[8] |= 0x02;
-	}
-	if (chip->ocp_stat & oc_ever_mask) {
+
+	if (chip->ocp_stat & oc_ever_mask)
 		status[8] |= 0x01;
-	}
 #endif
 
 	if (card == SD_CARD) {
 		if (CHK_SD(sd_card)) {
 			if (CHK_SD_HCXC(sd_card)) {
-				if (sd_card->capacity > 0x4000000) {
+				if (sd_card->capacity > 0x4000000)
 					status[0x0E] = 0x02;
-				} else {
+				else
 					status[0x0E] = 0x01;
-				}
 			} else {
 				status[0x0E] = 0x00;
 			}
 
-			if (CHK_SD_SDR104(sd_card)) {
+			if (CHK_SD_SDR104(sd_card))
 				status[0x0F] = 0x03;
-			} else if (CHK_SD_DDR50(sd_card)) {
+			else if (CHK_SD_DDR50(sd_card))
 				status[0x0F] = 0x04;
-			} else if (CHK_SD_SDR50(sd_card)) {
+			else if (CHK_SD_SDR50(sd_card))
 				status[0x0F] = 0x02;
-			} else if (CHK_SD_HS(sd_card)) {
+			else if (CHK_SD_HS(sd_card))
 				status[0x0F] = 0x01;
-			} else {
+			else
 				status[0x0F] = 0x00;
-			}
 		} else {
-			if (CHK_MMC_SECTOR_MODE(sd_card)) {
+			if (CHK_MMC_SECTOR_MODE(sd_card))
 				status[0x0E] = 0x01;
-			} else {
+			else
 				status[0x0E] = 0x00;
-			}
 
-			if (CHK_MMC_DDR52(sd_card)) {
+			if (CHK_MMC_DDR52(sd_card))
 				status[0x0F] = 0x03;
-			} else if (CHK_MMC_52M(sd_card)) {
+			else if (CHK_MMC_52M(sd_card))
 				status[0x0F] = 0x02;
-			} else if (CHK_MMC_26M(sd_card)) {
+			else if (CHK_MMC_26M(sd_card))
 				status[0x0F] = 0x01;
-			} else {
+			else
 				status[0x0F] = 0x00;
-			}
 		}
 	} else if (card == MS_CARD) {
 		if (CHK_MSPRO(ms_card)) {
-			if (CHK_MSXC(ms_card)) {
+			if (CHK_MSXC(ms_card))
 				status[0x0E] = 0x01;
-			} else {
+			else
 				status[0x0E] = 0x00;
-			}
 
-			if (CHK_HG8BIT(ms_card)) {
+			if (CHK_HG8BIT(ms_card))
 				status[0x0F] = 0x01;
-			} else {
+			else
 				status[0x0F] = 0x00;
-			}
 		}
 	}
 
@@ -1600,37 +1567,35 @@ static int set_chip_mode(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	if (phy_debug_mode) {
 		chip->phy_debug_mode = 1;
 		retval = rtsx_write_register(chip, CDRESUMECTL, 0x77, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_FAILED);
-		}
+
 		rtsx_disable_bus_int(chip);
 
 		retval = rtsx_read_phy_register(chip, 0x1C, &reg);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_FAILED);
-		}
+
 		reg |= 0x0001;
 		retval = rtsx_write_phy_register(chip, 0x1C, reg);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_FAILED);
-		}
 	} else {
 		chip->phy_debug_mode = 0;
 		retval = rtsx_write_register(chip, CDRESUMECTL, 0x77, 0x77);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_FAILED);
-		}
+
 		rtsx_enable_bus_int(chip);
 
 		retval = rtsx_read_phy_register(chip, 0x1C, &reg);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_FAILED);
-		}
+
 		reg &= 0xFFFE;
 		retval = rtsx_write_phy_register(chip, 0x1C, reg);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_FAILED);
-		}
 	}
 
 	return TRANSPORT_GOOD;
@@ -1737,9 +1702,8 @@ static int read_phy_register(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if (len) {
 		buf = (u8 *)vmalloc(len);
-		if (!buf) {
+		if (!buf)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 
 		retval = rtsx_force_power_on(chip, SSC_PDCTL);
 		if (retval != STATUS_SUCCESS) {
@@ -1795,9 +1759,8 @@ static int write_phy_register(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		len = (unsigned short)min(scsi_bufflen(srb), (unsigned int)len);
 
 		buf = (u8 *)vmalloc(len);
-		if (buf == NULL) {
+		if (buf == NULL)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 
 		rtsx_stor_get_xfer_buf(buf, len, srb);
 		scsi_set_resid(srb, scsi_bufflen(srb) - len);
@@ -1886,9 +1849,8 @@ static int read_eeprom2(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	len = ((u16)srb->cmnd[6] << 8) | srb->cmnd[7];
 
 	buf = (u8 *)vmalloc(len);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	retval = rtsx_force_power_on(chip, SSC_PDCTL);
 	if (retval != STATUS_SUCCESS) {
@@ -1934,9 +1896,8 @@ static int write_eeprom2(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	len = (unsigned short)min(scsi_bufflen(srb), (unsigned int)len);
 	buf = (u8 *)vmalloc(len);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	rtsx_stor_get_xfer_buf(buf, len, srb);
 	scsi_set_resid(srb, scsi_bufflen(srb) - len);
@@ -1980,9 +1941,8 @@ static int read_efuse(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	len = srb->cmnd[5];
 
 	buf = (u8 *)vmalloc(len);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	retval = rtsx_force_power_on(chip, SSC_PDCTL);
 	if (retval != STATUS_SUCCESS) {
@@ -2029,9 +1989,8 @@ static int write_efuse(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	len = (u8)min(scsi_bufflen(srb), (unsigned int)len);
 	buf = (u8 *)vmalloc(len);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	rtsx_stor_get_xfer_buf(buf, len, srb);
 	scsi_set_resid(srb, scsi_bufflen(srb) - len);
@@ -2093,27 +2052,23 @@ Exit:
 	vfree(buf);
 
 	retval = card_power_off(chip, SPI_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	if (chip->asic_code) {
 		retval = rtsx_write_register(chip, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_OFF);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 
 		wait_timeout(600);
 
 		retval = rtsx_write_phy_register(chip, 0x08, val);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 
 		retval = rtsx_write_register(chip, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_ON);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, TRANSPORT_ERROR);
-		}
 	}
 
 	return result;
@@ -2140,11 +2095,10 @@ static int read_cfg_byte(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	RTSX_DEBUGP("%s: func = %d, addr = 0x%x, len = %d\n", __func__, func, addr, len);
 
-	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip)) {
+	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip))
 		func_max = 1;
-	} else {
+	else
 		func_max = 0;
-	}
 
 	if (func > func_max) {
 		set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
@@ -2152,9 +2106,8 @@ static int read_cfg_byte(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	buf = (u8 *)vmalloc(len);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	retval = rtsx_read_cfg_seq(chip, func, addr, buf, len);
 	if (retval != STATUS_SUCCESS) {
@@ -2193,11 +2146,10 @@ static int write_cfg_byte(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	RTSX_DEBUGP("%s: func = %d, addr = 0x%x\n", __func__, func, addr);
 
-	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip)) {
+	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip))
 		func_max = 1;
-	} else {
+	else
 		func_max = 0;
-	}
 
 	if (func > func_max) {
 		set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
@@ -2206,9 +2158,8 @@ static int write_cfg_byte(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	len = (unsigned short)min(scsi_bufflen(srb), (unsigned int)len);
 	buf = (u8 *)vmalloc(len);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	rtsx_stor_get_xfer_buf(buf, len, srb);
 	scsi_set_resid(srb, scsi_bufflen(srb) - len);
@@ -2328,63 +2279,56 @@ static int read_status(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	rtsx_status[4] = (u8)lun;
 
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
-		if (chip->lun2card[lun] == SD_CARD) {
+		if (chip->lun2card[lun] == SD_CARD)
 			rtsx_status[5] = 2;
-		} else {
+		else
 			rtsx_status[5] = 3;
-		}
 	} else {
 		if (chip->card_exist) {
-			if (chip->card_exist & XD_CARD) {
+			if (chip->card_exist & XD_CARD)
 				rtsx_status[5] = 4;
-			} else if (chip->card_exist & SD_CARD) {
+			else if (chip->card_exist & SD_CARD)
 				rtsx_status[5] = 2;
-			} else if (chip->card_exist & MS_CARD) {
+			else if (chip->card_exist & MS_CARD)
 				rtsx_status[5] = 3;
-			} else {
+			else
 				rtsx_status[5] = 7;
-			}
 		} else {
 			rtsx_status[5] = 7;
 		}
 	}
 
-	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
+	if (CHECK_LUN_MODE(chip, SD_MS_2LUN))
 		rtsx_status[6] = 2;
-	} else {
+	else
 		rtsx_status[6] = 1;
-	}
 
 	rtsx_status[7] = (u8)(chip->product_id);
 	rtsx_status[8] = chip->ic_version;
 
-	if (check_card_exist(chip, lun)) {
+	if (check_card_exist(chip, lun))
 		rtsx_status[9] = 1;
-	} else {
+	else
 		rtsx_status[9] = 0;
-	}
 
-	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
+	if (CHECK_LUN_MODE(chip, SD_MS_2LUN))
 		rtsx_status[10] = 0;
-	} else {
+	else
 		rtsx_status[10] = 1;
-	}
 
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
-		if (chip->lun2card[lun] == SD_CARD) {
+		if (chip->lun2card[lun] == SD_CARD)
 			rtsx_status[11] = SD_CARD;
-		} else {
+		else
 			rtsx_status[11] = MS_CARD;
-		}
 	} else {
 		rtsx_status[11] = XD_CARD | SD_CARD | MS_CARD;
 	}
 
-	if (check_card_ready(chip, lun)) {
+	if (check_card_ready(chip, lun))
 		rtsx_status[12] = 1;
-	} else {
+	else
 		rtsx_status[12] = 0;
-	}
 
 	if (get_lun_card(chip, lun) == XD_CARD) {
 		rtsx_status[13] = 0x40;
@@ -2421,29 +2365,26 @@ static int read_status(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	} else {
 		if (CHECK_LUN_MODE(chip, DEFAULT_SINGLE)) {
 #ifdef SUPPORT_SDIO
-			if (chip->sd_io && chip->sd_int) {
+			if (chip->sd_io && chip->sd_int)
 				rtsx_status[13] = 0x60;
-			} else {
+			else
 				rtsx_status[13] = 0x70;
-			}
 #else
 			rtsx_status[13] = 0x70;
 #endif
 		} else {
-			if (chip->lun2card[lun] == SD_CARD) {
+			if (chip->lun2card[lun] == SD_CARD)
 				rtsx_status[13] = 0x20;
-			} else {
+			else
 				rtsx_status[13] = 0x30;
-			}
 		}
 	}
 
 	rtsx_status[14] = 0x78;
-	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip)) {
+	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip))
 		rtsx_status[15] = 0x83;
-	} else {
+	else
 		rtsx_status[15] = 0x82;
-	}
 
 	buf_len = min(scsi_bufflen(srb), (unsigned int)sizeof(rtsx_status));
 	rtsx_stor_set_xfer_buf(rtsx_status, buf_len, srb);
@@ -2538,9 +2479,8 @@ static int spi_vendor_cmd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	rtsx_write_register(chip, CARD_GPIO_DIR, 0x07, gpio_dir);
 
-	if (result != STATUS_SUCCESS) {
+	if (result != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
-	}
 
 	return TRANSPORT_GOOD;
 }
@@ -2610,13 +2550,12 @@ void led_shine(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u16 sec_cnt;
 
-	if ((srb->cmnd[0] == READ_10) || (srb->cmnd[0] == WRITE_10)) {
+	if ((srb->cmnd[0] == READ_10) || (srb->cmnd[0] == WRITE_10))
 		sec_cnt = ((u16)(srb->cmnd[7]) << 8) | srb->cmnd[8];
-	} else if ((srb->cmnd[0] == READ_6) || (srb->cmnd[0] == WRITE_6)) {
+	else if ((srb->cmnd[0] == READ_6) || (srb->cmnd[0] == WRITE_6))
 		sec_cnt = srb->cmnd[4];
-	} else {
+	else
 		return;
-	}
 
 	if (chip->rw_cap[lun] >= GPIO_TOGGLE_THRESHOLD) {
 		toggle_gpio(chip, LED_GPIO);
@@ -2659,11 +2598,10 @@ static int ms_format_cmnd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 	rtsx_set_stat(chip, RTSX_STAT_RUN);
 
-	if (srb->cmnd[8] & 0x01) {
+	if (srb->cmnd[8] & 0x01)
 		quick_format = 0;
-	} else {
+	else
 		quick_format = 1;
-	}
 
 	if (!(chip->card_ready & MS_CARD)) {
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
@@ -2724,27 +2662,25 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
-	if (dev_info_id == 0x15) {
+	if (dev_info_id == 0x15)
 		buf_len = data_len = 0x3A;
-	} else {
+	else
 		buf_len = data_len = 0x6A;
-	}
 
 	buf = kmalloc(buf_len, GFP_KERNEL);
-	if (!buf) {
+	if (!buf)
 		TRACE_RET(chip, TRANSPORT_ERROR);
-	}
 
 	i = 0;
 	/*  GET Memory Stick Media Information Response Header */
 	buf[i++] = 0x00;		/* Data length MSB */
 	buf[i++] = data_len; 		/* Data length LSB */
 	/* Device Information Type Code */
-	if (CHK_MSXC(ms_card)) {
+	if (CHK_MSXC(ms_card))
 		buf[i++] = 0x03;
-	} else {
+	else
 		buf[i++] = 0x02;
-	}
+
 	/* SGM bit */
 	buf[i++] = 0x01;
 	/* Reserved */
@@ -2759,11 +2695,11 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	/* Device Information ID Number */
 	buf[i++] = dev_info_id;
 	/* Device Information Length */
-	if (dev_info_id == 0x15) {
+	if (dev_info_id == 0x15)
 		data_len = 0x31;
-	} else {
+	else
 		data_len = 0x61;
-	}
+
 	buf[i++] = 0x00;		/* Data length MSB */
 	buf[i++] = data_len; 		/* Data length LSB */
 	/* Valid Bit */
@@ -2778,11 +2714,10 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	rtsx_stor_set_xfer_buf(buf, buf_len, srb);
 
-	if (dev_info_id == 0x15) {
+	if (dev_info_id == 0x15)
 		scsi_set_resid(srb, scsi_bufflen(srb)-0x3C);
-	} else {
+	else
 		scsi_set_resid(srb, scsi_bufflen(srb)-0x6C);
-	}
 
 	kfree(buf);
 	return STATUS_SUCCESS;
@@ -2793,13 +2728,11 @@ static int ms_sp_cmnd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 {
 	int retval = TRANSPORT_ERROR;
 
-	if (srb->cmnd[2] == MS_FORMAT) {
+	if (srb->cmnd[2] == MS_FORMAT)
 		retval = ms_format_cmnd(srb, chip);
-	}
 #ifdef SUPPORT_PCGL_1P18
-	else if (srb->cmnd[2] == GET_MS_INFORMATION) {
+	else if (srb->cmnd[2] == GET_MS_INFORMATION)
 		retval = get_ms_information(srb, chip);
-	}
 #endif
 
 	return retval;
@@ -2912,9 +2845,9 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			(srb->cmnd[8] == 0x04) &&
 			(srb->cmnd[9] == 0x1C)) {
 			retval = mg_get_local_EKB(srb, chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -2926,9 +2859,9 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			(srb->cmnd[8] == 0x00) &&
 			(srb->cmnd[9] == 0x24)) {
 			retval = mg_get_rsp_chg(srb, chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -2945,9 +2878,9 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			(srb->cmnd[4] == 0x00) &&
 			(srb->cmnd[5] < 32)) {
 			retval = mg_get_ICV(srb, chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -3014,9 +2947,9 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			(srb->cmnd[8] == 0x00) &&
 			(srb->cmnd[9] == 0x0C)) {
 			retval = mg_set_leaf_id(srb, chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -3028,9 +2961,9 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			(srb->cmnd[8] == 0x00) &&
 			(srb->cmnd[9] == 0x0C)) {
 			retval = mg_chg(srb, chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -3042,9 +2975,9 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			(srb->cmnd[8] == 0x00) &&
 			(srb->cmnd[9] == 0x0C)) {
 			retval = mg_rsp(srb, chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -3061,9 +2994,9 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 			(srb->cmnd[4] == 0x00) &&
 			(srb->cmnd[5] < 32)) {
 			retval = mg_set_ICV(srb, chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
-			}
+
 		} else {
 			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
-- 
1.7.9.5

