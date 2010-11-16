Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab0KPIHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:07:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54707 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759469Ab0KPIHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gXIj8xvwN1UG2hqeljDzEBPq4g0OF7TTCgH+4dpzG45HhxsHeQiB6ER7J9Jfln+3Gb
         xqM3fNH/EfCiS+w6iuklTbn/BxH+dLsKATrc87c3l+U+aszpW0XKp1cV59LbnFnjyKNz
         I8UPNrV+tZwFaZY/TSUNnXBeuS3xmc9dyvAvI=
Subject: [PATCH 5/5] ASoC: Fix incorrect kfree in wm8962_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1289895041.19543.10.camel@mola>
References: <1289894800.19543.2.camel@mola>  <1289894880.19543.5.camel@mola>
	 <1289894931.19543.6.camel@mola>  <1289894981.19543.8.camel@mola>
	 <1289895041.19543.10.camel@mola>
Content-Type: text/plain
Date: Tue, 16 Nov 2010 16:11:37 +0800
Message-Id: <1289895097.19543.12.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocated memory for wm8962 in wm8962_i2c_probe,
and will free the memory in either wm8962_i2c_probe error path
or wm8962_i2c_remove.

Thus we should not call kfree(wm8962) in wm8962_probe, otherwise
we have double free of wm8962.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8962.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index e021866..9f6beca 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3874,7 +3874,6 @@ err_enable:
 err_get:
 	regulator_bulk_free(ARRAY_SIZE(wm8962->supplies), wm8962->supplies);
 err:
-	kfree(wm8962);
 	return ret;
 }
 
-- 
1.7.2



