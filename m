Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2BAVbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:31:36 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49484 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932587Ab2BAVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:13 -0500
X-Sasl-enc: x/WAEizUX0x12Tcl4kQ9YJ+u8hYcftfnAy54ZGvD717Z 1328131152
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.035823319@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [13/89] ASoC: Mark WM5100 register map cache only when going into BIAS_OFF
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit e53e417331c57b9b97e3f8be870214a02c99265c upstream.

Writing to the registers won't work if we do actually manage to hit a fully
powered off state.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm5100.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -1404,6 +1404,7 @@ static int wm5100_set_bias_level(struct
 		break;
 
 	case SND_SOC_BIAS_OFF:
+		regcache_cache_only(wm5100->regmap, true);
 		if (wm5100->pdata.ldo_ena)
 			gpio_set_value_cansleep(wm5100->pdata.ldo_ena, 0);
 		regulator_bulk_disable(ARRAY_SIZE(wm5100->core_supplies),


