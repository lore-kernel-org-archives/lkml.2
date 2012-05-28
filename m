Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2E1S3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:29:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40410 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2E1S3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:29:10 -0400
From: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
Subject: [PATCH] staging: comedi: cb_pcidas64: Fixed coding style errors and an if-statement
Date: Mon, 28 May 2012 21:28:35 +0300
Message-Id: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a few coding style errors and an if-statement responsible for a
sanity check inside the prep_ao_dma function.

Signed-off-by: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 9d0b875..06cff3d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1153,12 +1153,14 @@ static int eeprom_read_insn(struct comedi_device *dev,
 static void check_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd);
 static unsigned int get_divisor(unsigned int ns, unsigned int flags);
 static void i2c_write(struct comedi_device *dev, unsigned int address,
-		      const uint8_t * data, unsigned int length);
+		      const uint8_t *data, unsigned int length);
 static void caldac_write(struct comedi_device *dev, unsigned int channel,
 			 unsigned int value);
 static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
 			     uint8_t value);
-/* static int dac_1590_write(struct comedi_device *dev, unsigned int dac_a, unsigned int dac_b); */
+/* static int dac_1590_write(struct comedi_device *dev, unsigned int dac_a,
+ *			     unsigned int dac_b);
+ */
 static int caldac_i2c_write(struct comedi_device *dev,
 			    unsigned int caldac_channel, unsigned int value);
 static void abort_dma(struct comedi_device *dev, unsigned int channel);
@@ -1230,7 +1232,7 @@ static unsigned int hw_revision(const struct comedi_device *dev,
 }
 
 static void set_dac_range_bits(struct comedi_device *dev,
-			       volatile uint16_t * bits, unsigned int channel,
+			       volatile uint16_t *bits, unsigned int channel,
 			       unsigned int range)
 {
 	unsigned int code = board(dev)->ao_range_code[range];
@@ -3392,8 +3394,8 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
 	num_bytes = load_ao_dma_buffer(dev, cmd);
 	if (num_bytes == 0)
 		return -1;
-	if (num_bytes >= DMA_BUFFER_SIZE) ;
-	load_ao_dma(dev, cmd);
+	if (num_bytes >= DMA_BUFFER_SIZE)
+		load_ao_dma(dev, cmd);
 
 	dma_start_sync(dev, 0);
 
@@ -4191,7 +4193,7 @@ static void i2c_stop(struct comedi_device *dev)
 }
 
 static void i2c_write(struct comedi_device *dev, unsigned int address,
-		      const uint8_t * data, unsigned int length)
+		      const uint8_t *data, unsigned int length)
 {
 	unsigned int i;
 	uint8_t bitstream;
-- 
1.7.10.2

