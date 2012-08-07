Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030895Ab2HGWls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:41:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47761 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030882Ab2HGWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:41:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 104/109] ASoC: wm8994: Ensure there are enough BCLKs for four channels
Date: Tue,  7 Aug 2012 15:36:03 -0700
Message-Id: <20120807222052.208153426@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b8edf3e5522735c8ce78b81845f7a1a2d4a08626 upstream.

Otherwise if someone tries to use all four channels on AIF1 with the
device in master mode we won't be able to clock out all the data.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2695,7 +2695,7 @@ static int wm8994_hw_params(struct snd_p
 		return -EINVAL;
 	}
 
-	bclk_rate = params_rate(params) * 2;
+	bclk_rate = params_rate(params) * 4;
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		bclk_rate *= 16;


