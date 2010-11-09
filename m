Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0KIJDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:03:07 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54852 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0KIJDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:03:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ObmBzfiQ1kH+zi0NgulFhB1UGiK3VUiSUjfD014n4UMPjhg9OHpGz7n+Kegmpga0EN
         tCp5S9IIB/A+oRKBIQXfsdF7TtJR2fyYpB9VSIs0uTbnvIvqNwpvcXl2MQ2LcZ8slX87
         uMhkgSXRBe7wVHhViXWON+3QdIyfPda4Q9/PE=
Subject: [PATCH] ASoC: Fix compile error if CONFIG_DEBUG_FS is not
	configured
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>
Content-Type: text/plain
Date: Tue, 09 Nov 2010 17:06:44 +0800
Message-Id: <1289293604.28671.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add soc_init_card_debugfs and soc_cleanup_card_debugfs functions to fix below error.

  CC      sound/soc/soc-core.o
sound/soc/soc-core.c: In function 'soc_probe':
sound/soc/soc-core.c:1689: error: implicit declaration of function 'soc_init_card_debugfs'
sound/soc/soc-core.c: In function 'soc_remove':
sound/soc/soc-core.c:1718: error: implicit declaration of function 'soc_cleanup_card_debugfs'
make[2]: *** [sound/soc/soc-core.o] Error 1
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index f030521..c18ce1d 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -401,6 +401,14 @@ static inline void soc_init_codec_debugfs(struct snd_soc_codec *codec)
 static inline void soc_cleanup_codec_debugfs(struct snd_soc_codec *codec)
 {
 }
+
+static inline void soc_init_card_debugfs(struct snd_soc_card *card)
+{
+}
+
+static inline void soc_cleanup_card_debugfs(struct snd_soc_card *card)
+{
+}
 #endif
 
 #ifdef CONFIG_SND_SOC_AC97_BUS
-- 
1.7.2



