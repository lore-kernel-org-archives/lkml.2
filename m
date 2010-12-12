Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0LLXqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36175 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0LLXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:50 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: axel.lin@gmail.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [108/223] ASoC: wm8961 - clear WM8961_DACSLOPE bit for normal mode
Message-Id: <20101212234648.EBFC5B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Axel Lin <axel.lin@gmail.com>

commit 08b1a38465cab8c2224a5202c7a3b5e5f5630894 upstream.

DACSLOPE bit of Register 06h ADC and DAC Control 2:
        0: Normal mode
        1: Sloping stop-band mode

Thus in the case of normal mode, we should clear DACSLOPE bit.

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
@@ -711,7 +711,7 @@ static int wm8961_hw_params(struct snd_p
 	if (fs <= 24000)
 		reg |= WM8961_DACSLOPE;
 	else
-		reg &= WM8961_DACSLOPE;
+		reg &= ~WM8961_DACSLOPE;
 	snd_soc_write(codec, WM8961_ADC_DAC_CONTROL_2, reg);
 
 	return 0;
