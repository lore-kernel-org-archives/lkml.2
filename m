Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0HXW6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:07 -0400
Received: from kroah.org ([198.145.64.141]:52410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab0HXW6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:04 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:12 2010
Message-Id: <20100824224212.494693867@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cliff Cai <cliff.cai@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [05/91] ASoC: register cache should be 1 byte aligned for 1 byte long register
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Cai <cliff.cai@analog.com>

commit ac770267a7cd85a747b6111db46f66d1515e7cd7 upstream.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/soc-cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-cache.c
+++ b/sound/soc/soc-cache.c
@@ -296,7 +296,7 @@ static unsigned int snd_soc_16_8_read_i2
 static unsigned int snd_soc_16_8_read(struct snd_soc_codec *codec,
 				     unsigned int reg)
 {
-	u16 *cache = codec->reg_cache;
+	u8 *cache = codec->reg_cache;
 
 	reg &= 0xff;
 	if (reg >= codec->reg_cache_size)
@@ -307,7 +307,7 @@ static unsigned int snd_soc_16_8_read(st
 static int snd_soc_16_8_write(struct snd_soc_codec *codec, unsigned int reg,
 			     unsigned int value)
 {
-	u16 *cache = codec->reg_cache;
+	u8 *cache = codec->reg_cache;
 	u8 data[3];
 	int ret;
 


