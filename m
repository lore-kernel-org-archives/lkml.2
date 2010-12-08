Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab0LHBb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:31:57 -0500
Received: from kroah.org ([198.145.64.141]:49086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab0LHBBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:50 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.609118729@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [152/289] ASoC: Remove volatility from WM8900 POWER1 register
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 sound/soc/codecs/wm8900.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
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


