Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2DZKCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:02:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61410 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2DZKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:02:46 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/4] Staging: comedi: fix line over 80 character issue in cb_pcidda.c
Date: Thu, 26 Apr 2012 15:32:17 +0530
Message-Id: <1335434540-13286-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidda.c file that fixes up a line over 80
character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   72 +++++++++++++++++++--------
 1 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index abba220..b0561c7 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -51,9 +51,12 @@ Please report success/failure with other different cards to
 #include "comedi_pci.h"
 #include "8255.h"
 
-#define PCI_VENDOR_ID_CB	0x1307	/*  PCI vendor number of ComputerBoards */
+
+/* PCI vendor number of ComputerBoards */
+#define PCI_VENDOR_ID_CB        0x1307
 #define EEPROM_SIZE	128	/*  number of entries in eeprom */
-#define MAX_AO_CHANNELS 8	/*  maximum number of ao channels for supported boards */
+/* maximum number of ao channels for supported boards */
+#define MAX_AO_CHANNELS 8
 
 /* PCI-DDA base addresses */
 #define DIGITALIO_BADRINDEX	2
@@ -94,20 +97,26 @@ Please report success/failure with other different cards to
 
 #define DACALIBRATION1	4	/*  D/A CALIBRATION REGISTER 1 */
 /* write bits */
-#define	SERIAL_IN_BIT	0x1	/*  serial data input for eeprom, caldacs, reference dac */
+/* serial data input for eeprom, caldacs, reference dac */
+#define SERIAL_IN_BIT   0x1
 #define	CAL_CHANNEL_MASK	(0x7 << 1)
 #define	CAL_CHANNEL_BITS(channel)	(((channel) << 1) & CAL_CHANNEL_MASK)
 /* read bits */
 #define	CAL_COUNTER_MASK	0x1f
-#define	CAL_COUNTER_OVERFLOW_BIT	0x20	/*  calibration counter overflow status bit */
-#define	AO_BELOW_REF_BIT	0x40	/*  analog output is less than reference dac voltage */
+/* calibration counter overflow status bit */
+#define CAL_COUNTER_OVERFLOW_BIT        0x20
+/* analog output is less than reference dac voltage */
+#define AO_BELOW_REF_BIT        0x40
 #define	SERIAL_OUT_BIT	0x80	/*  serial data out, for reading from eeprom */
 
 #define DACALIBRATION2	6	/*  D/A CALIBRATION REGISTER 2 */
 #define	SELECT_EEPROM_BIT	0x1	/*  send serial data in to eeprom */
-#define	DESELECT_REF_DAC_BIT	0x2	/*  don't send serial data to MAX542 reference dac */
-#define	DESELECT_CALDAC_BIT(n)	(0x4 << (n))	/*  don't send serial data to caldac n */
-#define	DUMMY_BIT	0x40	/*  manual says to set this bit with no explanation */
+/* don't send serial data to MAX542 reference dac */
+#define DESELECT_REF_DAC_BIT    0x2
+/* don't send serial data to caldac n */
+#define DESELECT_CALDAC_BIT(n)  (0x4 << (n))
+/* manual says to set this bit with no explanation */
+#define DUMMY_BIT       0x40
 
 #define DADATA	8		/*  FIRST D/A DATA REGISTER (0) */
 
@@ -212,9 +221,12 @@ MODULE_DEVICE_TABLE(pci, cb_pcidda_pci_table);
  */
 #define thisboard ((const struct cb_pcidda_board *)dev->board_ptr)
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * this structure is for data unique to this hardware driver.  If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct cb_pcidda_private {
 	int data;
 
@@ -227,8 +239,10 @@ struct cb_pcidda_private {
 	/* unsigned long control_status; */
 	/* unsigned long adc_fifo; */
 
-	unsigned int dac_cal1_bits;	/*  bits last written to da calibration register 1 */
-	unsigned int ao_range[MAX_AO_CHANNELS];	/*  current range settings for output channels */
+	/* bits last written to da calibration register 1 */
+	unsigned int dac_cal1_bits;
+	/* current range settings for output channels */
+	unsigned int ao_range[MAX_AO_CHANNELS];
 	u16 eeprom_data[EEPROM_SIZE];	/*  software copy of board's eeprom */
 };
 
@@ -377,7 +391,8 @@ found:
 	dev_dbg(dev->hw_dev, "eeprom:\n");
 	for (index = 0; index < EEPROM_SIZE; index++) {
 		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
-		dev_dbg(dev->hw_dev, "%i:0x%x\n", index, devpriv->eeprom_data[index]);
+		dev_dbg(dev->hw_dev, "%i:0x%x\n", index,
+			devpriv->eeprom_data[index]);
 	}
 
 	/*  set calibrations dacs */
@@ -484,7 +499,10 @@ static int cb_pcidda_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually
+	 * compatible
+	 */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER
@@ -696,8 +714,10 @@ static unsigned int cb_pcidda_read_eeprom(struct comedi_device *dev,
 	unsigned int i;
 	unsigned int cal2_bits;
 	unsigned int value;
-	const int max_num_caldacs = 4;	/*  one caldac for every two dac channels */
-	const int read_instruction = 0x6;	/*  bits to send to tell eeprom we want to read */
+	/* one caldac for every two dac channels */
+	const int max_num_caldacs = 4;
+	/* bits to send to tell eeprom we want to read */
+	const int read_instruction = 0x6;
 	const int instruction_length = 3;
 	const int address_length = 8;
 
@@ -729,9 +749,11 @@ static void cb_pcidda_write_caldac(struct comedi_device *dev,
 {
 	unsigned int cal2_bits;
 	unsigned int i;
-	const int num_channel_bits = 3;	/*  caldacs use 3 bit channel specification */
+	/* caldacs use 3 bit channel specification */
+	const int num_channel_bits = 3;
 	const int num_caldac_bits = 8;	/*  8 bit calibration dacs */
-	const int max_num_caldacs = 4;	/*  one caldac for every two dac channels */
+	/* one caldac for every two dac channels */
+	const int max_num_caldacs = 4;
 
 	/* write 3 bit channel */
 	cb_pcidda_serial_out(dev, channel, num_channel_bits);
@@ -790,14 +812,20 @@ static unsigned int offset_eeprom_address(unsigned int ao_channel,
 	return 0x7 + 2 * range + 12 * ao_channel;
 }
 
-/* returns eeprom address that provides gain calibration for given ao channel and range */
+/*
+ * returns eeprom address that provides gain calibration for given ao
+ * channel and range
+ */
 static unsigned int gain_eeprom_address(unsigned int ao_channel,
 					unsigned int range)
 {
 	return 0x8 + 2 * range + 12 * ao_channel;
 }
 
-/* returns upper byte of eeprom entry, which gives the coarse adjustment values */
+/*
+ * returns upper byte of eeprom entry, which gives the coarse adjustment
+ * values
+ */
 static unsigned int eeprom_coarse_byte(unsigned int word)
 {
 	return (word >> 8) & 0xff;
@@ -815,7 +843,7 @@ static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 {
 	unsigned int coarse_offset, fine_offset, coarse_gain, fine_gain;
 
-	/*  remember range so we can tell when we need to readjust calibration */
+	/* remember range so we can tell when we need to readjust calibration */
 	devpriv->ao_range[channel] = range;
 
 	/*  get values from eeprom data */
-- 
1.7.0.4

