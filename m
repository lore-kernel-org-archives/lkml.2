Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1EIAdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:52309 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab1EIAdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="689907939"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 12/19] mfd: Use mfd cell platform_data for wm8400 cells platform bits
Date: Mon,  9 May 2011 02:32:04 +0200
Message-Id: <1304901131-7104-13-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/wm8400-core.c |    3 ++-
 sound/soc/codecs/wm8400.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 3a6e78c..597f82e 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -245,7 +245,8 @@ static int wm8400_register_codec(struct wm8400 *wm8400)
 {
 	struct mfd_cell cell = {
 		.name = "wm8400-codec",
-		.mfd_data = wm8400,
+		.platform_data = wm8400,
+		.pdata_size = sizeof(*wm8400),
 	};
 
 	return mfd_add_devices(wm8400->dev, -1, &cell, 1, NULL, 0);
diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index 736b785..a4bd593 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -1378,7 +1378,7 @@ static void wm8400_probe_deferred(struct work_struct *work)
 
 static int wm8400_codec_probe(struct snd_soc_codec *codec)
 {
-	struct wm8400 *wm8400 = mfd_get_data(to_platform_device(codec->dev));
+	struct wm8400 *wm8400 = codec->dev->platform_data;
 	struct wm8400_priv *priv;
 	int ret;
 	u16 reg;
-- 
1.7.2.3

