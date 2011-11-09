Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1KJFPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:15:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981Ab1KJDZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:25:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:10 2011
Message-Id: <20111109212710.722818484@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [101/262] ASoC: wm8741: Fix setting interface format for DSP modes
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 3a340104fad6ecbea5ad6792a2ea855f0507a6e0 upstream.

According to the datasheet:
Format Control (05h)
BITS[3:2]
        FMT[1:0] Audio data format selection
                00 = right justified mode
                01 = left justified mode
                10 = I2S mode
                11 = DSP mode
BIT[4]  LRP Polarity selec for LRCLK/DSP mode select
                0 = normal LRCLK poalrity/DSP mode A
                1 = inverted LRCLK poarity/DSP mode B

For SND_SOC_DAIFMT_DSP_A, we should set 0x000C instead of 0x0003.
For SND_SOC_DAIFMT_DSP_B, we should set 0x001C instead of 0x0013.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8741.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -337,10 +337,10 @@ static int wm8741_set_dai_fmt(struct snd
 		iface |= 0x0004;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		iface |= 0x0003;
+		iface |= 0x000C;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
-		iface |= 0x0013;
+		iface |= 0x001C;
 		break;
 	default:
 		return -EINVAL;


