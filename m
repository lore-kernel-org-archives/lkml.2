Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1KCBgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:36:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab1KCBgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:57 2011
Message-Id: <20111102221456.973968609@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [075/107] ASoC: ak4642: fixup cache register table
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 19b115e523208a926813751aac8934cf3fc6085e upstream.

ak4642 register was 8bit, but cache table was defined as 16bit.
ak4642 doesn't work correctry without this patch.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ak4642.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -93,17 +93,17 @@ static struct snd_soc_codec *ak4642_code
 /*
  * ak4642 register cache
  */
-static const u16 ak4642_reg[AK4642_CACHEREGNUM] = {
-	0x0000, 0x0000, 0x0001, 0x0000,
-	0x0002, 0x0000, 0x0000, 0x0000,
-	0x00e1, 0x00e1, 0x0018, 0x0000,
-	0x00e1, 0x0018, 0x0011, 0x0008,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000,
+static const u8 ak4642_reg[AK4642_CACHEREGNUM] = {
+	0x00, 0x00, 0x01, 0x00,
+	0x02, 0x00, 0x00, 0x00,
+	0xe1, 0xe1, 0x18, 0x00,
+	0xe1, 0x18, 0x11, 0x08,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00,
 };
 
 /*


