Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1BPAWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:43 -0500
Received: from kroah.org ([198.145.64.141]:49200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab1BPAWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:40 2011
Message-Id: <20110216001440.903099587@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Qiao Zhou <zhouqiao@marvell.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [158/272] ASoC: WM8994: fix wrong value in tristate function
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Qiao Zhou <zhouqiao@marvell.com>

commit 78b3fb46753872fc79bffecc8d50355a8622b39b upstream.

fix wrong value in wm8994_set_tristate func. when updating reg bits,
it should use "value", not "reg".

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3513,7 +3513,7 @@ static int wm8994_set_tristate(struct sn
 	else
 		val = 0;
 
-	return snd_soc_update_bits(codec, reg, mask, reg);
+	return snd_soc_update_bits(codec, reg, mask, val);
 }
 
 #define WM8994_RATES SNDRV_PCM_RATE_8000_96000


