Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1CZHyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 03:54:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55760 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1CZHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 03:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aRVkxCChnFCN0yt5wdxclNe1p8L9N4KJoIpZfEUTU+O03PTOSYT1BR1o5DBBn3Kgig
         isi4Wa+yo7zO/CD9iq9PB3k4LEPEGPDc4+5W/ipd6Ltu0xem+hRFrEMkR4fErVwEz+n8
         mVt5BJLnkDN6hEmiYcTxGI0JjuLlPamAxnUrI=
Subject: [PATCH] ASoC: twl6040: Return -ENOMEM if
 create_singlethread_workqueue fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Misael Lopez Cruz <misael.lopez@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 15:53:58 +0800
Message-ID: <1301126038.7662.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/twl6040.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 482fcdb..255901c 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1629,8 +1629,10 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 	priv->naudint = naudint;
 	priv->workqueue = create_singlethread_workqueue("twl6040-codec");
 
-	if (!priv->workqueue)
+	if (!priv->workqueue) {
+		ret = -ENOMEM;
 		goto work_err;
+	}
 
 	INIT_DELAYED_WORK(&priv->delayed_work, twl6040_accessory_work);
 
-- 
1.7.1



