Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1FPHBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43892 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab1FPHB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:26 -0400
X-Sasl-enc: DUSWtg7QZRyVfW8AViiRI0V2LEe4vWRUK8thkrQe/Trn 1308207685
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.565108322@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [67/89] ASoC: Fix WM8962 headphone volume update for use of advanced
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 caches

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 0f82bdf572fc6e42147151aa4d52542f7fc6d793 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8962.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1998,12 +1998,12 @@ static int wm8962_put_hp_sw(struct snd_k
 		return 0;
 
 	/* If the left PGA is enabled hit that VU bit... */
-	if (reg_cache[WM8962_PWR_MGMT_2] & WM8962_HPOUTL_PGA_ENA)
+	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) & WM8962_HPOUTL_PGA_ENA)
 		return snd_soc_write(codec, WM8962_HPOUTL_VOLUME,
 				     reg_cache[WM8962_HPOUTL_VOLUME]);
 
 	/* ...otherwise the right.  The VU is stereo. */
-	if (reg_cache[WM8962_PWR_MGMT_2] & WM8962_HPOUTR_PGA_ENA)
+	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) & WM8962_HPOUTR_PGA_ENA)
 		return snd_soc_write(codec, WM8962_HPOUTR_VOLUME,
 				     reg_cache[WM8962_HPOUTR_VOLUME]);
 


