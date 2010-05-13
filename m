Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab0EMK2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:28:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55068 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0EMK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QOQpolcGkFLmqCS5BYi6iVpofip1tmhxK8x6/Ea2/oNt8UbXarsM2o/4VhxT9ntj6r
         pMCCZMiyBw6xCwcgt2HlRKL9hTKZ4M2M7XxsmR1FG3bMc+88crBwF0nRO2hJzadyMBzW
         smsla00KsQFOzPCq8tvvBwH8Ci8NMafArRMsg=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Bernd Porr <berndporr@f2s.com>,
       Gorskin Ilya <revent82@gmail.com>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: Fixed more long line lengths in comedi.h
Date: Thu, 13 May 2010 18:28:39 +0800
Message-Id: <1273746519-4590-2-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1273746519-4590-1-git-send-email-reodge@gmail.com>
References: <1273746519-4590-1-git-send-email-reodge@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes some long line lengths in comedi.h from checkpatch.pl

I'd like to get some feedback on this patch, since I'm not sure this is the best
way to fix the long line lengths. 

For the enum entries, putting for example "deprecated" above one line makes it
look like all the lines below that are deprecated.

Also, for the last part of the patch, the inline function, is this an acceptable
way to make this fit within the 80 char limit?

Thanks,
Mark

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedi.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 3e3663f..ea96a83 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -267,7 +267,8 @@
 		 * streaming input/output */
 		INSN_CONFIG_GET_HARDWARE_BUFFER_SIZE = 2006,
 		INSN_CONFIG_SET_COUNTER_MODE = 4097,
-		INSN_CONFIG_8254_SET_MODE = INSN_CONFIG_SET_COUNTER_MODE,	/* deprecated */
+		/* deprecated */
+		INSN_CONFIG_8254_SET_MODE = INSN_CONFIG_SET_COUNTER_MODE,
 		INSN_CONFIG_8254_READ_STATUS = 4098,
 		INSN_CONFIG_SET_ROUTING = 4099,
 		INSN_CONFIG_GET_ROUTING = 4109,
@@ -598,14 +599,17 @@
 		NI_GPCT_LOGIC_LOW_CLOCK_SRC_BITS = 0x3,
 		NI_GPCT_NEXT_GATE_CLOCK_SRC_BITS = 0x4,
 		NI_GPCT_NEXT_TC_CLOCK_SRC_BITS = 0x5,
-		NI_GPCT_SOURCE_PIN_i_CLOCK_SRC_BITS = 0x6,	/* NI 660x-specific */
+		/* NI 660x-specific */
+		NI_GPCT_SOURCE_PIN_i_CLOCK_SRC_BITS = 0x6,
 		NI_GPCT_PXI10_CLOCK_SRC_BITS = 0x7,
 		NI_GPCT_PXI_STAR_TRIGGER_CLOCK_SRC_BITS = 0x8,
 		NI_GPCT_ANALOG_TRIGGER_OUT_CLOCK_SRC_BITS = 0x9,
 		NI_GPCT_PRESCALE_MODE_CLOCK_SRC_MASK = 0x30000000,
 		NI_GPCT_NO_PRESCALE_CLOCK_SRC_BITS = 0x0,
-		NI_GPCT_PRESCALE_X2_CLOCK_SRC_BITS = 0x10000000,	/* divide source by 2 */
-		NI_GPCT_PRESCALE_X8_CLOCK_SRC_BITS = 0x20000000,	/* divide source by 8 */
+		/* divide source by 2 */
+		NI_GPCT_PRESCALE_X2_CLOCK_SRC_BITS = 0x10000000,
+		/* divide source by 8 */
+		NI_GPCT_PRESCALE_X8_CLOCK_SRC_BITS = 0x20000000,
 		NI_GPCT_INVERT_CLOCK_SRC_BIT = 0x80000000
 	};
 	static inline unsigned NI_GPCT_SOURCE_PIN_CLOCK_SRC_BITS(unsigned n)
@@ -837,7 +841,8 @@ INSN_CONFIG_ARM */
 	{
 		return NI_USUAL_PFI_SELECT(pfi_channel);
 	}
-	static inline unsigned NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
+	static inline unsigned
+		NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
 	{
 		return NI_USUAL_RTSI_SELECT(rtsi_channel);
 	}
-- 
1.7.0.5

