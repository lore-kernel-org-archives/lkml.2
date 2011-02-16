Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1BPBZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:25:01 -0500
Received: from kroah.org ([198.145.64.141]:49180 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab1BPAWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:40 2011
Message-Id: <20110216001440.573978809@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [155/272] ASoC: Fix AC97 registration unwind
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 7d8316df44053687625eef792d53b3ac62e82248 upstream.

soc_unregister_ac97_dai_link() takes a CODEC as an argument, not a
rtd like the registration function, so give it what it's looking for.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/soc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1623,7 +1623,7 @@ static void snd_soc_instantiate_card(str
 		if (ret < 0) {
 			printk(KERN_ERR "asoc: failed to register AC97 %s\n", card->name);
 			while (--i >= 0)
-				soc_unregister_ac97_dai_link(&card->rtd[i]);
+				soc_unregister_ac97_dai_link(card->rtd[i].codec);
 			goto probe_dai_err;
 		}
 	}


