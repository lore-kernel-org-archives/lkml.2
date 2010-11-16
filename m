Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab0KPIDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:03:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45062 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0KPIDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OU9s1bI+4ATYf5FBf4ppE+FmLulFpiNSFSJRxkPi3uq+YMqOYLpdzIW5nelzDeBPVH
         VIXDIbSavSr5ewl69u+ma8JHog+GwfakbUsYILjDsRF4vVDxaGe2TFAP/C0Lya5lsGPx
         mAd0oHiUG9dwyoR2CW/6EZMX0TOQxu3WH+j9c=
Subject: [PATCH 1/5] ASoC: Fix incorrect kfree in ad1836_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>
In-Reply-To: <1289894800.19543.2.camel@mola>
References: <1289894800.19543.2.camel@mola>
Content-Type: text/plain
Date: Tue, 16 Nov 2010 16:08:00 +0800
Message-Id: <1289894880.19543.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocated memory for ad1836 in ad1836_spi_probe,
and will free the memory in either ad1836_spi_probe error path or
ad1836_spi_remove.

Thus we should not call kfree(ad1836) in ad1836_probe, otherwise
we have double free of ad1836.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad1836.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index c71b05d..e5d3db9 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -228,7 +228,6 @@ static int ad1836_probe(struct snd_soc_codec *codec)
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to set cache I/O: %d\n",
 				ret);
-		kfree(ad1836);
 		return ret;
 	}
 
-- 
1.7.2



