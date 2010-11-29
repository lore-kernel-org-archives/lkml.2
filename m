Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0K2Jde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:33:34 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41774 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0K2Jdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:33:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aHqx4EM63JB2YtXiJNld1p+YGvcMd2ACCKaUfOB2u53US3ClNIxzhrru7BwfuP14Sm
         5/m7OJAfUwP81IThw2yXMmTuozAydxRMaT8SOaw09zSD8ovTI1DgxP01VfawMEM/X6gU
         MJyIbRwRomON/Mns34qfR9oX8mhEIKP+3G/U8=
Subject: [PATCH 1/5] ASoC: Fix compile error for nuc900-ac97.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1291023491.22911.1.camel@mola>
References: <1291023491.22911.1.camel@mola>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 17:39:10 +0800
Message-Id: <1291023550.22911.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below compile error by add a missing ';'.

  CC      sound/soc/nuc900/nuc900-ac97.o
sound/soc/nuc900/nuc900-ac97.c:300: warning: initialization from incompatible pointer type
sound/soc/nuc900/nuc900-ac97.c:301: warning: initialization from incompatible pointer type
sound/soc/nuc900/nuc900-ac97.c:318: error: expected ',' or ';' before 'static'
sound/soc/nuc900/nuc900-ac97.c:405: error: 'nuc900_ac97_drvprobe' undeclared here (not in a function)
make[3]: *** [sound/soc/nuc900/nuc900-ac97.o] Error 1
make[2]: *** [sound/soc/nuc900] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/nuc900/nuc900-ac97.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index e00e39d..4f056b4 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -313,7 +313,7 @@ static struct snd_soc_dai_driver nuc900_ac97_dai = {
 		.channels_max	= 2,
 	},
 	.ops = &nuc900_ac97_dai_ops,
-}
+};
 
 static int __devinit nuc900_ac97_drvprobe(struct platform_device *pdev)
 {
-- 
1.7.2



