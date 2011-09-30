Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab1I3NTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53153 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab1I3NTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:35 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 7/9] Staging: comedi: fix line over 80 character issue in cb_pcidda.c
Date: Fri, 30 Sep 2011 18:48:25 +0530
Message-Id: <1317388707-1980-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidda.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   92 +++++++++++++++++++---------
 1 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 3dddffe..d83ac1f 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -50,10 +50,12 @@ Please report success/failure with other different cards to
 
 #include "comedi_pci.h"
 #include "8255.h"
-
-#define PCI_VENDOR_ID_CB	0x1307	/*  PCI vendor number of ComputerBoards */
-#define EEPROM_SIZE	128	/*  number of entries in eeprom */
-#define MAX_AO_CHANNELS 8	/*  maximum number of ao channels for supported boards */
+/* PCI vendor number of ComputerBoards */
+#define PCI_VENDOR_ID_CB        0x1307
+/* number of entries in eeprom */
+#define EEPROM_SIZE     128
+/* maximum number of ao channels for supported boards */
+#define MAX_AO_CHANNELS 8
 
 /* PCI-DDA base addresses */
 #define DIGITALIO_BADRINDEX	2
@@ -94,20 +96,31 @@ Please report success/failure with other different cards to
 
 #define DACALIBRATION1	4	/*  D/A CALIBRATION REGISTER 1 */
 /* write bits */
-#define	SERIAL_IN_BIT	0x1	/*  serial data input for eeprom, caldacs, reference dac */
+#define	SERIAL_IN_BIT	0x1	/*
+				 * serial data input for eeprom,
+				 * caldacs, reference dac
+				 */
 #define	CAL_CHANNEL_MASK	(0x7 << 1)
 #define	CAL_CHANNEL_BITS(channel)	(((channel) << 1) & CAL_CHANNEL_MASK)
 /* read bits */
 #define	CAL_COUNTER_MASK	0x1f
-#define	CAL_COUNTER_OVERFLOW_BIT	0x20	/*  calibration counter overflow status bit */
-#define	AO_BELOW_REF_BIT	0x40	/*  analog output is less than reference dac voltage */
-#define	SERIAL_OUT_BIT	0x80	/*  serial data out, for reading from eeprom */
-
-#define DACALIBRATION2	6	/*  D/A CALIBRATION REGISTER 2 */
-#define	SELECT_EEPROM_BIT	0x1	/*  send serial data in to eeprom */
-#define	DESELECT_REF_DAC_BIT	0x2	/*  don't send serial data to MAX542 reference dac */
-#define	DESELECT_CALDAC_BIT(n)	(0x4 << (n))	/*  don't send serial data to caldac n */
-#define	DUMMY_BIT	0x40	/*  manual says to set this bit with no explanation */
+/* calibration counter overflow status bit */
+#define CAL_COUNTER_OVERFLOW_BIT        0x20
+/* analog output is less than reference dac voltage */
+#define AO_BELOW_REF_BIT        0x40
+/* serial data out, for reading from eeprom */
+#define SERIAL_OUT_BIT  0x80
+
+/* D/A CALIBRATION REGISTER 2 */
+#define DACALIBRATION2  6
+/* send serial data in to eeprom */
+#define SELECT_EEPROM_BIT       0x1
+/* don't send serial data to MAX542 reference dac */
+#define DESELECT_REF_DAC_BIT    0x2
+/* don't send serial data to caldac n */
+#define DESELECT_CALDAC_BIT(n)  (0x4 << (n))
+/* manual says to set this bit with no explanation */
+#define DUMMY_BIT       0x40
 
 #define DADATA	8		/*  FIRST D/A DATA REGISTER (0) */
 
@@ -212,9 +225,12 @@ MODULE_DEVICE_TABLE(pci, cb_pcidda_pci_table);
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
 
@@ -227,9 +243,12 @@ struct cb_pcidda_private {
 	/* unsigned long control_status; */
 	/* unsigned long adc_fifo; */
 
-	unsigned int dac_cal1_bits;	/*  bits last written to da calibration register 1 */
-	unsigned int ao_range[MAX_AO_CHANNELS];	/*  current range settings for output channels */
-	u16 eeprom_data[EEPROM_SIZE];	/*  software copy of board's eeprom */
+	/* bits last written to da calibration register 1 */
+	unsigned int dac_cal1_bits;
+	/* current range settings for output channels */
+	unsigned int ao_range[MAX_AO_CHANNELS];
+	/* software copy of board's eeprom */
+	u16 eeprom_data[EEPROM_SIZE];
 };
 
 /*
@@ -488,7 +507,9 @@ static int cb_pcidda_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually compatible
+	 */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER
@@ -700,8 +721,10 @@ static unsigned int cb_pcidda_read_eeprom(struct comedi_device *dev,
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
 
@@ -733,9 +756,12 @@ static void cb_pcidda_write_caldac(struct comedi_device *dev,
 {
 	unsigned int cal2_bits;
 	unsigned int i;
-	const int num_channel_bits = 3;	/*  caldacs use 3 bit channel specification */
-	const int num_caldac_bits = 8;	/*  8 bit calibration dacs */
-	const int max_num_caldacs = 4;	/*  one caldac for every two dac channels */
+	/* caldacs use 3 bit channel specification */
+	const int num_channel_bits = 3;
+	/* 8 bit calibration dacs */
+	const int num_caldac_bits = 8;
+	/* one caldac for every two dac channels */
+	const int max_num_caldacs = 4;
 
 	/* write 3 bit channel */
 	cb_pcidda_serial_out(dev, channel, num_channel_bits);
@@ -794,14 +820,19 @@ static unsigned int offset_eeprom_address(unsigned int ao_channel,
 	return 0x7 + 2 * range + 12 * ao_channel;
 }
 
-/* returns eeprom address that provides gain calibration for given ao channel and range */
+/*
+ * returns eeprom address that provides gain calibration for
+ * given ao channel and range
+ */
 static unsigned int gain_eeprom_address(unsigned int ao_channel,
 					unsigned int range)
 {
 	return 0x8 + 2 * range + 12 * ao_channel;
 }
 
-/* returns upper byte of eeprom entry, which gives the coarse adjustment values */
+/* returns upper byte of eeprom entry, which gives
+ * the coarse adjustment values
+ */
 static unsigned int eeprom_coarse_byte(unsigned int word)
 {
 	return (word >> 8) & 0xff;
@@ -819,7 +850,10 @@ static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 {
 	unsigned int coarse_offset, fine_offset, coarse_gain, fine_gain;
 
-	/*  remember range so we can tell when we need to readjust calibration */
+	/*
+	 * remember range so we can tell when we need to
+	 * readjust calibration
+	 */
 	devpriv->ao_range[channel] = range;
 
 	/*  get values from eeprom data */
-- 
1.7.6.2

