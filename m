Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab0GODIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:08:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47232 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0GODIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UErTRXvM15+k7CR/thNsDXgsNDPHK9ATVdw8x/80LCfJ0aJX9JH8RBa7fvsRZv2GDb
         dGQu+22t8xbnRYQfFKoQ+a2kPa7mZFdygji82G/c3dWKwvivoW7fRSX9B4wBYtiAJKNr
         fQ/+whBVl05MwS1SP6qRI3U1T4HUn67PB7fk0=
Subject: [PATCH 11/12] wm8978: fix a memory leak if another WM8978 is
	registered
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 11:08:58 +0800
Message-Id: <1279163338.29294.30.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8978 is allocated in wm8978_i2c_probe() but is not freed if wm8978_register()
return -EINVAL (if another WM8978 is registered).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8978.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 51d5f43..4e80323 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -1007,7 +1007,8 @@ static __devinit int wm8978_register(struct wm8978_priv *wm8978)
 
 	if (wm8978_codec) {
 		dev_err(codec->dev, "Another WM8978 is registered\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	/*
-- 
1.5.4.3



