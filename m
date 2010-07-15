Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0GOC5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:57:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53397 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0GOC5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WK2TH0qybKvAc1NguehoTyVjLw7slUETwZZB7aU+biuuXTO6Pz54frSU/21I3SDg77
         vTBAy+56fSApmEGsqDGsy6N2ci9L7Io7rFqDrca5cyC/T+o9xHeTGDLerbCZYuTrz72H
         9xzDIytzJucO4R0DOXa9jNtIxXShjsVYoeBiU=
Subject: [PATCH 5/12] wm8711: fix a memory leak if another WM8711 is
	registered
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 10:57:53 +0800
Message-Id: <1279162673.29294.14.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8711 is allocated in either wm8711_spi_probe() or wm8711_i2c_probe() but is
not freed if wm8711_register() return -EINVAL(if another ad1836 is registered).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8711.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index effb14e..e2dba07 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -439,7 +439,8 @@ static int wm8711_register(struct wm8711_priv *wm8711,
 
 	if (wm8711_codec) {
 		dev_err(codec->dev, "Another WM8711 is registered\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	mutex_init(&codec->mutex);
-- 
1.5.4.3



