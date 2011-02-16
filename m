Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab1BPBpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:45:00 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41769 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab1BPBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:44:49 -0500
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging: rts_pstor: fix sparse warning
Date: Wed, 16 Feb 2011 09:43:38 +0800
X-BOX-Message-Id: p1G1iZBi029073
Message-ID: <1297820618-11962-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Add static modifier before some function definitions; delete function
named rtsx_transfer_sglist which won't be called.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/ms.c             |    2 +-
 drivers/staging/rts_pstor/rtsx.c           |    4 +-
 drivers/staging/rts_pstor/rtsx_card.c      |    2 +-
 drivers/staging/rts_pstor/rtsx_chip.c      |    8 +-
 drivers/staging/rts_pstor/rtsx_scsi.c      |    8 +-
 drivers/staging/rts_pstor/rtsx_transport.c |  142 +---------------------------
 drivers/staging/rts_pstor/sd.c             |   48 +++++-----
 drivers/staging/rts_pstor/spi.c            |    2 +-
 8 files changed, 40 insertions(+), 176 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 28d17c7..c88ce64 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -3594,7 +3594,7 @@ void ms_free_l2p_tbl(struct rtsx_chip *chip)
 #ifdef SUPPORT_MAGIC_GATE
 
 #ifdef READ_BYTES_WAIT_INT
-int ms_poll_int(struct rtsx_chip *chip)
+static int ms_poll_int(struct rtsx_chip *chip)
 {
 	int retval;
 	u8 val;
diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 9864b1a..3a728c8 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -257,7 +257,7 @@ static int bus_reset(struct scsi_cmnd *srb)
  * this defines our host template, with which we'll allocate hosts
  */
 
-struct scsi_host_template rtsx_host_template = {
+static struct scsi_host_template rtsx_host_template = {
 	/* basic userland interface stuff */
 	.name =				CR_DRIVER_NAME,
 	.proc_name =			CR_DRIVER_NAME,
@@ -436,7 +436,7 @@ static int rtsx_resume(struct pci_dev *pci)
 }
 #endif /* CONFIG_PM */
 
-void rtsx_shutdown(struct pci_dev *pci)
+static void rtsx_shutdown(struct pci_dev *pci)
 {
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
diff --git a/drivers/staging/rts_pstor/rtsx_card.c b/drivers/staging/rts_pstor/rtsx_card.c
index fe4cce0..4f971f2 100644
--- a/drivers/staging/rts_pstor/rtsx_card.c
+++ b/drivers/staging/rts_pstor/rtsx_card.c
@@ -300,7 +300,7 @@ void do_reset_ms_card(struct rtsx_chip *chip)
 	}
 }
 
-void release_sdio(struct rtsx_chip *chip)
+static void release_sdio(struct rtsx_chip *chip)
 {
 	if (chip->sd_io) {
 		rtsx_write_register(chip, CARD_STOP, SD_STOP | SD_CLR_ERR,
diff --git a/drivers/staging/rts_pstor/rtsx_chip.c b/drivers/staging/rts_pstor/rtsx_chip.c
index a4d8eb2..f443d97 100644
--- a/drivers/staging/rts_pstor/rtsx_chip.c
+++ b/drivers/staging/rts_pstor/rtsx_chip.c
@@ -657,7 +657,7 @@ static inline int check_sd_current_prior(u32 sd_current_prior)
 	return !fake_para;
 }
 
-int rts5209_init(struct rtsx_chip *chip)
+static int rts5209_init(struct rtsx_chip *chip)
 {
 	int retval;
 	u32 lval = 0;
@@ -805,7 +805,7 @@ int rts5209_init(struct rtsx_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int rts5208_init(struct rtsx_chip *chip)
+static int rts5208_init(struct rtsx_chip *chip)
 {
 	int retval;
 	u16 reg = 0;
@@ -871,7 +871,7 @@ int rts5208_init(struct rtsx_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int rts5288_init(struct rtsx_chip *chip)
+static int rts5288_init(struct rtsx_chip *chip)
 {
 	int retval;
 	u8 val = 0, max_func;
@@ -1097,7 +1097,7 @@ static inline void rtsx_blink_led(struct rtsx_chip *chip)
 }
 #endif
 
-void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
+static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 {
 	int maybe_support_aspm, reg_changed;
 	u32 tmp = 0;
diff --git a/drivers/staging/rts_pstor/rtsx_scsi.c b/drivers/staging/rts_pstor/rtsx_scsi.c
index ce9fc16..20c2464 100644
--- a/drivers/staging/rts_pstor/rtsx_scsi.c
+++ b/drivers/staging/rts_pstor/rtsx_scsi.c
@@ -274,7 +274,7 @@ static int test_unit_ready(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	return TRANSPORT_GOOD;
 }
 
-unsigned char formatter_inquiry_str[20] = {
+static unsigned char formatter_inquiry_str[20] = {
 	'M', 'E', 'M', 'O', 'R', 'Y', 'S', 'T', 'I', 'C', 'K',
 #ifdef SUPPORT_MAGIC_GATE
 	'-', 'M', 'G', /* Byte[47:49] */
@@ -2690,7 +2690,7 @@ static int ms_format_cmnd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 }
 
 #ifdef SUPPORT_PCGL_1P18
-int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
+static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	unsigned int lun = SCSI_LUN(srb);
@@ -2864,7 +2864,7 @@ static int sd_extention_cmnd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 #endif
 
 #ifdef SUPPORT_MAGIC_GATE
-int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
+static int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	unsigned int lun = SCSI_LUN(srb);
@@ -2962,7 +2962,7 @@ int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	return TRANSPORT_GOOD;
 }
 
-int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
+static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	unsigned int lun = SCSI_LUN(srb);
diff --git a/drivers/staging/rts_pstor/rtsx_transport.c b/drivers/staging/rts_pstor/rtsx_transport.c
index e581f15..4e3d2c1 100644
--- a/drivers/staging/rts_pstor/rtsx_transport.c
+++ b/drivers/staging/rts_pstor/rtsx_transport.c
@@ -324,7 +324,7 @@ static inline void rtsx_add_sg_tbl(
 	} while (len);
 }
 
-int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
+static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 		struct scatterlist *sg, int num_sg, unsigned int *index,
 		unsigned int *offset, int size,
 		enum dma_data_direction dma_dir, int timeout)
@@ -485,7 +485,7 @@ out:
 	return err;
 }
 
-int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
+static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 		struct scatterlist *sg, int num_sg,
 		enum dma_data_direction dma_dir, int timeout)
 {
@@ -632,7 +632,7 @@ out:
 	return err;
 }
 
-int rtsx_transfer_buf(struct rtsx_chip *chip, u8 card, void *buf, size_t len,
+static int rtsx_transfer_buf(struct rtsx_chip *chip, u8 card, void *buf, size_t len,
 		enum dma_data_direction dma_dir, int timeout)
 {
 	struct rtsx_dev *rtsx = chip->rtsx;
@@ -715,142 +715,6 @@ out:
 	return err;
 }
 
-int rtsx_transfer_sglist(struct rtsx_chip *chip, u8 card,
-		struct scatterlist *sg, int num_sg,
-		enum dma_data_direction dma_dir, int timeout)
-{
-	struct rtsx_dev *rtsx = chip->rtsx;
-	struct completion trans_done;
-	u8 dir;
-	int buf_cnt, i;
-	int err = 0;
-	long timeleft;
-
-	if ((sg == NULL) || (num_sg <= 0))
-		return -EIO;
-
-	if (dma_dir == DMA_TO_DEVICE) {
-		dir = HOST_TO_DEVICE;
-	} else if (dma_dir == DMA_FROM_DEVICE) {
-		dir = DEVICE_TO_HOST;
-	} else {
-		return -ENXIO;
-	}
-
-	if (card == SD_CARD) {
-		rtsx->check_card_cd = SD_EXIST;
-	} else if (card == MS_CARD) {
-		rtsx->check_card_cd = MS_EXIST;
-	} else if (card == XD_CARD) {
-		rtsx->check_card_cd = XD_EXIST;
-	} else {
-		rtsx->check_card_cd = 0;
-	}
-
-	spin_lock_irq(&rtsx->reg_lock);
-
-	/* set up data structures for the wakeup system */
-	rtsx->done = &trans_done;
-
-	rtsx->trans_state = STATE_TRANS_SG;
-	rtsx->trans_result = TRANS_NOT_READY;
-
-	spin_unlock_irq(&rtsx->reg_lock);
-
-	buf_cnt = dma_map_sg(&(rtsx->pci->dev), sg, num_sg, dma_dir);
-
-	for (i = 0; i < buf_cnt; i++) {
-		u32 bier = 0;
-		u32 val = (1 << 31);
-		dma_addr_t addr = sg_dma_address(sg + i);
-		unsigned int len = sg_dma_len(sg + i);
-
-		RTSX_DEBUGP("dma_addr = 0x%x, dma_len = %d\n",
-			     (unsigned int)addr, len);
-
-		val |= (u32)(dir & 0x01) << 29;
-		val |= (u32)(len & 0x00FFFFFF);
-
-		spin_lock_irq(&rtsx->reg_lock);
-
-		init_completion(&trans_done);
-
-		if (i == (buf_cnt - 1)) {
-			/* If last transfer, disable data interrupt */
-			bier = rtsx_readl(chip, RTSX_BIER);
-			rtsx_writel(chip, RTSX_BIER, bier & 0xBFFFFFFF);
-		}
-
-		rtsx_writel(chip, RTSX_HDBAR, addr);
-		rtsx_writel(chip, RTSX_HDBCTLR, val);
-
-		spin_unlock_irq(&rtsx->reg_lock);
-
-		timeleft = wait_for_completion_interruptible_timeout(
-			&trans_done, timeout * HZ / 1000);
-		if (timeleft <= 0) {
-			RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-			RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
-			err = -ETIMEDOUT;
-			if (i == (buf_cnt - 1))
-				rtsx_writel(chip, RTSX_BIER, bier);
-			goto out;
-		}
-
-		spin_lock_irq(&rtsx->reg_lock);
-		if (rtsx->trans_result == TRANS_RESULT_FAIL) {
-			err = -EIO;
-			spin_unlock_irq(&rtsx->reg_lock);
-			if (i == (buf_cnt - 1))
-				rtsx_writel(chip, RTSX_BIER, bier);
-			goto out;
-		}
-		spin_unlock_irq(&rtsx->reg_lock);
-
-		if (i == (buf_cnt - 1)) {
-			/* If last transfer, enable data interrupt
-			 * after transfer finished
-			 */
-			rtsx_writel(chip, RTSX_BIER, bier);
-		}
-	}
-
-	/* Wait for TRANS_OK_INT */
-	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_NOT_READY) {
-		init_completion(&trans_done);
-		spin_unlock_irq(&rtsx->reg_lock);
-		timeleft = wait_for_completion_interruptible_timeout(
-			&trans_done, timeout * HZ / 1000);
-		if (timeleft <= 0) {
-			RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-			RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
-			err = -ETIMEDOUT;
-			goto out;
-		}
-	} else {
-		spin_unlock_irq(&rtsx->reg_lock);
-	}
-
-	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_RESULT_FAIL) {
-		err = -EIO;
-	} else if (rtsx->trans_result == TRANS_RESULT_OK) {
-		err = 0;
-	}
-	spin_unlock_irq(&rtsx->reg_lock);
-
-out:
-	rtsx->done = NULL;
-	rtsx->trans_state = STATE_TRANS_NONE;
-	dma_unmap_sg(&(rtsx->pci->dev), sg, num_sg, dma_dir);
-
-	if (err < 0)
-		rtsx_stop_cmd(chip, card);
-
-	return err;
-}
-
 int rtsx_transfer_data_partial(struct rtsx_chip *chip, u8 card,
 		void *buf, size_t len, int use_sg, unsigned int *index,
 		unsigned int *offset, enum dma_data_direction dma_dir,
diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 945c95f..80b61e6 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -32,30 +32,30 @@
 
 #define SD_MAX_RETRY_COUNT	3
 
-u16 REG_SD_CFG1;
-u16 REG_SD_CFG2;
-u16 REG_SD_CFG3;
-u16 REG_SD_STAT1;
-u16 REG_SD_STAT2;
-u16 REG_SD_BUS_STAT;
-u16 REG_SD_PAD_CTL;
-u16 REG_SD_SAMPLE_POINT_CTL;
-u16 REG_SD_PUSH_POINT_CTL;
-u16 REG_SD_CMD0;
-u16 REG_SD_CMD1;
-u16 REG_SD_CMD2;
-u16 REG_SD_CMD3;
-u16 REG_SD_CMD4;
-u16 REG_SD_CMD5;
-u16 REG_SD_BYTE_CNT_L;
-u16 REG_SD_BYTE_CNT_H;
-u16 REG_SD_BLOCK_CNT_L;
-u16 REG_SD_BLOCK_CNT_H;
-u16 REG_SD_TRANSFER;
-u16 REG_SD_VPCLK0_CTL;
-u16 REG_SD_VPCLK1_CTL;
-u16 REG_SD_DCMPS0_CTL;
-u16 REG_SD_DCMPS1_CTL;
+static u16 REG_SD_CFG1;
+static u16 REG_SD_CFG2;
+static u16 REG_SD_CFG3;
+static u16 REG_SD_STAT1;
+static u16 REG_SD_STAT2;
+static u16 REG_SD_BUS_STAT;
+static u16 REG_SD_PAD_CTL;
+static u16 REG_SD_SAMPLE_POINT_CTL;
+static u16 REG_SD_PUSH_POINT_CTL;
+static u16 REG_SD_CMD0;
+static u16 REG_SD_CMD1;
+static u16 REG_SD_CMD2;
+static u16 REG_SD_CMD3;
+static u16 REG_SD_CMD4;
+static u16 REG_SD_CMD5;
+static u16 REG_SD_BYTE_CNT_L;
+static u16 REG_SD_BYTE_CNT_H;
+static u16 REG_SD_BLOCK_CNT_L;
+static u16 REG_SD_BLOCK_CNT_H;
+static u16 REG_SD_TRANSFER;
+static u16 REG_SD_VPCLK0_CTL;
+static u16 REG_SD_VPCLK1_CTL;
+static u16 REG_SD_DCMPS0_CTL;
+static u16 REG_SD_DCMPS1_CTL;
 
 static inline void sd_set_err_code(struct rtsx_chip *chip, u8 err_code)
 {
diff --git a/drivers/staging/rts_pstor/spi.c b/drivers/staging/rts_pstor/spi.c
index 84e0af4..9081836 100644
--- a/drivers/staging/rts_pstor/spi.c
+++ b/drivers/staging/rts_pstor/spi.c
@@ -227,7 +227,7 @@ static int spi_init_eeprom(struct rtsx_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int spi_eeprom_program_enable(struct rtsx_chip *chip)
+static int spi_eeprom_program_enable(struct rtsx_chip *chip)
 {
 	int retval;
 
-- 
1.7.4

