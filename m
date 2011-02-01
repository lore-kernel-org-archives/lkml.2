Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1BAS3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:29:19 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:43837
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752077Ab1BAS3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:29:17 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: wei_wang@realsil.com.cn, tvh@informatik.uni-kiel.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rts_pstor: fixed some brace code styling issues
Date: Tue,  1 Feb 2011 19:28:46 +0100
Message-Id: <1296584926-2013-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: b7a3913c3904e5511f44aecc307a0515
X-Authenticated-Sender: user tvh from 134.245.38.234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all brace coding style issues in the following files:
drivers/staging/rts_pstor/rtsx_card.h
drivers/staging/rts_pstor/spi.c
drivers/staging/rts_pstor/trace.h
drivers/staging/rts_pstor/xd.c

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/rts_pstor/rtsx_card.h |   10 +-
 drivers/staging/rts_pstor/spi.c       |  109 ++++--------
 drivers/staging/rts_pstor/trace.h     |    7 +-
 drivers/staging/rts_pstor/xd.c        |  301 ++++++++++++---------------------
 4 files changed, 150 insertions(+), 277 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_card.h b/drivers/staging/rts_pstor/rtsx_card.h
index 5a0e167..3f72776 100644
--- a/drivers/staging/rts_pstor/rtsx_card.h
+++ b/drivers/staging/rts_pstor/rtsx_card.h
@@ -1035,11 +1035,10 @@ static inline u32 get_card_size(struct rtsx_chip *chip, unsigned int lun)
 #ifdef SUPPORT_SD_LOCK
 	struct sd_info *sd_card = &(chip->sd_card);
 
-	if ((get_lun_card(chip, lun) == SD_CARD) && (sd_card->sd_lock_status & SD_LOCKED)) {
+	if ((get_lun_card(chip, lun) == SD_CARD) && (sd_card->sd_lock_status & SD_LOCKED))
 		return 0;
-	} else {
+	else
 		return chip->capacity[lun];
-	}
 #else
 	return chip->capacity[lun];
 #endif
@@ -1049,11 +1048,10 @@ static inline int switch_clock(struct rtsx_chip *chip, int clk)
 {
 	int retval = 0;
 
-	if (chip->asic_code) {
+	if (chip->asic_code)
 		retval = switch_ssc_clock(chip, clk);
-	} else {
+	else
 		retval = switch_normal_clock(chip, clk);
-	}
 
 	return retval;
 }
diff --git a/drivers/staging/rts_pstor/spi.c b/drivers/staging/rts_pstor/spi.c
index 84e0af4..e068200 100644
--- a/drivers/staging/rts_pstor/spi.c
+++ b/drivers/staging/rts_pstor/spi.c
@@ -55,14 +55,12 @@ static int spi_set_init_para(struct rtsx_chip *chip)
 	RTSX_WRITE_REG(chip, SPI_CLK_DIVIDER0, 0xFF, (u8)(spi->clk_div));
 
 	retval = switch_clock(chip, spi->spi_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = select_card(chip, SPI_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, CARD_CLK_EN, SPI_CLK_EN, SPI_CLK_EN);
 	RTSX_WRITE_REG(chip, CARD_OE, SPI_OUTPUT_EN, SPI_OUTPUT_EN);
@@ -70,9 +68,8 @@ static int spi_set_init_para(struct rtsx_chip *chip)
 	wait_timeout(10);
 
 	retval = spi_init(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -197,24 +194,21 @@ static int spi_init_eeprom(struct rtsx_chip *chip)
 	int retval;
 	int clk;
 
-	if (chip->asic_code) {
+	if (chip->asic_code)
 		clk = 30;
-	} else {
+	else
 		clk = CLK_30;
-	}
 
 	RTSX_WRITE_REG(chip, SPI_CLK_DIVIDER1, 0xFF, 0x00);
 	RTSX_WRITE_REG(chip, SPI_CLK_DIVIDER0, 0xFF, 0x27);
 
 	retval = switch_clock(chip, clk);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = select_card(chip, SPI_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, CARD_CLK_EN, SPI_CLK_EN, SPI_CLK_EN);
 	RTSX_WRITE_REG(chip, CARD_OE, SPI_OUTPUT_EN, SPI_OUTPUT_EN);
@@ -239,9 +233,8 @@ int spi_eeprom_program_enable(struct rtsx_chip *chip)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, SPI_TRANSFER0, SPI_TRANSFER0_END, SPI_TRANSFER0_END);
 
 	retval = rtsx_send_cmd(chip, 0, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -251,14 +244,12 @@ int spi_erase_eeprom_chip(struct rtsx_chip *chip)
 	int retval;
 
 	retval = spi_init_eeprom(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = spi_eeprom_program_enable(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -270,9 +261,8 @@ int spi_erase_eeprom_chip(struct rtsx_chip *chip)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, SPI_TRANSFER0, SPI_TRANSFER0_END, SPI_TRANSFER0_END);
 
 	retval = rtsx_send_cmd(chip, 0, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, CARD_GPIO_DIR, 0x01, 0x01);
 
@@ -284,14 +274,12 @@ int spi_erase_eeprom_byte(struct rtsx_chip *chip, u16 addr)
 	int retval;
 
 	retval = spi_init_eeprom(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = spi_eeprom_program_enable(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -305,9 +293,8 @@ int spi_erase_eeprom_byte(struct rtsx_chip *chip, u16 addr)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, SPI_TRANSFER0, SPI_TRANSFER0_END, SPI_TRANSFER0_END);
 
 	retval = rtsx_send_cmd(chip, 0, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, CARD_GPIO_DIR, 0x01, 0x01);
 
@@ -321,9 +308,8 @@ int spi_read_eeprom(struct rtsx_chip *chip, u16 addr, u8 *val)
 	u8 data;
 
 	retval = spi_init_eeprom(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -338,16 +324,14 @@ int spi_read_eeprom(struct rtsx_chip *chip, u16 addr, u8 *val)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, SPI_TRANSFER0, SPI_TRANSFER0_END, SPI_TRANSFER0_END);
 
 	retval = rtsx_send_cmd(chip, 0, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	wait_timeout(5);
 	RTSX_READ_REG(chip, SPI_DATA, &data);
 
-	if (val) {
+	if (val)
 		*val = data;
-	}
 
 	RTSX_WRITE_REG(chip, CARD_GPIO_DIR, 0x01, 0x01);
 
@@ -359,14 +343,12 @@ int spi_write_eeprom(struct rtsx_chip *chip, u16 addr, u8 val)
 	int retval;
 
 	retval = spi_init_eeprom(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = spi_eeprom_program_enable(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -381,9 +363,8 @@ int spi_write_eeprom(struct rtsx_chip *chip, u16 addr, u8 val)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, SPI_TRANSFER0, SPI_TRANSFER0_END, SPI_TRANSFER0_END);
 
 	retval = rtsx_send_cmd(chip, 0, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, CARD_GPIO_DIR, 0x01, 0x01);
 
@@ -408,11 +389,10 @@ int spi_set_parameter(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	spi_set_err_code(chip, SPI_NO_ERR);
 
-	if (chip->asic_code) {
+	if (chip->asic_code)
 		spi->spi_clock = ((u16)(srb->cmnd[8]) << 8) | srb->cmnd[9];
-	} else {
+	else
 		spi->spi_clock = srb->cmnd[3];
-	}
 
 	spi->clk_div = ((u16)(srb->cmnd[4]) << 8) | srb->cmnd[5];
 	spi->write_en = srb->cmnd[6];
@@ -484,9 +464,8 @@ int spi_read_flash_id(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if (len) {
 		buf = (u8 *)kmalloc(len, GFP_KERNEL);
-		if (!buf) {
+		if (!buf)
 			TRACE_RET(chip, STATUS_ERROR);
-		}
 
 		retval = rtsx_read_ppbuf(chip, buf, len);
 		if (retval != STATUS_SUCCESS) {
@@ -527,16 +506,14 @@ int spi_read_flash(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	buf = (u8 *)rtsx_alloc_dma_buf(chip, SF_PAGE_LEN, GFP_KERNEL);
-	if (buf == NULL) {
+	if (buf == NULL)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	while (len) {
 		u16 pagelen = SF_PAGE_LEN - (u8)addr;
 
-		if (pagelen > len) {
+		if (pagelen > len)
 			pagelen = len;
-		}
 
 		rtsx_init_cmd(chip);
 
@@ -608,9 +585,8 @@ int spi_write_flash(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if (program_mode == BYTE_PROGRAM) {
 		buf = rtsx_alloc_dma_buf(chip, 4, GFP_KERNEL);
-		if (!buf) {
+		if (!buf)
 			TRACE_RET(chip, STATUS_ERROR);
-		}
 
 		while (len) {
 			retval = sf_enable_write(chip, SPI_WREN);
@@ -651,14 +627,12 @@ int spi_write_flash(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		int first_byte = 1;
 
 		retval = sf_enable_write(chip, SPI_WREN);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		buf = rtsx_alloc_dma_buf(chip, 4, GFP_KERNEL);
-		if (!buf) {
+		if (!buf)
 			TRACE_RET(chip, STATUS_ERROR);
-		}
 
 		while (len) {
 			rtsx_stor_access_xfer_buf(buf, 1, srb, &index, &offset, FROM_XFER_BUF);
@@ -694,26 +668,22 @@ int spi_write_flash(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		rtsx_free_dma_buf(chip, buf);
 
 		retval = sf_disable_write(chip, SPI_WRDI);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = sf_polling_status(chip, 100);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else if (program_mode == PAGE_PROGRAM) {
 		buf = rtsx_alloc_dma_buf(chip, SF_PAGE_LEN, GFP_KERNEL);
-		if (!buf) {
+		if (!buf)
 			TRACE_RET(chip, STATUS_NOMEM);
-		}
 
 		while (len) {
 			u16 pagelen = SF_PAGE_LEN - (u8)addr;
 
-			if (pagelen > len) {
+			if (pagelen > len)
 				pagelen = len;
-			}
 
 			retval = sf_enable_write(chip, SPI_WREN);
 			if (retval != STATUS_SUCCESS) {
@@ -777,24 +747,20 @@ int spi_erase_flash(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if (erase_mode == PAGE_ERASE) {
 		retval = sf_enable_write(chip, SPI_WREN);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = sf_erase(chip, ins, 1, addr);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else if (erase_mode == CHIP_ERASE) {
 		retval = sf_enable_write(chip, SPI_WREN);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = sf_erase(chip, ins, 0, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		spi_set_err_code(chip, SPI_INVALID_COMMAND);
 		TRACE_RET(chip, STATUS_FAIL);
@@ -819,9 +785,8 @@ int spi_write_flash_status(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	retval = sf_enable_write(chip, ewsr);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
index 1b89589..2c668ba 100644
--- a/drivers/staging/rts_pstor/trace.h
+++ b/drivers/staging/rts_pstor/trace.h
@@ -31,16 +31,15 @@ static inline char *filename(char *path)
 {
 	char *ptr;
 
-	if (path == NULL) {
+	if (path == NULL)
 		return NULL;
-	}
 
 	ptr = path;
 
 	while (*ptr != '\0') {
-		if ((*ptr == '\\') || (*ptr == '/')) {
+		if ((*ptr == '\\') || (*ptr == '/'))
 			path = ptr + 1;
-		}
+		
 		ptr++;
 	}
 
diff --git a/drivers/staging/rts_pstor/xd.c b/drivers/staging/rts_pstor/xd.c
index f654c8b..7bcd468 100644
--- a/drivers/staging/rts_pstor/xd.c
+++ b/drivers/staging/rts_pstor/xd.c
@@ -52,16 +52,14 @@ static int xd_set_init_para(struct rtsx_chip *chip)
 	struct xd_info *xd_card = &(chip->xd_card);
 	int retval;
 
-	if (chip->asic_code) {
+	if (chip->asic_code)
 		xd_card->xd_clock = 47;
-	} else {
+	else
 		xd_card->xd_clock = CLK_50;
-	}
 
 	retval = switch_clock(chip, xd_card->xd_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -72,14 +70,12 @@ static int xd_switch_clock(struct rtsx_chip *chip)
 	int retval;
 
 	retval = select_card(chip, XD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = switch_clock(chip, xd_card->xd_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -95,14 +91,12 @@ static int xd_read_id(struct rtsx_chip *chip, u8 id_cmd, u8 *id_buf, u8 buf_len)
 	rtsx_add_cmd(chip, WRITE_REG_CMD, XD_TRANSFER, 0xFF, XD_TRANSFER_START | XD_READ_ID);
 	rtsx_add_cmd(chip, CHECK_REG_CMD, XD_TRANSFER, XD_TRANSFER_END, XD_TRANSFER_END);
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < 4; i++)
 		rtsx_add_cmd(chip, READ_REG_CMD, (u16)(XD_ADDRESS1 + i), 0, 0);
-	}
 
 	retval = rtsx_send_cmd(chip, XD_CARD, 20);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ptr = rtsx_get_cmd_data(chip) + 1;
 	if (id_buf && buf_len) {
@@ -152,18 +146,15 @@ static int xd_read_redundant(struct rtsx_chip *chip, u32 page_addr, u8 *buf, int
 	rtsx_add_cmd(chip, WRITE_REG_CMD, XD_TRANSFER, 0xFF, XD_TRANSFER_START | XD_READ_REDUNDANT);
 	rtsx_add_cmd(chip, CHECK_REG_CMD, XD_TRANSFER, XD_TRANSFER_END, XD_TRANSFER_END);
 
-	for (i = 0; i < 6; i++) {
+	for (i = 0; i < 6; i++)
 		rtsx_add_cmd(chip, READ_REG_CMD, (u16)(XD_PAGE_STATUS + i), 0, 0);
-	}
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < 4; i++)
 		rtsx_add_cmd(chip, READ_REG_CMD, (u16)(XD_RESERVED0 + i), 0, 0);
-	}
 	rtsx_add_cmd(chip, READ_REG_CMD, XD_PARITY, 0, 0);
 
 	retval = rtsx_send_cmd(chip, XD_CARD, 500);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (buf && buf_len) {
 		u8 *ptr = rtsx_get_cmd_data(chip) + 1;
@@ -180,15 +171,13 @@ static int xd_read_data_from_ppb(struct rtsx_chip *chip, int offset, u8 *buf, in
 {
 	int retval, i;
 
-	if (!buf || (buf_len < 0)) {
+	if (!buf || (buf_len < 0))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
-	for (i = 0; i < buf_len; i++) {
+	for (i = 0; i < buf_len; i++)
 		rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2 + offset + i, 0, 0);
-	}
 
 	retval = rtsx_send_cmd(chip, 0, 250);
 	if (retval < 0) {
@@ -206,9 +195,8 @@ static int xd_read_cis(struct rtsx_chip *chip, u32 page_addr, u8 *buf, int buf_l
 	int retval;
 	u8 reg;
 
-	if (!buf || (buf_len < 10)) {
+	if (!buf || (buf_len < 10))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -236,9 +224,8 @@ static int xd_read_cis(struct rtsx_chip *chip, u32 page_addr, u8 *buf, int buf_l
 	RTSX_READ_REG(chip, XD_CTL, &reg);
 	if (!(reg & XD_ECC1_ERROR) || !(reg & XD_ECC1_UNCORRECTABLE)) {
 		retval = xd_read_data_from_ppb(chip, 0, buf, buf_len);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 		if (reg & XD_ECC1_ERROR) {
 			u8 ecc_bit, ecc_byte;
 
@@ -256,9 +243,8 @@ static int xd_read_cis(struct rtsx_chip *chip, u32 page_addr, u8 *buf, int buf_l
 		rtsx_clear_xd_error(chip);
 
 		retval = xd_read_data_from_ppb(chip, 256, buf, buf_len);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 		if (reg & XD_ECC2_ERROR) {
 			u8 ecc_bit, ecc_byte;
 
@@ -394,9 +380,8 @@ static void xd_clear_dma_buffer(struct rtsx_chip *chip)
 		RTSX_DEBUGP("xD ECC error, dummy write!\n");
 
 		buf = (u8 *)rtsx_alloc_dma_buf(chip, 512, GFP_KERNEL);
-		if (!buf) {
+		if (!buf)
 			return;
-		}
 
 		rtsx_init_cmd(chip);
 
@@ -461,46 +446,40 @@ static int reset_xd(struct rtsx_chip *chip)
 	u8 *ptr, id_buf[4], redunt[11];
 
 	retval = select_card(chip, XD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
 	rtsx_add_cmd(chip, WRITE_REG_CMD, XD_CHK_DATA_STATUS, 0xFF, XD_PGSTS_NOT_FF);
 	if (chip->asic_code) {
-		if (!CHECK_PID(chip, 0x5288)) {
+		if (!CHECK_PID(chip, 0x5288))
 			xd_fill_pull_ctl_disable(chip);
-		} else {
+		else
 			xd_fill_pull_ctl_stage1_barossa(chip);
-		}
 	} else {
 		rtsx_add_cmd(chip, WRITE_REG_CMD, FPGA_PULL_CTL, 0xFF,
 			(FPGA_XD_PULL_CTL_EN1 & FPGA_XD_PULL_CTL_EN3) | 0x20);
 	}
 
-	if (!chip->ft2_fast_mode) {
+	if (!chip->ft2_fast_mode)
 		rtsx_add_cmd(chip, WRITE_REG_CMD, XD_INIT, XD_NO_AUTO_PWR_OFF, 0);
-	}
 
 	rtsx_add_cmd(chip, WRITE_REG_CMD, CARD_OE, XD_OUTPUT_EN, 0);
 
 	retval = rtsx_send_cmd(chip, XD_CARD, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (!chip->ft2_fast_mode) {
 		retval = card_power_off(chip, XD_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		wait_timeout(250);
 
-		if (CHECK_PID(chip, 0x5209)) {
+		if (CHECK_PID(chip, 0x5209))
 			RTSX_WRITE_REG(chip, CARD_PULL_CTL1, 0xFF, 0xAA);
-		}
 
 		rtsx_init_cmd(chip);
 
@@ -512,14 +491,12 @@ static int reset_xd(struct rtsx_chip *chip)
 		}
 
 		retval = rtsx_send_cmd(chip, XD_CARD, 100);
-		if (retval < 0) {
+		if (retval < 0)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		retval = card_power_on(chip, XD_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 #ifdef SUPPORT_OCP
 		wait_timeout(50);
@@ -545,18 +522,15 @@ static int reset_xd(struct rtsx_chip *chip)
 	rtsx_add_cmd(chip, WRITE_REG_CMD, XD_CTL, XD_CE_DISEN, XD_CE_DISEN);
 
 	retval = rtsx_send_cmd(chip, XD_CARD, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if (!chip->ft2_fast_mode) {
+	if (!chip->ft2_fast_mode)
 		wait_timeout(200);
-	}
 
 	retval = xd_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	/* Read ID to check if the timing setting is right */
 	for (i = 0; i < 4; i++) {
@@ -574,22 +548,19 @@ static int reset_xd(struct rtsx_chip *chip)
 		rtsx_add_cmd(chip, READ_REG_CMD, XD_CTL, 0, 0);
 
 		retval = rtsx_send_cmd(chip, XD_CARD, 100);
-		if (retval < 0) {
+		if (retval < 0)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		ptr = rtsx_get_cmd_data(chip) + 1;
 
 		RTSX_DEBUGP("XD_DAT: 0x%x, XD_CTL: 0x%x\n", ptr[0], ptr[1]);
 
-		if (((ptr[0] & READY_FLAG) != READY_STATE) || !(ptr[1] & XD_RDY)) {
+		if (((ptr[0] & READY_FLAG) != READY_STATE) || !(ptr[1] & XD_RDY))
 			continue;
-		}
 
 		retval = xd_read_id(chip, READ_ID, id_buf, 4);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		RTSX_DEBUGP("READ_ID: 0x%x 0x%x 0x%x 0x%x\n",
 					id_buf[0], id_buf[1], id_buf[2], id_buf[3]);
@@ -669,9 +640,8 @@ static int reset_xd(struct rtsx_chip *chip)
 		/* Confirm timing setting */
 		for (j = 0; j < 10; j++) {
 			retval = xd_read_id(chip, READ_ID, id_buf, 4);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			if (id_buf[1] != xd_card->device_code)
 				break;
@@ -691,34 +661,29 @@ static int reset_xd(struct rtsx_chip *chip)
 	}
 
 	retval = xd_read_id(chip, READ_xD_ID, id_buf, 4);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 	RTSX_DEBUGP("READ_xD_ID: 0x%x 0x%x 0x%x 0x%x\n",
 			id_buf[0], id_buf[1], id_buf[2], id_buf[3]);
-	if (id_buf[2] != XD_ID_CODE) {
+	if (id_buf[2] != XD_ID_CODE)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	/* Search CIS block */
 	for (i = 0; i < 24; i++) {
 		u32 page_addr;
 
-		if (detect_card_cd(chip, XD_CARD) != STATUS_SUCCESS) {
+		if (detect_card_cd(chip, XD_CARD) != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		page_addr = (u32)i << xd_card->block_shift;
 
 		for (j = 0; j < 3; j++) {
 			retval = xd_read_redundant(chip, page_addr, redunt, 11);
-			if (retval == STATUS_SUCCESS) {
+			if (retval == STATUS_SUCCESS)
 				break;
-			}
 		}
-		if (j == 3) {
+		if (j == 3)
 			continue;
-		}
 
 		if (redunt[BLOCK_STATUS] != XD_GBLK)
 			continue;
@@ -728,9 +693,8 @@ static int reset_xd(struct rtsx_chip *chip)
 			for (j = 1; j <= 8; j++) {
 				retval = xd_read_redundant(chip, page_addr + j, redunt, 11);
 				if (retval == STATUS_SUCCESS) {
-					if (redunt[PAGE_STATUS] == XD_GPG) {
+					if (redunt[PAGE_STATUS] == XD_GPG)
 						break;
-					}
 				}
 			}
 
@@ -745,9 +709,8 @@ static int reset_xd(struct rtsx_chip *chip)
 			page_addr += j;
 
 			retval = xd_read_cis(chip, page_addr, buf, 10);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			if ((buf[0] == 0x01) && (buf[1] == 0x03) && (buf[2] == 0xD9)
 					&& (buf[3] == 0x01) && (buf[4] == 0xFF)
@@ -762,9 +725,8 @@ static int reset_xd(struct rtsx_chip *chip)
 	}
 
 	RTSX_DEBUGP("CIS block: 0x%x\n", xd_card->cis_block);
-	if (xd_card->cis_block == 0xFFFF) {
+	if (xd_card->cis_block == 0xFFFF)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	chip->capacity[chip->card2lun[XD_CARD]] = xd_card->capacity;
 
@@ -780,9 +742,9 @@ static int xd_check_data_blank(u8 *redunt)
 			return 0;
 	}
 
-	if ((redunt[PARITY] & (XD_ECC1_ALL1 | XD_ECC2_ALL1)) != (XD_ECC1_ALL1 | XD_ECC2_ALL1)) {
+	if ((redunt[PARITY] & (XD_ECC1_ALL1 | XD_ECC2_ALL1)) != (XD_ECC1_ALL1 | XD_ECC2_ALL1))
 		return 0;
-	}
+
 
 	for (i = 0; i < 4; i++) {
 		if (redunt[RESERVED0 + i] != 0xFF)
@@ -796,13 +758,12 @@ static u16 xd_load_log_block_addr(u8 *redunt)
 {
 	u16 addr = 0xFFFF;
 
-	if (redunt[PARITY] & XD_BA1_BA2_EQL) {
+	if (redunt[PARITY] & XD_BA1_BA2_EQL)
 		addr = ((u16)redunt[BLOCK_ADDR1_H] << 8) | redunt[BLOCK_ADDR1_L];
-	} else if (redunt[PARITY] & XD_BA1_VALID) {
+	else if (redunt[PARITY] & XD_BA1_VALID)
 		addr = ((u16)redunt[BLOCK_ADDR1_H] << 8) | redunt[BLOCK_ADDR1_L];
-	} else if (redunt[PARITY] & XD_BA2_VALID) {
+	else if (redunt[PARITY] & XD_BA2_VALID)
 		addr = ((u16)redunt[BLOCK_ADDR2_H] << 8) | redunt[BLOCK_ADDR2_L];
-	}
 
 	return addr;
 }
@@ -814,17 +775,15 @@ static int xd_init_l2p_tbl(struct rtsx_chip *chip)
 
 	RTSX_DEBUGP("xd_init_l2p_tbl: zone_cnt = %d\n", xd_card->zone_cnt);
 
-	if (xd_card->zone_cnt < 1) {
+	if (xd_card->zone_cnt < 1)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	size = xd_card->zone_cnt * sizeof(struct zone_entry);
 	RTSX_DEBUGP("Buffer size for l2p table is %d\n", size);
 
 	xd_card->zone = (struct zone_entry *)vmalloc(size);
-	if (!xd_card->zone) {
+	if (!xd_card->zone)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	for (i = 0; i < xd_card->zone_cnt; i++) {
 		xd_card->zone[i].build_flag = 0;
@@ -874,9 +833,8 @@ static void xd_set_unused_block(struct rtsx_chip *chip, u32 phy_blk)
 	zone = &(xd_card->zone[zone_no]);
 
 	if (zone->free_table == NULL) {
-		if (xd_build_l2p_tbl(chip, zone_no) != STATUS_SUCCESS) {
+		if (xd_build_l2p_tbl(chip, zone_no) != STATUS_SUCCESS)
 			return;
-		}
 	}
 
 	if ((zone->set_index >= XD_FREE_TABLE_CNT)
@@ -889,9 +847,8 @@ static void xd_set_unused_block(struct rtsx_chip *chip, u32 phy_blk)
 	RTSX_DEBUGP("Set unused block to index %d\n", zone->set_index);
 
 	zone->free_table[zone->set_index++] = (u16) (phy_blk & 0x3ff);
-	if (zone->set_index >= XD_FREE_TABLE_CNT) {
+	if (zone->set_index >= XD_FREE_TABLE_CNT)
 		zone->set_index = 0;
-	}
 	zone->unused_blk_cnt++;
 }
 
@@ -923,9 +880,8 @@ static u32 xd_get_unused_block(struct rtsx_chip *chip, int zone_no)
 
 	phy_blk = zone->free_table[zone->get_index];
 	zone->free_table[zone->get_index++] = 0xFFFF;
-	if (zone->get_index >= XD_FREE_TABLE_CNT) {
+	if (zone->get_index >= XD_FREE_TABLE_CNT)
 		zone->get_index = 0;
-	}
 	zone->unused_blk_cnt--;
 
 	phy_blk += ((u32)(zone_no) << 10);
@@ -1004,19 +960,16 @@ int reset_xd_card(struct rtsx_chip *chip)
 	xd_card->delay_write.delay_write_flag = 0;
 
 	retval = enable_card_clock(chip, XD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = reset_xd(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = xd_init_l2p_tbl(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1030,9 +983,8 @@ static int xd_mark_bad_block(struct rtsx_chip *chip, u32 phy_blk)
 
 	RTSX_DEBUGP("mark block 0x%x as bad block\n", phy_blk);
 
-	if (phy_blk == BLK_NOT_FOUND) {
+	if (phy_blk == BLK_NOT_FOUND)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -1060,11 +1012,10 @@ static int xd_mark_bad_block(struct rtsx_chip *chip, u32 phy_blk)
 	if (retval < 0) {
 		rtsx_clear_xd_error(chip);
 		rtsx_read_register(chip, XD_DAT, &reg);
-		if (reg & PROGRAM_ERROR) {
+		if (reg & PROGRAM_ERROR)
 			xd_set_err_code(chip, XD_PRG_ERROR);
-		} else {
+		else
 			xd_set_err_code(chip, XD_TO_ERROR);
-		}
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
@@ -1080,12 +1031,10 @@ static int xd_init_page(struct rtsx_chip *chip, u32 phy_blk, u16 logoff, u8 star
 
 	RTSX_DEBUGP("Init block 0x%x\n", phy_blk);
 
-	if (start_page > end_page) {
+	if (start_page > end_page)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
-	if (phy_blk == BLK_NOT_FOUND) {
+	if (phy_blk == BLK_NOT_FOUND)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -1130,13 +1079,11 @@ static int xd_copy_page(struct rtsx_chip *chip, u32 old_blk, u32 new_blk, u8 sta
 
 	RTSX_DEBUGP("Copy page from block 0x%x to block 0x%x\n", old_blk, new_blk);
 
-	if (start_page > end_page) {
+	if (start_page > end_page)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
-	if ((old_blk == BLK_NOT_FOUND) || (new_blk == BLK_NOT_FOUND)) {
+	if ((old_blk == BLK_NOT_FOUND) || (new_blk == BLK_NOT_FOUND))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	old_page = (old_blk << xd_card->block_shift) + start_page;
 	new_page = (new_blk << xd_card->block_shift) + start_page;
@@ -1189,9 +1136,8 @@ static int xd_copy_page(struct rtsx_chip *chip, u32 old_blk, u32 new_blk, u8 sta
 			}
 		}
 
-		if (XD_CHK_BAD_OLDBLK(xd_card)) {
+		if (XD_CHK_BAD_OLDBLK(xd_card))
 			rtsx_clear_xd_error(chip);
-		}
 
 		rtsx_init_cmd(chip);
 
@@ -1236,14 +1182,12 @@ static int xd_reset_cmd(struct rtsx_chip *chip)
 	rtsx_add_cmd(chip, READ_REG_CMD, XD_CTL, 0, 0);
 
 	retval = rtsx_send_cmd(chip, XD_CARD, 100);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	ptr = rtsx_get_cmd_data(chip) + 1;
-	if (((ptr[0] & READY_FLAG) == READY_STATE) && (ptr[1] & XD_RDY)) {
+	if (((ptr[0] & READY_FLAG) == READY_STATE) && (ptr[1] & XD_RDY))
 		return STATUS_SUCCESS;
-	}
 
 	TRACE_RET(chip, STATUS_FAIL);
 }
@@ -1255,9 +1199,8 @@ static int xd_erase_block(struct rtsx_chip *chip, u32 phy_blk)
 	u8 reg = 0, *ptr;
 	int i, retval;
 
-	if (phy_blk == BLK_NOT_FOUND) {
+	if (phy_blk == BLK_NOT_FOUND)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	page_addr = phy_blk << xd_card->block_shift;
 
@@ -1282,9 +1225,8 @@ static int xd_erase_block(struct rtsx_chip *chip, u32 phy_blk)
 				xd_set_err_code(chip, XD_ERASE_FAIL);
 			}
 			retval = xd_reset_cmd(chip);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 			continue;
 		}
 
@@ -1317,9 +1259,8 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 
 	if (xd_card->zone == NULL) {
 		retval = xd_init_l2p_tbl(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			return retval;
-		}
 	}
 
 	if (xd_card->zone[zone_no].build_flag) {
@@ -1331,26 +1272,23 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 
 	if (zone->l2p_table == NULL) {
 		zone->l2p_table = (u16 *)vmalloc(2000);
-		if (zone->l2p_table == NULL) {
+		if (zone->l2p_table == NULL)
 			TRACE_GOTO(chip, Build_Fail);
-		}
 	}
 	memset((u8 *)(zone->l2p_table), 0xff, 2000);
 
 	if (zone->free_table == NULL) {
 		zone->free_table = (u16 *)vmalloc(XD_FREE_TABLE_CNT * 2);
-		if (zone->free_table == NULL) {
+		if (zone->free_table == NULL)
 			TRACE_GOTO(chip, Build_Fail);
-		}
 	}
 	memset((u8 *)(zone->free_table), 0xff, XD_FREE_TABLE_CNT * 2);
 
 	if (zone_no == 0) {
-		if (xd_card->cis_block == 0xFFFF) {
+		if (xd_card->cis_block == 0xFFFF)
 			start = 0;
-		} else {
+		else
 			start = xd_card->cis_block + 1;
-		}
 		if (XD_CHK_4MB(xd_card)) {
 			end = 0x200;
 			max_logoff = 499;
@@ -1374,9 +1312,8 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 		u32 phy_block;
 
 		retval = xd_read_redundant(chip, page_addr, redunt, 11);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			continue;
-		}
 
 		if (redunt[BLOCK_STATUS] != 0xFF) {
 			RTSX_DEBUGP("bad block\n");
@@ -1392,15 +1329,13 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 		cur_fst_page_logoff = xd_load_log_block_addr(redunt);
 		if ((cur_fst_page_logoff == 0xFFFF) || (cur_fst_page_logoff > max_logoff)) {
 			retval = xd_erase_block(chip, i);
-			if (retval == STATUS_SUCCESS) {
+			if (retval == STATUS_SUCCESS)
 				xd_set_unused_block(chip, i);
-			}
 			continue;
 		}
 
-		if ((zone_no == 0) && (cur_fst_page_logoff == 0) && (redunt[PAGE_STATUS] != XD_GPG)) {
+		if ((zone_no == 0) && (cur_fst_page_logoff == 0) && (redunt[PAGE_STATUS] != XD_GPG))
 			XD_SET_MBR_FAIL(xd_card);
-		}
 
 		if (zone->l2p_table[cur_fst_page_logoff] == 0xFFFF) {
 			zone->l2p_table[cur_fst_page_logoff] = (u16)(i & 0x3FF);
@@ -1412,9 +1347,8 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 		page_addr = ((i + 1) << xd_card->block_shift) - 1;
 
 		retval = xd_read_redundant(chip, page_addr, redunt, 11);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			continue;
-		}
 
 		cur_lst_page_logoff = xd_load_log_block_addr(redunt);
 		if (cur_lst_page_logoff == cur_fst_page_logoff) {
@@ -1431,9 +1365,8 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 			if (m == 3) {
 				zone->l2p_table[cur_fst_page_logoff] = (u16)(i & 0x3FF);
 				retval = xd_erase_block(chip, phy_block);
-				if (retval == STATUS_SUCCESS) {
+				if (retval == STATUS_SUCCESS)
 					xd_set_unused_block(chip, phy_block);
-				}
 				continue;
 			}
 
@@ -1441,43 +1374,37 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 			if (ent_lst_page_logoff != cur_fst_page_logoff) {
 				zone->l2p_table[cur_fst_page_logoff] = (u16)(i & 0x3FF);
 				retval = xd_erase_block(chip, phy_block);
-				if (retval == STATUS_SUCCESS) {
+				if (retval == STATUS_SUCCESS)
 					xd_set_unused_block(chip, phy_block);
-				}
 				continue;
 			} else {
 				retval = xd_erase_block(chip, i);
-				if (retval == STATUS_SUCCESS) {
+				if (retval == STATUS_SUCCESS)
 					xd_set_unused_block(chip, i);
-				}
 			}
 		} else {
 			retval = xd_erase_block(chip, i);
-			if (retval == STATUS_SUCCESS) {
+			if (retval == STATUS_SUCCESS)
 				xd_set_unused_block(chip, i);
-			}
 		}
 	}
 
-	if (XD_CHK_4MB(xd_card)) {
+	if (XD_CHK_4MB(xd_card))
 		end = 500;
-	} else {
+	else
 		end = 1000;
-	}
 
 	i = 0;
 	for (start = 0; start < end; start++) {
-		if (zone->l2p_table[start] == 0xFFFF) {
+		if (zone->l2p_table[start] == 0xFFFF)
 			i++;
-		}
 	}
 
 	RTSX_DEBUGP("Block count %d, invalid L2P entry %d\n", end, i);
 	RTSX_DEBUGP("Total unused block: %d\n", zone->unused_blk_cnt);
 
-	if ((zone->unused_blk_cnt - i) < 1) {
+	if ((zone->unused_blk_cnt - i) < 1)
 		chip->card_wp |= XD_CARD;
-	}
 
 	zone->build_flag = 1;
 
@@ -1507,9 +1434,8 @@ static int xd_send_cmd(struct rtsx_chip *chip, u8 cmd)
 	rtsx_add_cmd(chip, CHECK_REG_CMD, XD_TRANSFER, XD_TRANSFER_END, XD_TRANSFER_END);
 
 	retval = rtsx_send_cmd(chip, XD_CARD, 200);
-	if (retval < 0) {
+	if (retval < 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -1523,9 +1449,8 @@ static int xd_read_multiple_pages(struct rtsx_chip *chip, u32 phy_blk, u32 log_b
 	u8 reg_val, page_cnt;
 	int zone_no, retval, i;
 
-	if (start_page > end_page) {
+	if (start_page > end_page)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	page_cnt = end_page - start_page;
 	zone_no = (int)(log_blk / 1000);
@@ -1584,9 +1509,8 @@ static int xd_read_multiple_pages(struct rtsx_chip *chip, u32 phy_blk, u32 log_b
 Fail:
 	RTSX_READ_REG(chip, XD_PAGE_STATUS, &reg_val);
 
-	if (reg_val !=  XD_GPG) {
+	if (reg_val !=  XD_GPG)
 		xd_set_err_code(chip, XD_PRG_ERROR);
-	}
 
 	RTSX_READ_REG(chip, XD_CTL, &reg_val);
 
@@ -1613,9 +1537,8 @@ Fail:
 		if (retval != STATUS_SUCCESS) {
 			if (!XD_CHK_BAD_NEWBLK(xd_card)) {
 				retval = xd_erase_block(chip, new_blk);
-				if (retval == STATUS_SUCCESS) {
+				if (retval == STATUS_SUCCESS)
 					xd_set_unused_block(chip, new_blk);
-				}
 			} else {
 				XD_CLR_BAD_NEWBLK(xd_card);
 			}
@@ -1641,9 +1564,8 @@ static int xd_finish_write(struct rtsx_chip *chip,
 	RTSX_DEBUGP("xd_finish_write, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x\n",
 				old_blk, new_blk, log_blk);
 
-	if (page_off > xd_card->page_off) {
+	if (page_off > xd_card->page_off)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	zone_no = (int)(log_blk / 1000);
 	log_off = (u16)(log_blk % 1000);
@@ -1653,9 +1575,8 @@ static int xd_finish_write(struct rtsx_chip *chip,
 				page_off, xd_card->page_off + 1);
 		if (retval != STATUS_SUCCESS) {
 			retval = xd_erase_block(chip, new_blk);
-			if (retval == STATUS_SUCCESS) {
+			if (retval == STATUS_SUCCESS)
 				xd_set_unused_block(chip, new_blk);
-			}
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 	} else {
@@ -1664,9 +1585,8 @@ static int xd_finish_write(struct rtsx_chip *chip,
 		if (retval != STATUS_SUCCESS) {
 			if (!XD_CHK_BAD_NEWBLK(xd_card)) {
 				retval = xd_erase_block(chip, new_blk);
-				if (retval == STATUS_SUCCESS) {
+				if (retval == STATUS_SUCCESS)
 					xd_set_unused_block(chip, new_blk);
-				}
 			}
 			XD_CLR_BAD_NEWBLK(xd_card);
 			TRACE_RET(chip, STATUS_FAIL);
@@ -1701,9 +1621,8 @@ static int xd_prepare_write(struct rtsx_chip *chip,
 
 	if (page_off) {
 		retval = xd_copy_page(chip, old_blk, new_blk, 0, page_off);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -1722,9 +1641,8 @@ static int xd_write_multiple_pages(struct rtsx_chip *chip, u32 old_blk, u32 new_
 	RTSX_DEBUGP("%s, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x\n",
 				__func__, old_blk, new_blk, log_blk);
 
-	if (start_page > end_page) {
+	if (start_page > end_page)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	page_cnt = end_page - start_page;
 	zone_no = (int)(log_blk / 1000);
@@ -1733,9 +1651,8 @@ static int xd_write_multiple_pages(struct rtsx_chip *chip, u32 old_blk, u32 new_
 	page_addr = (new_blk << xd_card->block_shift) + start_page;
 
 	retval = xd_send_cmd(chip, READ1_1);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -1812,17 +1729,15 @@ int xd_delay_write(struct rtsx_chip *chip)
 	if (delay_write->delay_write_flag) {
 		RTSX_DEBUGP("xd_delay_write\n");
 		retval = xd_switch_clock(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		delay_write->delay_write_flag = 0;
 		retval = xd_finish_write(chip,
 				delay_write->old_phyblock, delay_write->new_phyblock,
 				delay_write->logblock, delay_write->pageoff);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
@@ -1852,9 +1767,9 @@ int xd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 	ptr = (u8 *)scsi_sglist(srb);
 
 	retval = xd_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 
 	if (detect_card_cd(chip, XD_CARD) != STATUS_SUCCESS) {
 		chip->card_fail |= XD_CARD;
@@ -1955,11 +1870,11 @@ int xd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
-		if ((start_page + total_sec_cnt) > (xd_card->page_off + 1)) {
+		if ((start_page + total_sec_cnt) > (xd_card->page_off + 1))
 			end_page = xd_card->page_off + 1;
-		} else {
+		else
 			end_page = start_page + (u8)total_sec_cnt;
-		}
+
 		page_cnt = end_page - start_page;
 		if (srb->sc_data_direction == DMA_FROM_DEVICE) {
 			retval = xd_read_multiple_pages(chip, old_blk, log_blk,
@@ -1999,11 +1914,11 @@ int xd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 
 		old_blk = xd_get_l2p_tbl(chip, zone_no, log_off);
 		if (old_blk == BLK_NOT_FOUND) {
-			if (srb->sc_data_direction == DMA_FROM_DEVICE) {
+			if (srb->sc_data_direction == DMA_FROM_DEVICE)
 				set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
-			} else {
+			else
 				set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
-			}
+			
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
@@ -2089,26 +2004,23 @@ int xd_power_off_card3v3(struct rtsx_chip *chip)
 	int retval;
 
 	retval = disable_card_clock(chip, XD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, CARD_OE, XD_OUTPUT_EN, 0);
 
 	if (!chip->ft2_fast_mode) {
 		retval = card_power_off(chip, XD_CARD);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		wait_timeout(50);
 	}
 
 	if (chip->asic_code) {
 		retval = xd_pull_ctl_disable(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		RTSX_WRITE_REG(chip, FPGA_PULL_CTL, 0xFF, 0xDF);
 	}
@@ -2132,9 +2044,8 @@ int release_xd_card(struct rtsx_chip *chip)
 	xd_free_l2p_tbl(chip);
 
 	retval = xd_power_off_card3v3(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.4

