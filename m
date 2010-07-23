Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0GWFyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37511 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0GWFyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vgVit732MoOC5RdncY1A8B1SnNog67bP9429nq7APmudt5yDmxdXuzAaZ/q/lQb/y+
         Dhr8bu7V3TtDirLvZYEJxaxmDfJEhvTz9vDvk8E80iBhNVGxmYKYAMmCqo1Ak7VXeIhT
         WOBjpwzY7v3VP8nTaWKE5XoIsIVEXwBaHQLCM=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 05/12] wm8711: fix a memory leak if another WM8711 is registered
Date: Fri, 23 Jul 2010 05:53:47 +0000
Message-Id: <1279864434-8010-6-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
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
1.7.0.4

