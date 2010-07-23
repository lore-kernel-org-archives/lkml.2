Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0GWFyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57042 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0GWFyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VtQYyrChZTZNfkTR4HyX7pvgrRN4kcZNo3wf/5C1ov/zkA/jB3uew2hH2MNp90+r2c
         WYGqPvSJ/zOWBVOq8cAOZLb2L8SksaB+baCOVB3h0YCDUownOmRMPwwZRvnpTMwi9jtj
         tqahb/5lEcOXp9TwwFVWRRJHwl0hjfH1dFwsQ=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 10/12] wm8974: fix a memory leak if another WM8974 is registered
Date: Fri, 23 Jul 2010 05:53:52 +0000
Message-Id: <1279864434-8010-11-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
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
1.7.0.4

