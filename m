Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0GNLGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:06:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47561 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0GNLGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Qm9sUayqaLnleTNTDjOPc5tNxkaa9ZOXPGMX1UrvokUcmxJPvq63ZGVaQ+I7lHt0G3
         qT+x0HDRtgngGjI82QRxF0ZAvjI4cK5lrlxcAoT0hieiI5GyenHJ2c6jbDHrODriZ1YP
         3NPz45LXDkadmQrCF/44r4r/hpZORckJwGyIg=
Subject: [PATCH] wm8988: remove a redundant snd_soc_unregister_codec call
 in wm8988_register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 19:06:07 +0800
Message-ID: <1279105567.2290.8.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_soc_unregister_codec is called twice if snd_soc_register_dai fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8988.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index 0417dae..19ad590 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -885,7 +885,6 @@ static int wm8988_register(struct wm8988_priv *wm8988,
 	ret = snd_soc_register_dai(&wm8988_dai);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register DAI: %d\n", ret);
-		snd_soc_unregister_codec(codec);
 		goto err_codec;
 	}
 
-- 
1.7.0.4



