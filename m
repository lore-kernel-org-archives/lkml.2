Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2F0BI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:08:26 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29691 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2F0BIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:08:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1340759302!7919103!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/36] staging: comedi: cb_pcidas: change dac bit enums into defines
Date: Tue, 26 Jun 2012 18:08:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261808.17473.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'bits' for the DAC_CSR register are currently defined as
enums. All the other registers use defines for the bit definitions.
Change the dac bit enums to defines to follow the other registers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9e21e68..0188cf1 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -140,11 +140,10 @@ analog triggering on 1602 series
 #define   CAL_EN_BIT	0x4000	/*  read calibration source instead of analog input channel 0 */
 #define   SERIAL_DATA_IN_BIT	0x8000	/*  serial data stream going to 8800 and 7376 */
 
-#define DAC_CSR	0x8		/*  dac control and status register */
-enum dac_csr_bits {
-	DACEN = 0x2,		/*  dac enable */
-	DAC_MODE_UPDATE_BOTH = 0x80,	/*  update both dacs when dac0 is written */
-};
+#define DAC_CSR			0x8	/* dac control and status register */
+#define   DACEN			0x02	/* dac enable */
+#define   DAC_MODE_UPDATE_BOTH	0x80	/* update both dacs */
+
 static inline unsigned int DAC_RANGE(unsigned int channel, unsigned int range)
 {
 	return (range & 0x3) << (8 + 2 * (channel & 0x1));
@@ -156,14 +155,13 @@ static inline unsigned int DAC_RANGE_MASK(unsigned int channel)
 };
 
 /* bits for 1602 series only */
-enum dac_csr_bits_1602 {
-	DAC_EMPTY = 0x1,	/*  dac fifo empty, read, write clear */
-	DAC_START = 0x4,	/*  start/arm dac fifo operations */
-	DAC_PACER_MASK = 0x18,	/*  bits that set dac pacer source */
-	DAC_PACER_INT = 0x8,	/*  dac internal pacing */
-	DAC_PACER_EXT_FALL = 0x10,	/*  dac external pacing, falling edge */
-	DAC_PACER_EXT_RISE = 0x18,	/*  dac external pacing, rising edge */
-};
+#define   DAC_EMPTY		0x1	/*  fifo empty, read, write clear */
+#define   DAC_START		0x4	/*  start/arm fifo operations */
+#define   DAC_PACER_MASK	0x18	/*  bits that set pacer source */
+#define   DAC_PACER_INT		0x8	/*  int. pacing */
+#define   DAC_PACER_EXT_FALL	0x10	/*  ext. pacing, falling edge */
+#define   DAC_PACER_EXT_RISE	0x18	/*  ext. pacing, rising edge */
+
 static inline unsigned int DAC_CHAN_EN(unsigned int channel)
 {
 	return 1 << (5 + (channel & 0x1));	/*  enable channel 0 or 1 */
-- 
1.7.11

