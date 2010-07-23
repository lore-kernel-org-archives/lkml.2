Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0GWFyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40683 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab0GWFyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=efLEzue1ZJXCRUMtHqBC5JbGGdnYUyHZUDR1w04m2M4KjOR677DxvunoAuaIlFfcnU
         vgZmH+ufjzRBdt7yGn1cHZajCShrzl+Yz2E70nh3iGJynWCcd1e3q8KaIvd39y0NWsaq
         fBeLHsIeUhiMHx6/X0NGOLrt8+YbslX8MmRsA=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 01/12] ad1836: fix a memory leak if another ad1836 is registered
Date: Fri, 23 Jul 2010 05:53:43 +0000
Message-Id: <1279864434-8010-2-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ad1836 is allocated in ad1836_spi_probe() but is not freed if ad1836_register()
return -EINVAL (if another ad1836 is registered).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Barry Song <21cnbao@gmail.com>
---
 sound/soc/codecs/ad1836.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index 2175384..a01006c 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -272,6 +272,7 @@ static int ad1836_register(struct ad1836_priv *ad1836)
 
 	if (ad1836_codec) {
 		dev_err(codec->dev, "Another ad1836 is registered\n");
+		kfree(ad1836);
 		return -EINVAL;
 	}
 
-- 
1.7.0.4

