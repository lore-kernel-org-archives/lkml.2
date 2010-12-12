Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0LMALl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:11:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36163 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab0LLXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:49 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [107/223] ASoC: Remove volatility from WM8900 POWER1 register
Message-Id: <20101212234647.DE793B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 6d212d8e86fb4221bd91b9266b7567ee2b83bd01 upstream.

Not all bits can be read back from POWER1 so avoid corruption when using
a read/modify/write cycle by marking it non-volatile - the only thing we
read back from it is the chip revision which has diagnostic value only.
We can re-add later but that's a more invasive change than is suitable
for a bugfix.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm8900.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/sound/soc/codecs/wm8900.c
===================================================================
--- linux.orig/sound/soc/codecs/wm8900.c
+++ linux/sound/soc/codecs/wm8900.c
@@ -188,7 +188,6 @@ static int wm8900_volatile_register(unsi
 {
 	switch (reg) {
 	case WM8900_REG_ID:
-	case WM8900_REG_POWER1:
 		return 1;
 	default:
 		return 0;
@@ -1236,11 +1235,6 @@ static __devinit int wm8900_i2c_probe(st
 		goto err;
 	}
 
-	/* Read back from the chip */
-	reg = snd_soc_read(codec, WM8900_REG_POWER1);
-	reg = (reg >> 12) & 0xf;
-	dev_info(&i2c->dev, "WM8900 revision %d\n", reg);
-
 	wm8900_reset(codec);
 
 	/* Turn the chip on */
