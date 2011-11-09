Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522Ab1KJDnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:43:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965130Ab1KJDm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:42:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:54 2011
Message-Id: <20111109213154.483378880@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [123/264] ASoC: ak4642: fixup cache register table
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,17 +162,17 @@ struct ak4642_priv {
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


