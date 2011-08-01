Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1HAXiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:38:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab1HAXYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.111615217@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [15/70] ASoC: Ensure we delay long enough for WM8994 FLL to lock when starting
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 8e9ddf811ba021506d2316fcfe619faa0ab3f567 upstream.

This delay is very conservative.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1969,6 +1969,8 @@ static int _wm8994_set_fll(struct snd_so
 		snd_soc_update_bits(codec, WM8994_FLL1_CONTROL_1 + reg_offset,
 				    WM8994_FLL1_ENA | WM8994_FLL1_FRAC,
 				    reg);
+
+		msleep(5);
 	}
 
 	wm8994->fll[id].in = freq_in;


