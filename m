Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab1ALCC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:02:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36024 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1ALCC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:02:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gYoNnytDDobycp99cPM2f6W7VMk+AcgF8RsrF3jBruSUjf6fY7qHl0EEcvW4C3/zUv
         94k5SAhAztjuMfyCeZOQEU8HtnA6BekynSSaXZn/BOzlP3cawGh5MMYgCc7Q0+pIl1+s
         y/Tc5vpbMetcs92DC6FE7RU2adnZq6Gzw1bOo=
Subject: [PATCH] ASoC: Fix parameter for soc_unregister_ac97_dai_link
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Content-Type: text/plain
Date: Wed, 12 Jan 2011 10:02:55 +0800
Message-Id: <1294797775.20409.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soc_unregister_ac97_dai_link takes a pointer to a codec.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: stable@kernel.org  [2.6.37]
---
 sound/soc/soc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 85b7d54..e061ece 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1623,7 +1623,7 @@ static void snd_soc_instantiate_card(struct snd_soc_card *card)
 		if (ret < 0) {
 			printk(KERN_ERR "asoc: failed to register AC97 %s\n", card->name);
 			while (--i >= 0)
-				soc_unregister_ac97_dai_link(&card->rtd[i]);
+				soc_unregister_ac97_dai_link(card->rtd[i].codec);
 			goto probe_dai_err;
 		}
 	}
-- 
1.7.2



