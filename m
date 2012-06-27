Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2F0BHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:07:38 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:47918 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2F0BHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:07:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1340759255!7915698!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/36] staging: comedi: cb_pcidas: fix comments in private data struct
Date: Tue, 26 Jun 2012 18:07:32 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261807.32557.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of the comments in the private data struct definition
are causing checkpatch.pl to complain about "WARNING: line over
80 characters". Fix the comments.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 31 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index eba39b4..9e21e68 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -342,34 +342,35 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	},
 };
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
 struct cb_pcidas_private {
-	/* would be useful for a PCI device */
 	struct pci_dev *pci_dev;
-	/*  base addresses */
+	/* base addresses */
 	unsigned long s5933_config;
 	unsigned long control_status;
 	unsigned long adc_fifo;
 	unsigned long pacer_counter_dio;
 	unsigned long ao_registers;
-	/*  divisors of master clock for analog input pacing */
+	/* divisors of master clock for analog input pacing */
 	unsigned int divisor1;
 	unsigned int divisor2;
-	unsigned int count;	/*  number of analog input samples remaining */
-	unsigned int adc_fifo_bits;	/*  bits to write to interrupt/adcfifo register */
-	unsigned int s5933_intcsr_bits;	/*  bits to write to amcc s5933 interrupt control/status register */
-	unsigned int ao_control_bits;	/*  bits to write to ao control and status register */
+	/* number of analog input samples remaining */
+	unsigned int count;
+	/* bits to write to registers */
+	unsigned int adc_fifo_bits;
+	unsigned int s5933_intcsr_bits;
+	unsigned int ao_control_bits;
+	/* fifo buffers */
 	short ai_buffer[AI_BUFFER_SIZE];
 	short ao_buffer[AO_BUFFER_SIZE];
-	/*  divisors of master clock for analog output pacing */
+	/* divisors of master clock for analog output pacing */
 	unsigned int ao_divisor1;
 	unsigned int ao_divisor2;
-	unsigned int ao_count;	/*  number of analog output samples remaining */
-	int ao_value[2];	/*  remember what the analog outputs are set to, to allow readback */
-	unsigned int caldac_value[NUM_CHANNELS_8800];	/*  for readback of caldac */
-	unsigned int trimpot_value[NUM_CHANNELS_8402];	/*  for readback of trimpot */
+	/* number of analog output samples remaining */
+	unsigned int ao_count;
+	/* cached values for readback */
+	int ao_value[2];
+	unsigned int caldac_value[NUM_CHANNELS_8800];
+	unsigned int trimpot_value[NUM_CHANNELS_8402];
 	unsigned int dac08_value;
 	unsigned int calibration_source;
 };
-- 
1.7.11

