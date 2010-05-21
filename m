Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab0EUWfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:35:41 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:45493 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab0EUWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:35:40 -0400
X-MXL-Hash: 4bf70abc4914c50e-e559bb11755e839c94383f9d1b48ef88a65ab007
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
CC: "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>
Date: Fri, 21 May 2010 17:35:03 -0500
Subject: [PATCH] aw2-alsa.c: use pci_ids.h defines and fix checkpatch.pl
 noise
Thread-Topic: [PATCH] aw2-alsa.c: use pci_ids.h defines and fix
 checkpatch.pl noise
Thread-Index: Acr5NdrJ4JuRhLSWQ+CFy9zKFI/4Ew==
Message-ID: <0D753D10438DA54287A00B0270842697636F323864@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010051701)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=ruWHben_DbcA:10 a=yQWWgrYGNuUA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=gfcQOnsOHudNTuowZGYA:9 a=juNMx4nahrn8Of4WFO]
X-AnalysisOut: [H0BwZhen4A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQd]
X-AnalysisOut: [w3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4LMZoaS005726

Use the VENDOR/DEVICE ids provided in pci_ids.h instead of creating
local ids of the same values.

Also, fix the following checkpatch.pl warnings:

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: unnecessary whitespace before a quoted newline

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>

---

diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index 67921f9..c150022 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
@@ -44,9 +44,6 @@ MODULE_LICENSE("GPL");
 /*********************************
  * DEFINES
  ********************************/
-#define PCI_VENDOR_ID_SAA7146		  0x1131
-#define PCI_DEVICE_ID_SAA7146		  0x7146
-
 #define CTL_ROUTE_ANALOG 0
 #define CTL_ROUTE_DIGITAL 1
 
@@ -165,7 +162,7 @@ module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Audiowerk2 soundcard.");
 
 static DEFINE_PCI_DEVICE_TABLE(snd_aw2_ids) = {
-	{PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, 0, 0,
+	{PCI_VENDOR_ID_PHILIPS, PCI_DEVICE_ID_PHILIPS_SAA7146, 0, 0,
 	 0, 0, 0},
 	{0}
 };
@@ -419,7 +416,7 @@ static int snd_aw2_pcm_playback_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 
-	snd_printdd(KERN_DEBUG "aw2: Playback_open \n");
+	snd_printdd(KERN_DEBUG "aw2: Playback_open\n");
 	runtime->hw = snd_aw2_playback_hw;
 	return 0;
 }
@@ -435,7 +432,7 @@ static int snd_aw2_pcm_capture_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 
-	snd_printdd(KERN_DEBUG "aw2: Capture_open \n");
+	snd_printdd(KERN_DEBUG "aw2: Capture_open\n");
 	runtime->hw = snd_aw2_capture_hw;
 	return 0;
 }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
