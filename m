Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0LHBbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:31:35 -0500
Received: from kroah.org ([198.145.64.141]:49095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab0LHBBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:53 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.820222445@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [154/289] ASoC: wm8961 - clear WM8961_MCLKDIV bit for freq <= 16500000
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 sound/soc/codecs/wm8961.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -736,7 +736,7 @@ static int wm8961_set_sysclk(struct snd_
 		freq /= 2;
 	} else {
 		dev_dbg(codec->dev, "Using MCLK/1 for %dHz MCLK\n", freq);
-		reg &= WM8961_MCLKDIV;
+		reg &= ~WM8961_MCLKDIV;
 	}
 
 	snd_soc_write(codec, WM8961_CLOCKING1, reg);


