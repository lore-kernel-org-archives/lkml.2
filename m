Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2F0BHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:07:00 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:3801 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab2F0BG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:06:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1340759218!5251043!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/36] staging: comedi: cb_pcidas: remove 'volatile' on private data variables
Date: Tue, 26 Jun 2012 18:06:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261806.52836.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As indicated by checkpatch.pl, "WARNING: Use of volatile is usually
wrong: ...". The variables in the private data that are marked
volatile don't need to be. Remove the volatile.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 95ce546..eba39b4 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -357,16 +357,16 @@ struct cb_pcidas_private {
 	/*  divisors of master clock for analog input pacing */
 	unsigned int divisor1;
 	unsigned int divisor2;
-	volatile unsigned int count;	/*  number of analog input samples remaining */
-	volatile unsigned int adc_fifo_bits;	/*  bits to write to interrupt/adcfifo register */
-	volatile unsigned int s5933_intcsr_bits;	/*  bits to write to amcc s5933 interrupt control/status register */
-	volatile unsigned int ao_control_bits;	/*  bits to write to ao control and status register */
+	unsigned int count;	/*  number of analog input samples remaining */
+	unsigned int adc_fifo_bits;	/*  bits to write to interrupt/adcfifo register */
+	unsigned int s5933_intcsr_bits;	/*  bits to write to amcc s5933 interrupt control/status register */
+	unsigned int ao_control_bits;	/*  bits to write to ao control and status register */
 	short ai_buffer[AI_BUFFER_SIZE];
 	short ao_buffer[AO_BUFFER_SIZE];
 	/*  divisors of master clock for analog output pacing */
 	unsigned int ao_divisor1;
 	unsigned int ao_divisor2;
-	volatile unsigned int ao_count;	/*  number of analog output samples remaining */
+	unsigned int ao_count;	/*  number of analog output samples remaining */
 	int ao_value[2];	/*  remember what the analog outputs are set to, to allow readback */
 	unsigned int caldac_value[NUM_CHANNELS_8800];	/*  for readback of caldac */
 	unsigned int trimpot_value[NUM_CHANNELS_8402];	/*  for readback of trimpot */
-- 
1.7.11

