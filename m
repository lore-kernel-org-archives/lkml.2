Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab1BPCGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:06:10 -0500
Received: from kroah.org ([198.145.64.141]:48945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264Ab1BPBuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:59 2011
Message-Id: <20110216014659.000163986@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Frysinger <vapier@gentoo.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [047/115] ASoC: Blackfin AC97: fix build error after multi-component update
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit e9c2048915048d605fd76539ddd96f00d593e1eb upstream.

We need to tweak how we query the active capture/playback state after
the recent overhauls of common code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/blackfin/bf5xx-ac97.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -260,9 +260,9 @@ static int bf5xx_ac97_suspend(struct snd
 	pr_debug("%s : sport %d\n", __func__, dai->id);
 	if (!dai->active)
 		return 0;
-	if (dai->capture.active)
+	if (dai->capture_active)
 		sport_rx_stop(sport);
-	if (dai->playback.active)
+	if (dai->playback_active)
 		sport_tx_stop(sport);
 	return 0;
 }


