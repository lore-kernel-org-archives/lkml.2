Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab0KPIE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:04:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42672 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0KPIEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nA8Ww+q8gQXWryfKpaZ4CB5T/wAwdapyyuTG8kgDSM+XB1eShi9zHqhJlAnK5YeLDd
         Z0X6TFjSPCi9Et7PAn1thf68mWip8sNXjaBKoFukjA8X83kKt+hXClBSsNS2Htn2yz5V
         X183xCnN+YyXM7O28WYG/VrTvh3AF4REGp6Is=
Subject: [PATCH 2/5] ASoC: Fix incorrect kfree in ad193x_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>
In-Reply-To: <1289894880.19543.5.camel@mola>
References: <1289894800.19543.2.camel@mola>  <1289894880.19543.5.camel@mola>
Content-Type: text/plain
Date: Tue, 16 Nov 2010 16:08:51 +0800
Message-Id: <1289894931.19543.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocated memory for ad193x in ad193x_spi_probe,
and will free the memory in either ad193x_spi_probe error path or
ad193x_spi_remove.

Thus we should not call kfree(ad193x) in ad193x_probe, otherwise
we have double free of ad193x.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad193x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index dc105d8..fd3e659 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -364,7 +364,6 @@ static int ad193x_probe(struct snd_soc_codec *codec)
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to set cache I/O: %d\n",
 				ret);
-		kfree(ad193x);
 		return ret;
 	}
 
-- 
1.7.2



