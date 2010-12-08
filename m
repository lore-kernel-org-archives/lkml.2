Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab0LHBBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:54 -0500
Received: from kroah.org ([198.145.64.141]:49089 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab0LHBBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:52 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.713434271@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [153/289] ASoC: wm8961 - clear WM8961_DACSLOPE bit for normal mode
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 sound/soc/codecs/wm8961.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -711,7 +711,7 @@ static int wm8961_hw_params(struct snd_p
 	if (fs <= 24000)
 		reg |= WM8961_DACSLOPE;
 	else
-		reg &= WM8961_DACSLOPE;
+		reg &= ~WM8961_DACSLOPE;
 	snd_soc_write(codec, WM8961_ADC_DAC_CONTROL_2, reg);
 
 	return 0;


