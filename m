Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936149Ab1KJDyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:54:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936127Ab1KJDsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:04 2011
Message-Id: <20111109213204.839181578@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [222/264] ASoC: Ensure the WM8962 oscillator and PLLs start up disabled
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 2af8de8c39cf58e5a5e40a9d5d71332da98e6ba7 upstream.

Since there is no current software control for these they would otherwise
be left enabled, consuming power.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8962.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3854,6 +3854,11 @@ static int wm8962_probe(struct snd_soc_c
 	snd_soc_update_bits(codec, WM8962_CLOCKING2,
 			    WM8962_CLKREG_OVD, WM8962_CLKREG_OVD);
 
+	/* Ensure that the oscillator and PLLs are disabled */
+	snd_soc_update_bits(codec, WM8962_PLL2,
+			    WM8962_OSC_ENA | WM8962_PLL2_ENA | WM8962_PLL3_ENA,
+			    0);
+
 	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies), wm8962->supplies);
 
 	if (pdata) {


