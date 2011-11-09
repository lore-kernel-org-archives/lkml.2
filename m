Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936176Ab1KJDy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:54:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934325Ab1KJDsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:04 2011
Message-Id: <20111109213204.734601112@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [221/264] ASoC: Ensure WM8962 PLL registers are reset
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 4f4488abc97c1c27ff029f887944e6a6da1f5733 upstream.

The WM8962 has a separate software reset for the PLL registers. Ensure that
these are reset also on startup.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8962.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1959,7 +1959,13 @@ static int wm8962_readable_register(stru
 
 static int wm8962_reset(struct snd_soc_codec *codec)
 {
-	return snd_soc_write(codec, WM8962_SOFTWARE_RESET, 0x6243);
+	int ret;
+
+	ret = snd_soc_write(codec, WM8962_SOFTWARE_RESET, 0x6243);
+	if (ret != 0)
+		return ret;
+
+	return snd_soc_write(codec, WM8962_PLL_SOFTWARE_RESET, 0);
 }
 
 static const DECLARE_TLV_DB_SCALE(inpga_tlv, -2325, 75, 0);


