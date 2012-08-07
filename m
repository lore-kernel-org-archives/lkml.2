Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab2HGWhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:37:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2HGWhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 019/109] ASoC: wm8962: Redo early init of the part on resume
Date: Tue,  7 Aug 2012 15:34:38 -0700
Message-Id: <20120807222044.775555518@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit e4dd76788c7e5b27165890d712c8c4f6f0abd645 upstream.

Ensure robust startup of the part by going through the reset procedure
prior to resyncing the full register cache, avoiding potential intermittent
faults in some designs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8962.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3710,6 +3710,9 @@ static int wm8962_runtime_resume(struct
 	}
 
 	regcache_cache_only(wm8962->regmap, false);
+
+	wm8962_reset(wm8962);
+
 	regcache_sync(wm8962->regmap);
 
 	regmap_update_bits(wm8962->regmap, WM8962_ANTI_POP,


