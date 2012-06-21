Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2FUC0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:26:40 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:54863 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab2FUC0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:26:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1340245597!6425846!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/12] staging: comedi: s626: remove forward declarations 6
Date: Wed, 20 Jun 2012 19:26:31 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201926.32270.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the enc_private_data definition down to remove the need
for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 222 ++++++++++++++--------------------
 1 file changed, 94 insertions(+), 128 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index cc18bf0..d7d72ac1 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -233,36 +233,8 @@ struct enc_private {
 static void s626_timer_load(struct comedi_device *dev, struct enc_private *k,
 			    int tick);
 static uint32_t ReadLatch(struct comedi_device *dev, struct enc_private *k);
-static void ResetCapFlags_A(struct comedi_device *dev, struct enc_private *k);
-static void ResetCapFlags_B(struct comedi_device *dev, struct enc_private *k);
-static uint16_t GetMode_A(struct comedi_device *dev, struct enc_private *k);
-static uint16_t GetMode_B(struct comedi_device *dev, struct enc_private *k);
-static void SetMode_A(struct comedi_device *dev, struct enc_private *k,
-		      uint16_t Setup, uint16_t DisableIntSrc);
-static void SetMode_B(struct comedi_device *dev, struct enc_private *k,
-		      uint16_t Setup, uint16_t DisableIntSrc);
-static void SetEnable_A(struct comedi_device *dev, struct enc_private *k,
-			uint16_t enab);
-static void SetEnable_B(struct comedi_device *dev, struct enc_private *k,
-			uint16_t enab);
-static uint16_t GetEnable_A(struct comedi_device *dev, struct enc_private *k);
-static uint16_t GetEnable_B(struct comedi_device *dev, struct enc_private *k);
 static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
 			   uint16_t value);
-static void SetLoadTrig_A(struct comedi_device *dev, struct enc_private *k,
-			  uint16_t Trig);
-static void SetLoadTrig_B(struct comedi_device *dev, struct enc_private *k,
-			  uint16_t Trig);
-static uint16_t GetLoadTrig_A(struct comedi_device *dev, struct enc_private *k);
-static uint16_t GetLoadTrig_B(struct comedi_device *dev, struct enc_private *k);
-static void SetIntSrc_B(struct comedi_device *dev, struct enc_private *k,
-			uint16_t IntSource);
-static void SetIntSrc_A(struct comedi_device *dev, struct enc_private *k,
-			uint16_t IntSource);
-static uint16_t GetIntSrc_A(struct comedi_device *dev, struct enc_private *k);
-static uint16_t GetIntSrc_B(struct comedi_device *dev, struct enc_private *k);
-static void PulseIndex_A(struct comedi_device *dev, struct enc_private *k);
-static void PulseIndex_B(struct comedi_device *dev, struct enc_private *k);
 static void Preload(struct comedi_device *dev, struct enc_private *k,
 		    uint32_t value);
 
@@ -276,106 +248,6 @@ static void Preload(struct comedi_device *dev, struct enc_private *k,
 /*  Translation table to map IntSrc into equivalent RDMISC2 event flag  bits. */
 /* static const uint16_t EventBits[][4] = { EVBITS(0), EVBITS(1), EVBITS(2), EVBITS(3), EVBITS(4), EVBITS(5) }; */
 
-/* struct enc_private; */
-static struct enc_private enc_private_data[] = {
-	{
-	 .GetEnable = GetEnable_A,
-	 .GetIntSrc = GetIntSrc_A,
-	 .GetLoadTrig = GetLoadTrig_A,
-	 .GetMode = GetMode_A,
-	 .PulseIndex = PulseIndex_A,
-	 .SetEnable = SetEnable_A,
-	 .SetIntSrc = SetIntSrc_A,
-	 .SetLoadTrig = SetLoadTrig_A,
-	 .SetMode = SetMode_A,
-	 .ResetCapFlags = ResetCapFlags_A,
-	 .MyCRA = LP_CR0A,
-	 .MyCRB = LP_CR0B,
-	 .MyLatchLsw = LP_CNTR0ALSW,
-	 .MyEventBits = EVBITS(0),
-	 },
-	{
-	 .GetEnable = GetEnable_A,
-	 .GetIntSrc = GetIntSrc_A,
-	 .GetLoadTrig = GetLoadTrig_A,
-	 .GetMode = GetMode_A,
-	 .PulseIndex = PulseIndex_A,
-	 .SetEnable = SetEnable_A,
-	 .SetIntSrc = SetIntSrc_A,
-	 .SetLoadTrig = SetLoadTrig_A,
-	 .SetMode = SetMode_A,
-	 .ResetCapFlags = ResetCapFlags_A,
-	 .MyCRA = LP_CR1A,
-	 .MyCRB = LP_CR1B,
-	 .MyLatchLsw = LP_CNTR1ALSW,
-	 .MyEventBits = EVBITS(1),
-	 },
-	{
-	 .GetEnable = GetEnable_A,
-	 .GetIntSrc = GetIntSrc_A,
-	 .GetLoadTrig = GetLoadTrig_A,
-	 .GetMode = GetMode_A,
-	 .PulseIndex = PulseIndex_A,
-	 .SetEnable = SetEnable_A,
-	 .SetIntSrc = SetIntSrc_A,
-	 .SetLoadTrig = SetLoadTrig_A,
-	 .SetMode = SetMode_A,
-	 .ResetCapFlags = ResetCapFlags_A,
-	 .MyCRA = LP_CR2A,
-	 .MyCRB = LP_CR2B,
-	 .MyLatchLsw = LP_CNTR2ALSW,
-	 .MyEventBits = EVBITS(2),
-	 },
-	{
-	 .GetEnable = GetEnable_B,
-	 .GetIntSrc = GetIntSrc_B,
-	 .GetLoadTrig = GetLoadTrig_B,
-	 .GetMode = GetMode_B,
-	 .PulseIndex = PulseIndex_B,
-	 .SetEnable = SetEnable_B,
-	 .SetIntSrc = SetIntSrc_B,
-	 .SetLoadTrig = SetLoadTrig_B,
-	 .SetMode = SetMode_B,
-	 .ResetCapFlags = ResetCapFlags_B,
-	 .MyCRA = LP_CR0A,
-	 .MyCRB = LP_CR0B,
-	 .MyLatchLsw = LP_CNTR0BLSW,
-	 .MyEventBits = EVBITS(3),
-	 },
-	{
-	 .GetEnable = GetEnable_B,
-	 .GetIntSrc = GetIntSrc_B,
-	 .GetLoadTrig = GetLoadTrig_B,
-	 .GetMode = GetMode_B,
-	 .PulseIndex = PulseIndex_B,
-	 .SetEnable = SetEnable_B,
-	 .SetIntSrc = SetIntSrc_B,
-	 .SetLoadTrig = SetLoadTrig_B,
-	 .SetMode = SetMode_B,
-	 .ResetCapFlags = ResetCapFlags_B,
-	 .MyCRA = LP_CR1A,
-	 .MyCRB = LP_CR1B,
-	 .MyLatchLsw = LP_CNTR1BLSW,
-	 .MyEventBits = EVBITS(4),
-	 },
-	{
-	 .GetEnable = GetEnable_B,
-	 .GetIntSrc = GetIntSrc_B,
-	 .GetLoadTrig = GetLoadTrig_B,
-	 .GetMode = GetMode_B,
-	 .PulseIndex = PulseIndex_B,
-	 .SetEnable = SetEnable_B,
-	 .SetIntSrc = SetIntSrc_B,
-	 .SetLoadTrig = SetLoadTrig_B,
-	 .SetMode = SetMode_B,
-	 .ResetCapFlags = ResetCapFlags_B,
-	 .MyCRA = LP_CR2A,
-	 .MyCRB = LP_CR2B,
-	 .MyLatchLsw = LP_CNTR2BLSW,
-	 .MyEventBits = EVBITS(5),
-	 },
-};
-
 /*  enab/disable a function or test status bit(s) that are accessed */
 /*  through Main Control Registers 1 or 2. */
 #define MC_ENABLE(REGADRS, CTRLWORD)	writel(((uint32_t)(CTRLWORD) << 16) | (uint32_t)(CTRLWORD), devpriv->base_addr+(REGADRS))
@@ -2681,6 +2553,100 @@ static void Preload(struct comedi_device *dev, struct enc_private *k,
 		  (uint16_t) (value >> 16));
 }
 
+static struct enc_private enc_private_data[] = {
+	{
+		.GetEnable	= GetEnable_A,
+		.GetIntSrc	= GetIntSrc_A,
+		.GetLoadTrig	= GetLoadTrig_A,
+		.GetMode	= GetMode_A,
+		.PulseIndex	= PulseIndex_A,
+		.SetEnable	= SetEnable_A,
+		.SetIntSrc	= SetIntSrc_A,
+		.SetLoadTrig	= SetLoadTrig_A,
+		.SetMode	= SetMode_A,
+		.ResetCapFlags	= ResetCapFlags_A,
+		.MyCRA		= LP_CR0A,
+		.MyCRB		= LP_CR0B,
+		.MyLatchLsw	= LP_CNTR0ALSW,
+		.MyEventBits	= EVBITS(0),
+	}, {
+		.GetEnable	= GetEnable_A,
+		.GetIntSrc	= GetIntSrc_A,
+		.GetLoadTrig	= GetLoadTrig_A,
+		.GetMode	= GetMode_A,
+		.PulseIndex	= PulseIndex_A,
+		.SetEnable	= SetEnable_A,
+		.SetIntSrc	= SetIntSrc_A,
+		.SetLoadTrig	= SetLoadTrig_A,
+		.SetMode	= SetMode_A,
+		.ResetCapFlags	= ResetCapFlags_A,
+		.MyCRA		= LP_CR1A,
+		.MyCRB		= LP_CR1B,
+		.MyLatchLsw	= LP_CNTR1ALSW,
+		.MyEventBits	= EVBITS(1),
+	}, {
+		.GetEnable	= GetEnable_A,
+		.GetIntSrc	= GetIntSrc_A,
+		.GetLoadTrig	= GetLoadTrig_A,
+		.GetMode	= GetMode_A,
+		.PulseIndex	= PulseIndex_A,
+		.SetEnable	= SetEnable_A,
+		.SetIntSrc	= SetIntSrc_A,
+		.SetLoadTrig	= SetLoadTrig_A,
+		.SetMode	= SetMode_A,
+		.ResetCapFlags	= ResetCapFlags_A,
+		.MyCRA		= LP_CR2A,
+		.MyCRB		= LP_CR2B,
+		.MyLatchLsw	= LP_CNTR2ALSW,
+		.MyEventBits	= EVBITS(2),
+	}, {
+		.GetEnable	= GetEnable_B,
+		.GetIntSrc	= GetIntSrc_B,
+		.GetLoadTrig	= GetLoadTrig_B,
+		.GetMode	= GetMode_B,
+		.PulseIndex	= PulseIndex_B,
+		.SetEnable	= SetEnable_B,
+		.SetIntSrc	= SetIntSrc_B,
+		.SetLoadTrig	= SetLoadTrig_B,
+		.SetMode	= SetMode_B,
+		.ResetCapFlags	= ResetCapFlags_B,
+		.MyCRA		= LP_CR0A,
+		.MyCRB		= LP_CR0B,
+		.MyLatchLsw	= LP_CNTR0BLSW,
+		.MyEventBits	= EVBITS(3),
+	}, {
+		.GetEnable	= GetEnable_B,
+		.GetIntSrc	= GetIntSrc_B,
+		.GetLoadTrig	= GetLoadTrig_B,
+		.GetMode	= GetMode_B,
+		.PulseIndex	= PulseIndex_B,
+		.SetEnable	= SetEnable_B,
+		.SetIntSrc	= SetIntSrc_B,
+		.SetLoadTrig	= SetLoadTrig_B,
+		.SetMode	= SetMode_B,
+		.ResetCapFlags	= ResetCapFlags_B,
+		.MyCRA		= LP_CR1A,
+		.MyCRB		= LP_CR1B,
+		.MyLatchLsw	= LP_CNTR1BLSW,
+		.MyEventBits	= EVBITS(4),
+	}, {
+		.GetEnable	= GetEnable_B,
+		.GetIntSrc	= GetIntSrc_B,
+		.GetLoadTrig	= GetLoadTrig_B,
+		.GetMode	= GetMode_B,
+		.PulseIndex	= PulseIndex_B,
+		.SetEnable	= SetEnable_B,
+		.SetIntSrc	= SetIntSrc_B,
+		.SetLoadTrig	= SetLoadTrig_B,
+		.SetMode	= SetMode_B,
+		.ResetCapFlags	= ResetCapFlags_B,
+		.MyCRA		= LP_CR2A,
+		.MyCRB		= LP_CR2B,
+		.MyLatchLsw	= LP_CNTR2BLSW,
+		.MyEventBits	= EVBITS(5),
+	},
+};
+
 static void CountersInit(struct comedi_device *dev)
 {
 	int chan;
-- 
1.7.11

