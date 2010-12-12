Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0LLXq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab0LLXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:50 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: axel.lin@gmail.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [109/223] ASoC: wm8961 - clear WM8961_MCLKDIV bit for freq <= 16500000
Message-Id: <20101212234650.0557BB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Axel Lin <axel.lin@gmail.com>

commit 2f7dceeda4708f470fd927adb3861bd8ebbe2310 upstream.

MCLKDIV bit of Register 04h Clocking1:
	0 : Divide by 1
	1 : Divide by 2

Thus in the case of freq <= 16500000, we should clear MCLKDIV bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm8961.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/sound/soc/codecs/wm8961.c
===================================================================
--- linux.orig/sound/soc/codecs/wm8961.c
+++ linux/sound/soc/codecs/wm8961.c
@@ -736,7 +736,7 @@ static int wm8961_set_sysclk(struct snd_
 		freq /= 2;
 	} else {
 		dev_dbg(codec->dev, "Using MCLK/1 for %dHz MCLK\n", freq);
-		reg &= WM8961_MCLKDIV;
+		reg &= ~WM8961_MCLKDIV;
 	}
 
 	snd_soc_write(codec, WM8961_CLOCKING1, reg);
