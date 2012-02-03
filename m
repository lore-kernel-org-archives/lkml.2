Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2BCUuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:50:52 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36254 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757626Ab2BCUuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:50:50 -0500
X-Sasl-enc: XFPKyWpGdh3PrYEI3B/DCyKxf+kZpHcC+RiRBiK5gXrA 1328302249
Date: Fri, 3 Feb 2012 12:50:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Re: Linux 3.2.4
Message-ID: <20120203205036.GB1042@kroah.com>
References: <20120203205027.GA1042@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203205027.GA1042@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index d45e887..c8e187e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 2
-SUBLEVEL = 3
+SUBLEVEL = 4
 EXTRAVERSION =
 NAME = Saber-toothed Squirrel
 
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index d0beeec..42d9039 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -1379,7 +1379,6 @@ static int wm5100_set_bias_level(struct snd_soc_codec *codec,
 
 			switch (wm5100->rev) {
 			case 0:
-				regcache_cache_bypass(wm5100->regmap, true);
 				snd_soc_write(codec, 0x11, 0x3);
 				snd_soc_write(codec, 0x203, 0xc);
 				snd_soc_write(codec, 0x206, 0);
@@ -1395,7 +1394,6 @@ static int wm5100_set_bias_level(struct snd_soc_codec *codec,
 					snd_soc_write(codec,
 						      wm5100_reva_patches[i].reg,
 						      wm5100_reva_patches[i].val);
-				regcache_cache_bypass(wm5100->regmap, false);
 				break;
 			default:
 				break;
@@ -1406,7 +1404,6 @@ static int wm5100_set_bias_level(struct snd_soc_codec *codec,
 		break;
 
 	case SND_SOC_BIAS_OFF:
-		regcache_cache_only(wm5100->regmap, true);
 		if (wm5100->pdata.ldo_ena)
 			gpio_set_value_cansleep(wm5100->pdata.ldo_ena, 0);
 		regulator_bulk_disable(ARRAY_SIZE(wm5100->core_supplies),
