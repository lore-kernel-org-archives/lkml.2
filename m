Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2KVWe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:34:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:49004 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab2KVSdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Millbrandt <emillbrandt@dekaresearch.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 08/38] ASoC: wm8978: pll incorrectly configured when codec is master
Date: Wed, 21 Nov 2012 16:39:51 -0800
Message-Id: <20121122003905.132611222@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Millbrandt <emillbrandt@dekaresearch.com>

commit 55c6f4cb6ef49afbb86222c6a3ff85329199c729 upstream.

When MCLK is supplied externally and BCLK and LRC are configured as outputs
(codec is master), the PLL values are only calculated correctly on the first
transmission.  On subsequent transmissions, at differenct sample rates, the
wrong PLL values are used.  Test for f_opclk instead of f_pllout to determine
if the PLL values are needed.

Signed-off-by: Eric Millbrandt <emillbrandt@dekaresearch.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8978.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -750,7 +750,7 @@ static int wm8978_hw_params(struct snd_p
 		wm8978->mclk_idx = -1;
 		f_sel = wm8978->f_mclk;
 	} else {
-		if (!wm8978->f_pllout) {
+		if (!wm8978->f_opclk) {
 			/* We only enter here, if OPCLK is not used */
 			int ret = wm8978_configure_pll(codec);
 			if (ret < 0)


