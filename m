Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2FSTUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:20:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56689 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2FSTUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:20:46 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 1/2] swarm_cs4297: Provide definitions for AC97 registers
Date: Tue, 19 Jun 2012 16:20:23 -0300
Message-Id: <1340133624-3670-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the last usage of linux/ac97_codec.h by
re-defining used AC97 registers.
We can't use sound/ac97_codec.h here, since it is an OSS driver.

Not even compilation tested.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 sound/oss/swarm_cs4297a.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 09d4648..bd75f54 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -69,7 +69,6 @@
 #include <linux/sound.h>
 #include <linux/slab.h>
 #include <linux/soundcard.h>
-#include <linux/ac97_codec.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
@@ -199,6 +198,22 @@ static const char invalid_magic[] =
         }                                          \
 })
 
+/* AC97 registers */
+#define AC97_MASTER_VOL_STEREO   0x0002      /* Line Out		*/
+#define AC97_PCBEEP_VOL          0x000a      /* none			*/
+#define AC97_PHONE_VOL           0x000c      /* TAD Input (mono)	*/
+#define AC97_MIC_VOL             0x000e      /* MIC Input (mono)	*/
+#define AC97_LINEIN_VOL          0x0010      /* Line Input (stereo)	*/
+#define AC97_CD_VOL              0x0012      /* CD Input (stereo)	*/
+#define AC97_AUX_VOL             0x0016      /* Aux Input (stereo)	*/
+#define AC97_PCMOUT_VOL          0x0018      /* Wave Output (stereo)	*/
+#define AC97_RECORD_SELECT       0x001a      /*			*/
+#define AC97_RECORD_GAIN         0x001c
+#define AC97_GENERAL_PURPOSE     0x0020
+#define AC97_3D_CONTROL          0x0022
+#define AC97_POWER_CONTROL       0x0026
+#define AC97_VENDOR_ID1           0x007c
+
 struct list_head cs4297a_devs = { &cs4297a_devs, &cs4297a_devs };
 
 typedef struct serdma_descr_s {
-- 
1.7.4.4

