Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab1KWBAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:00:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab1KWAeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:34:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:07 2011
Message-Id: <20111123002207.838135103@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:20:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [09/25] ASoC: wm8940: Properly set codec->dapm.bias_level
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 624
Lines: 24

From: Axel Lin <axel.lin@gmail.com>

commit 5927f94700e860ae27ff24e7f3bc9e4f7b9922eb upstream.

Reported-by: Chris Paulson-Ellis <chris@edesix.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8940.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -472,6 +472,7 @@ static int wm8940_set_bias_level(struct
 		ret = snd_soc_write(codec, WM8940_POWER1, pwr_reg);
 		break;
 	}
+	codec->bias_level = level;
 
 	return ret;
 }


