Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2GaNbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:31:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42073 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2GaNbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:31:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/6] ASoC: ab8500: Inform SoC Core that we have our own I/O arrangements
Date: Tue, 31 Jul 2012 14:31:22 +0100
Message-Id: <1343741493-17671-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If codec->control_data is not populated SoC Core assumes we want to
use regmap, which fails catastrophically, as we don't have one:

Unable to handle kernel NULL pointer dereference at virtual address 00000080
pgd = c0004000
[00000080] *pgd=00000000
Internal error: Oops: 17 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 1    Not tainted  (3.5.0-rc6-00884-g0b2419e-dirty #130)
PC is at regmap_read+0x10/0x5c
LR is at hw_read+0x80/0x90
pc : [<c01a91b8>]    lr : [<c0216804>]    psr: 60000013

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 3c79592..23b4018 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2406,6 +2406,10 @@ static int ab8500_codec_probe(struct snd_soc_codec *codec)
 
 	/* Setup AB8500 according to board-settings */
 	pdata = (struct ab8500_platform_data *)dev_get_platdata(dev->parent);
+
+	/* Inform SoC Core that we have our own I/O arrangements. */
+	codec->control_data = (void *)true;
+
 	status = ab8500_audio_setup_mics(codec, &pdata->codec->amics);
 	if (status < 0) {
 		pr_err("%s: Failed to setup mics (%d)!\n", __func__, status);
-- 
1.7.9.5

