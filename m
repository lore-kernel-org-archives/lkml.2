Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab0KPIFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:05:16 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33906 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0KPIFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:05:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j/7sTov3yr2QorCwR+DJRBNFRxn0jAyEc3Yx3LMBCBvT/w6Nq0RLx9lAfXYChriEZ9
         fCDmv0uVZx1lVG1YQWehMBP3tdET7MMNJEQTE9kw8zw8b9xdH2HmO6/lsE1Fkwl4Rcwy
         yhO4gM/iMbDdH9qFo6bv82RlFaod1MxvGlaI0=
Subject: [PATCH 3/5] ASoC: Fix incorrect kfree in aic3x_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vladimir Barinov <vbarinov@embeddedalley.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1289894931.19543.6.camel@mola>
References: <1289894800.19543.2.camel@mola>  <1289894880.19543.5.camel@mola>
	 <1289894931.19543.6.camel@mola>
Content-Type: text/plain
Date: Tue, 16 Nov 2010 16:09:41 +0800
Message-Id: <1289894981.19543.8.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocated memory for aic3x in aic3x_i2c_probe,
and will free the memory in either aic3x_i2c_probe error path or
aic3x_i2c_remove.

Thus we should not call kfree(aic3x) in aic3x_probe, otherwise
we have double free of aic3x.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320aic3x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 6173c2b..df726a5 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1419,7 +1419,6 @@ err_get:
 	if (aic3x->gpio_reset >= 0)
 		gpio_free(aic3x->gpio_reset);
 err_gpio:
-	kfree(aic3x);
 	return ret;
 }
 
-- 
1.7.2



