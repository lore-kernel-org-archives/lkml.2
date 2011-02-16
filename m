Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1BPBJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:09:18 -0500
Received: from kroah.org ([198.145.64.141]:45745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122Ab1BPAtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:08 2011
Message-Id: <20110216002108.013448534@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Frysinger <vapier@gentoo.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 089/176] ASoC: Blackfin TDM: fix missed snd_soc_dai_get_drvdata update
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 15d2e22b820bad62854d6ad99d8af8320adf4a91 upstream.

One spot was missed in this driver when converting from
snd_soc_dai.private_data to snd_soc_dai_get_drvdata.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/blackfin/bf5xx-tdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/blackfin/bf5xx-tdm.c
+++ b/sound/soc/blackfin/bf5xx-tdm.c
@@ -210,7 +210,7 @@ static int bf5xx_tdm_set_channel_map(str
 #ifdef CONFIG_PM
 static int bf5xx_tdm_suspend(struct snd_soc_dai *dai)
 {
-	struct sport_device *sport = dai->private_data;
+	struct sport_device *sport = snd_soc_dai_get_drvdata(dai);
 
 	if (!dai->active)
 		return 0;


