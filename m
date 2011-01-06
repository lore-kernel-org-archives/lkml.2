Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1AFA7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:59:43 -0500
Received: from kroah.org ([198.145.64.141]:35464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab1AFA3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:09 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.032648432@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Uk Kim <w0806.kim@samsung.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [025/152] ASoC: Fix swap of left and right channels for WM8993/4 speaker boost gain
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Uk Kim <w0806.kim@samsung.com>

commit ed8cc471d75365f8590c76f580def899d58028c0 upstream.

SPKOUTL_BOOST start from third bit, SPKOUTLR_BOOST start from 0 bit.

Signed-off-by: Uk Kim <w0806.kim@samsung.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm_hubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -293,7 +293,7 @@ SOC_DOUBLE_R("Speaker Switch",
 SOC_DOUBLE_R("Speaker ZC Switch",
 	     WM8993_SPEAKER_VOLUME_LEFT, WM8993_SPEAKER_VOLUME_RIGHT,
 	     7, 1, 0),
-SOC_DOUBLE_TLV("Speaker Boost Volume", WM8993_SPKOUT_BOOST, 0, 3, 7, 0,
+SOC_DOUBLE_TLV("Speaker Boost Volume", WM8993_SPKOUT_BOOST, 3, 0, 7, 0,
 	       spkboost_tlv),
 SOC_ENUM("Speaker Reference", speaker_ref),
 SOC_ENUM("Speaker Mode", speaker_mode),


