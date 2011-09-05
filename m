Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1IEJ1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:27:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61726 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1IEJ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:27:12 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-kernel@vger.kernel.org
Cc: peter.ujfalusi@ti.com, sameo@linux.intel.com, linux-omap@vger.kernel.org,
        broonie@opensource.wolfsonicro.com, tiwai@suse.de,
        alsa-devel@alsa-project.org, Thomas Weber <weber@corscience.de>
Subject: [PATCH] ASoC/MFD: twl4030: Fix dependencies for audio codec
Date: Mon,  5 Sep 2011 11:26:33 +0200
Message-Id: <1315214793-661-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.6.1
X-Provags-ID: V02:K0:a0RC5AaUC+OqgRHZYW4soSy2bc0XRi7pkg3kDpOOdmv
 BOSyHcnRFUUvEY4M8h64tDfRwEcZfsyljSTEaqeHtASktopL/w
 HEU1wwnJ8NxktZSy7F/JStYMb1TM1SQmD8J8/KaPgxBjjFtqr/
 tLxzckUnTKRXNiGOFthBujqZyiZ9Gy0UNKmDwWuPjIedk4eS3H
 R2AUWNiaR7Xp9IClB4CLNOK2GFTYlwxDvdPsRPj1K/1LHNIJVp
 CY2FeXpr02MTBoDAh8eoE1I4Rb7YViATBHmNF8NNj89Ua8KI+I
 uYBbAleYXgEsFCV+x/pEJLM00jKh0E6IBLy1+RycDdHBiSclLp
 D2LIds28fztFu4LF5Y6U/GNfiBmv06cplwEoak9YWCTRcjyqA/
 uBe4xKwPyFKng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The codec for Devkit8000 (TWL4030)  was not detected except
when build with CONFIG_SND_SOC_ALL_CODECS.

twl-core.c still uses the CONFIG_TWL4030_CODEC for
twl_has_codec().

In commit 57fe7251f5bfc4332f24479376de48a1e8ca6211
the CONFIG_TWL4030_CODEC was renamed
into CONFIG_MFD_TWL4030_AUDIO, thatswhy the codec
was not detected.

This patch renames the CONFIG_ TWL4030_CODEC into
CONFIG_MFD_TWL4030_AUDIO in twl-core.c.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/mfd/twl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 01ecfee..b8eef46 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -109,7 +109,7 @@
 #define twl_has_watchdog()        false
 #endif
 
-#if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE) ||\
+#if defined(CONFIG_MFD_TWL4030_AUDIO) || defined(CONFIG_MFD_TWL4030_AUDIO_MODULE) ||\
 	defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
 #define twl_has_codec()	true
 #else
-- 
1.7.6.1

