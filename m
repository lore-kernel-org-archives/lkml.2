Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab1BRDLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:11:44 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51890 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461Ab1BRDIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:12 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 20/29] wm8400-codec: use mfd_data instead of driver_data (v2)
Date: Thu, 17 Feb 2011 19:07:27 -0800
Message-Id: <1297998456-7615-21-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to soc
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().

v2: add some missing mfd/core.h includes.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/wm8400-core.c |    2 +-
 sound/soc/codecs/wm8400.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 1bfef48..3a6e78c 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -245,7 +245,7 @@ static int wm8400_register_codec(struct wm8400 *wm8400)
 {
 	struct mfd_cell cell = {
 		.name = "wm8400-codec",
-		.driver_data = wm8400,
+		.mfd_data = wm8400,
 	};
 
 	return mfd_add_devices(wm8400->dev, -1, &cell, 1, NULL, 0);
diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index 3c3bc07..736b785 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -22,6 +22,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/mfd/wm8400-audio.h>
 #include <linux/mfd/wm8400-private.h>
+#include <linux/mfd/core.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -1377,7 +1378,7 @@ static void wm8400_probe_deferred(struct work_struct *work)
 
 static int wm8400_codec_probe(struct snd_soc_codec *codec)
 {
-	struct wm8400 *wm8400 = dev_get_platdata(codec->dev);
+	struct wm8400 *wm8400 = mfd_get_data(to_platform_device(codec->dev));
 	struct wm8400_priv *priv;
 	int ret;
 	u16 reg;
-- 
1.7.2.3

