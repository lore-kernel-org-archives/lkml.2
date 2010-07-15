Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab0GODHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:07:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38960 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0GODHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xh+DfEO5oAkTfaAIYIV3OHL7NrnjmDkR4cXwU2phBwYefAWZWH/xXNakCMWWqQJKHL
         pORHNas6pdrktnuhGjeiP5uoK4K6dA5S6km/MEP60oCKwRDfjpheGRA5h+U9p2GtCI95
         5ULxXv2GfCeFhNcSUXb9NtNinXP7sNBZDa4U0=
Subject: [PATCH 10/12] wm8974: fix a memory leak if another WM8974 is
	registered
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 11:07:50 +0800
Message-Id: <1279163270.29294.28.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8974 is allocated in wm8974_i2c_probe() but is not freed if wm8974_register()
return -EINVAL (if another WM8974 is registered).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8974.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index a2c4b2f..1468fe1 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -670,7 +670,8 @@ static __devinit int wm8974_register(struct wm8974_priv *wm8974)
 
 	if (wm8974_codec) {
 		dev_err(codec->dev, "Another WM8974 is registered\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	mutex_init(&codec->mutex);
-- 
1.5.4.3



