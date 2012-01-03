Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2ACWi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab2ACWix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:22 2012
Message-Id: <20120103223322.187540393@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [14/75] ASoC: Fix WM8996 24.576MHz clock operation
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 37d5993c5cc9bc83762ae1b5bd287438022e8afe upstream.

Record the clock after the divider as that is what all SYSCLK users see.
Without this the other clock configuration in the device comes out at
half rate.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8996.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -1895,6 +1895,7 @@ static int wm8996_set_sysclk(struct snd_
 		break;
 	case 24576000:
 		ratediv = WM8996_SYSCLK_DIV;
+		wm8996->sysclk /= 2;
 	case 12288000:
 		snd_soc_update_bits(codec, WM8996_AIF_RATE,
 				    WM8996_SYSCLK_RATE, WM8996_SYSCLK_RATE);


