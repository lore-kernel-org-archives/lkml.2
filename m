Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab0KPIGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:06:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37437 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0KPIGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:06:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gBOsjjIJDNjqJFfrzDqc4BM/VD96WkuMLD9NlpawTzyHBL50IK7+klaYBys5dudmVS
         7ehpMIgbTcX4d4QaUky0VD5tJXzoaCg65jnCvqF5Mp6rSOa9vgc8jHIrmoWfS6KCzAqE
         ggvcCiTrGy/GxclbmUc2HSOm57cX/JWCK0iRs=
Subject: [PATCH 4/5] ASoC: Fix incorrect kfree in wm8731_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <richard@openedhand.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1289894981.19543.8.camel@mola>
References: <1289894800.19543.2.camel@mola>  <1289894880.19543.5.camel@mola>
	 <1289894931.19543.6.camel@mola>  <1289894981.19543.8.camel@mola>
Content-Type: text/plain
Date: Tue, 16 Nov 2010 16:10:41 +0800
Message-Id: <1289895041.19543.10.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocated memory for wm8731 in wm8731_spi_probe / wm8731_i2c_probe,
and will free the memory in either wm8731_spi_probe / wm8731_i2c_probe
error path or wm8731_spi_remove / wm8731_i2c_remove.

Thus we should not call kfree(wm8731) in wm8731_probe, otherwise
we have double free of wm8731.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8731.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 95ade32..4b70958 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -543,7 +543,6 @@ err_regulator_enable:
 err_regulator_get:
 	regulator_bulk_free(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
 
-	kfree(wm8731);
 	return ret;
 }
 
-- 
1.7.2



