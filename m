Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1HAXYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:24:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1HAXYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.217009622@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [16/70] ASoC: ak4642: fixup snd_soc_update_bits mask for PW_MGMT2
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit bd7fdbcaa2d06d446577fd3c9b81847b04469e01 upstream.

mask didn't cover update-data

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ak4642.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -357,7 +357,7 @@ static int ak4642_dai_set_fmt(struct snd
 	default:
 		return -EINVAL;
 	}
-	snd_soc_update_bits(codec, PW_MGMT2, MS, data);
+	snd_soc_update_bits(codec, PW_MGMT2, MS | MCKO | PMPLL, data);
 	snd_soc_update_bits(codec, MD_CTL1, BCKO_MASK, bcko);
 
 	/* format type */


