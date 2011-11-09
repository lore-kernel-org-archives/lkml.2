Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab1KJE2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:28:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1KJE1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 23:27:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:11 2011
Message-Id: <20111109212711.277969441@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Susan Gao <sgao@opensource.wolfsonmicro.com>
Subject: [106/262] ASoC: Fix a bug in WM8962 DSP_A and DSP_B settings
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Susan Gao <sgao@opensource.wolfsonmicro.com>

commit fbc7c62a3ff831aef24894b7982cd1adb2b7e070 upstream.

Signed-off-by: Susan Gao <sgao@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmico.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8962.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3028,9 +3028,9 @@ static int wm8962_set_dai_fmt(struct snd
 	int aif0 = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
-	case SND_SOC_DAIFMT_DSP_A:
-		aif0 |= WM8962_LRCLK_INV;
 	case SND_SOC_DAIFMT_DSP_B:
+		aif0 |= WM8962_LRCLK_INV | 3;
+	case SND_SOC_DAIFMT_DSP_A:
 		aif0 |= 3;
 
 		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {


