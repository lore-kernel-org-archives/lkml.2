Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2HGDin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:38:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59715 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337Ab2HGDia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:30 -0400
Message-Id: <20120807032803.781098237@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 53/70] ASoC: wm8962: Allow VMID time to fully ramp
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 9d40e5582c9c4cfb6977ba2a0ca9c2ed82c56f21 upstream.

Required for reliable power up from cold.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8962.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index eaf6586..aa9ce9d 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2501,6 +2501,9 @@ static int wm8962_set_bias_level(struct snd_soc_codec *codec,
 		/* VMID 2*250k */
 		snd_soc_update_bits(codec, WM8962_PWR_MGMT_1,
 				    WM8962_VMID_SEL_MASK, 0x100);
+
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
+			msleep(100);
 		break;
 
 	case SND_SOC_BIAS_OFF:


