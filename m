Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab1LGQSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:18:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab1LGQSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:24 2011
Message-Id: <20111207160824.537050013@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:43 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [23/80] ASoC: Ensure WM8731 register cache is synced when resuming from disabled
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit ed3e80c4c991a52f9fce3421536a78e331ae0949 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8731.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -463,6 +463,7 @@ static int wm8731_set_bias_level(struct
 		snd_soc_write(codec, WM8731_PWR, 0xffff);
 		regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies),
 				       wm8731->supplies);
+		codec->cache_sync = 1;
 		break;
 	}
 	codec->dapm.bias_level = level;


