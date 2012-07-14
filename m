Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2GNAFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:05:16 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11425 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2GNAFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:05:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1342224311!9627607!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: addi_data: remove pr_TTLRangelist
Date: Fri, 13 Jul 2012 17:05:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207131705.02813.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the addi driver ttl subdevices use the range table
'range_digital' provided by the comedi core. The boardinfo
value  'pr_TTLRangeList' is not used by the drivers. Remove
the unused range tables and the boardinfo pointer.

The unused range tables don't make sense anyway...

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../staging/comedi/drivers/addi-data/addi_common.c | 23 ----------------------
 .../staging/comedi/drivers/addi-data/addi_common.h |  1 -
 .../comedi/drivers/addi-data/hwdrv_apci16xx.h      | 15 --------------
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.h      | 14 -------------
 4 files changed, 53 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 1e62f33..d7c1e1d 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -610,7 +610,6 @@ static const struct addi_board boardtypes[] = {
 		.i_IorangeBase0		= 128,
 		.i_PCIEeprom		= ADDIDATA_NO_EEPROM,
 		.i_NbrTTLChannel	= 48,
-		.pr_TTLRangelist	= &range_apci16xx_ttl,
 		.reset			= i_APCI16XX_Reset,
 		.ttl_config		= i_APCI16XX_InsnConfigInitTTLIO,
 		.ttl_bits		= i_APCI16XX_InsnBitsReadTTLIO,
@@ -623,7 +622,6 @@ static const struct addi_board boardtypes[] = {
 		.i_IorangeBase0		= 128,
 		.i_PCIEeprom		= ADDIDATA_NO_EEPROM,
 		.i_NbrTTLChannel	= 96,
-		.pr_TTLRangelist	= &range_apci16xx_ttl,
 		.reset			= i_APCI16XX_Reset,
 		.ttl_config		= i_APCI16XX_InsnConfigInitTTLIO,
 		.ttl_bits		= i_APCI16XX_InsnBitsReadTTLIO,
@@ -648,7 +646,6 @@ static const struct addi_board boardtypes[] = {
 		.i_AiMaxdata		= 4095,
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -675,7 +672,6 @@ static const struct addi_board boardtypes[] = {
 		.i_AiMaxdata		= 4095,
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -702,7 +698,6 @@ static const struct addi_board boardtypes[] = {
 		.i_AiMaxdata		= 4095,
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -729,7 +724,6 @@ static const struct addi_board boardtypes[] = {
 		.i_AiMaxdata		= 65535,
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -756,7 +750,6 @@ static const struct addi_board boardtypes[] = {
 		.i_AiMaxdata		= 65535,
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -783,7 +776,6 @@ static const struct addi_board boardtypes[] = {
 		.i_AiMaxdata		= 65535,
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -813,7 +805,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -848,7 +839,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -883,7 +873,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -918,7 +907,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -953,7 +941,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -988,7 +975,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1023,7 +1009,6 @@ static const struct addi_board boardtypes[] = {
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.pr_AoRangelist		= &range_apci3XXX_ao,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1054,7 +1039,6 @@ static const struct addi_board boardtypes[] = {
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.pr_AoRangelist		= &range_apci3XXX_ao,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1085,7 +1069,6 @@ static const struct addi_board boardtypes[] = {
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.pr_AoRangelist		= &range_apci3XXX_ao,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1116,7 +1099,6 @@ static const struct addi_board boardtypes[] = {
 		.pr_AiRangelist		= &range_apci3XXX_ai,
 		.pr_AoRangelist		= &range_apci3XXX_ao,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1150,7 +1132,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1189,7 +1170,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1228,7 +1208,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1267,7 +1246,6 @@ static const struct addi_board boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 1,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.b_AvailableConvertUnit	= 6,
 		.ui_MinAcquisitiontimeNs = 5000,
 		.interrupt		= v_APCI3XXX_Interrupt,
@@ -1410,7 +1388,6 @@ static const struct addi_board boardtypes[] = {
 		.i_AoMaxdata		= 4095,
 		.pr_AoRangelist		= &range_apci3XXX_ao,
 		.i_NbrTTLChannel	= 24,
-		.pr_TTLRangelist	= &range_apci3XXX_ttl,
 		.interrupt		= v_APCI3XXX_Interrupt,
 		.reset			= i_APCI3XXX_Reset,
 		.ao_write		= i_APCI3XXX_InsnWriteAnalogOutput,
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index 2c3f347..b7bbb71 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -85,7 +85,6 @@ struct addi_board {
 	int i_DoMaxdata;	/*  data to set all channels high */
 
 	int i_NbrTTLChannel;	/*  Number of TTL channels */
-	const struct comedi_lrange *pr_TTLRangelist;	/* rangelist for TTL */
 
 	int i_Dma;		/*  dma present or not */
 	int i_Timer;		/*    timer subdevice present or not */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.h
index 5bf91e1..a12df4b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.h
@@ -41,21 +41,6 @@
 
 #ifdef __KERNEL__
 
-static const struct comedi_lrange range_apci16xx_ttl = { 12,
-	{BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1),
-	 BIP_RANGE(1)}
-};
-
 /*
 +----------------------------------------------------------------------------+
 |                       TTL INISIALISATION FUNCTION                          |
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
index cce9e12..e10b7e5 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
@@ -42,20 +42,6 @@ static const struct comedi_lrange range_apci3XXX_ai = { 8, {BIP_RANGE(10),
 						     UNI_RANGE(1)}
 };
 
-static const struct comedi_lrange range_apci3XXX_ttl = { 12, {BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1),
-						       BIP_RANGE(1)}
-};
-
 static const struct comedi_lrange range_apci3XXX_ao = { 2, {BIP_RANGE(10),
 						     UNI_RANGE(10)}
 };
-- 
1.7.11

