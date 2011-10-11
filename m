Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1JKRGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:06:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:05:57 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:10 2011
Message-Id: <20111011165710.281098946@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:23 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [13/38] ASoC: use a valid device for dev_err() in Zylonite
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit eff919ac0fc7565e71ffa35657c333dd8cdc0520 upstream.

A recent conversion has introduced references to &pdev->dev, which does
not actually exist in all the contexts it's used in.

Replace this with card->dev where necessary, in order to let
the driver build again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/pxa/zylonite.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/pxa/zylonite.c
+++ b/sound/soc/pxa/zylonite.c
@@ -196,20 +196,20 @@ static int zylonite_probe(struct snd_soc
 	if (clk_pout) {
 		pout = clk_get(NULL, "CLK_POUT");
 		if (IS_ERR(pout)) {
-			dev_err(&pdev->dev, "Unable to obtain CLK_POUT: %ld\n",
+			dev_err(card->dev, "Unable to obtain CLK_POUT: %ld\n",
 				PTR_ERR(pout));
 			return PTR_ERR(pout);
 		}
 
 		ret = clk_enable(pout);
 		if (ret != 0) {
-			dev_err(&pdev->dev, "Unable to enable CLK_POUT: %d\n",
+			dev_err(card->dev, "Unable to enable CLK_POUT: %d\n",
 				ret);
 			clk_put(pout);
 			return ret;
 		}
 
-		dev_dbg(&pdev->dev, "MCLK enabled at %luHz\n",
+		dev_dbg(card->dev, "MCLK enabled at %luHz\n",
 			clk_get_rate(pout));
 	}
 
@@ -241,7 +241,7 @@ static int zylonite_resume_pre(struct sn
 	if (clk_pout) {
 		ret = clk_enable(pout);
 		if (ret != 0)
-			dev_err(&pdev->dev, "Unable to enable CLK_POUT: %d\n",
+			dev_err(card->dev, "Unable to enable CLK_POUT: %d\n",
 				ret);
 	}
 


