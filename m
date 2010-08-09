Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0HIR5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab0HIR5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:57:03 -0400
Message-ID: <4C604196.6060100@redhat.com>
Date: Mon, 09 Aug 2010 14:57:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 7 (IR)
References: <20100807160710.b7c8d838.sfr@canb.auug.org.au>	<20100807203920.83134a60.randy.dunlap@oracle.com>	<20100808135511.269f670c.randy.dunlap@oracle.com>	<4C5F9C2E.50001@redhat.com> <20100809075255.97d18a66.randy.dunlap@oracle.com> <4C603DB1.9030706@redhat.com>
In-Reply-To: <4C603DB1.9030706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-08-2010 14:41, Mauro Carvalho Chehab escreveu:
> Em 09-08-2010 11:52, Randy Dunlap escreveu:
>>> Hmm... clearly, there are some bad dependencies at the Kconfig. Maybe ir-core were compiled
>>> as module, while some drivers as built-in.
>>>
>>> Could you please pass the .config file for this build?
>>
>>
>> Sorry, config-r5101 is now attached.
> 
> Hmm... when building it, I'm getting an interesting warning:
> 
> warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT || VIDEO_SAA7134 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT || VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || VIDEO_TLG2300 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && SND && DVB_CORE || VIDEO_CX231XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || DVB_BUDGET_CI && MEDIA_SUPPORT && DVB_CA
PT
> URE_DRIVERS && DVB_CORE && DVB_BUDGET_CORE && I2C && INPUT || DVB_DM1105 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C && INPUT || VIDEO_GO7007 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && PCI && I2C && INPUT && SND || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)
> 
> This warning seems to explain what's going wrong.
> 
> I'll make patch(es) to address this issue.


Ok, This patch (together with the previous one) seemed to solve the issue.


commit 0a706cf23aee2f6349f4b076f966038efb788a49
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Aug 9 14:45:02 2010 -0300

    V4L/DVB: fix Kconfig to depends on VIDEO_IR
    
    warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT || VIDEO_SAA7134 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT || VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || VIDEO_TLG2300 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && SND && DVB_CORE || VIDEO_CX231XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || DVB_BUDGET_CI && MEDIA_SUPPORT && DVB_
CAPTURE_DRIVERS && DVB_CORE && DVB_BUDGET_CORE && I2C && INPUT || DVB_DM1105 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C && INPUT || VIDEO_GO7007 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && PCI && I2C && INPUT && SND || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dm1105/Kconfig b/drivers/media/dvb/dm1105/Kconfig
index 6952392..a6ceb08 100644
--- a/drivers/media/dvb/dm1105/Kconfig
+++ b/drivers/media/dvb/dm1105/Kconfig
@@ -9,7 +9,7 @@ config DVB_DM1105
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
 	select DVB_DS3000 if !DVB_FE_CUSTOMISE
-	select VIDEO_IR
+	depends on VIDEO_IR
 	help
 	  Support for cards based on the SDMC DM1105 PCI chip like
 	  DvbWorld 2002
diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
index 32a7ec6..debea8d 100644
--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -98,7 +98,7 @@ config DVB_BUDGET_CI
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
 	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
-	select VIDEO_IR
+	depends on VIDEO_IR
 	help
 	  Support for simple SAA7146 based DVB cards
 	  (so called Budget- or Nova-PCI cards) without onboard
diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
index 3077c45..1a4a89f 100644
--- a/drivers/media/video/bt8xx/Kconfig
+++ b/drivers/media/video/bt8xx/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_BT848
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/media/video/cx18/Kconfig b/drivers/media/video/cx18/Kconfig
index baf7e91..76c054d 100644
--- a/drivers/media/video/cx18/Kconfig
+++ b/drivers/media/video/cx18/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_CX18
 	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
 	depends on INPUT	# due to VIDEO_IR
 	select I2C_ALGOBIT
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index 477d4ab..5ac7ece 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_CX231XX
 	depends on VIDEO_DEV && I2C && INPUT
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index c7e5851..99dbae1 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_CX88
 	select VIDEOBUF_DMA_SG
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEO_WM8775 if VIDEO_HELPER_CHIPS_AUTO
 	---help---
 	  This is a video4linux driver for Conexant 2388x based
diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index c7be0e0..66aefd6 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_EM28XX
 	depends on VIDEO_DEV && I2C && INPUT
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEOBUF_VMALLOC
 	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_TVP5150 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/media/video/ivtv/Kconfig b/drivers/media/video/ivtv/Kconfig
index c46bfb1..be4af1f 100644
--- a/drivers/media/video/ivtv/Kconfig
+++ b/drivers/media/video/ivtv/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_IVTV
 	depends on VIDEO_V4L2 && PCI && I2C
 	depends on INPUT   # due to VIDEO_IR
 	select I2C_ALGOBIT
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index 22bfd62..fda005e 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_SAA7134
 	tristate "Philips SAA7134 support"
 	depends on VIDEO_DEV && PCI && I2C && INPUT
 	select VIDEOBUF_DMA_SG
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select CRC32
diff --git a/drivers/media/video/tlg2300/Kconfig b/drivers/media/video/tlg2300/Kconfig
index 2c29ec6..1686ebf 100644
--- a/drivers/media/video/tlg2300/Kconfig
+++ b/drivers/media/video/tlg2300/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_TLG2300
 	depends on VIDEO_DEV && I2C && INPUT && SND && DVB_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEO_IR
+	depends on VIDEO_IR
 	select VIDEOBUF_VMALLOC
 	select SND_PCM
 	select VIDEOBUF_DVB
