Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0HYI4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:56:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41214 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0HYIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SPthjakah96tLh3XIjgYTD1JCusGM0VdVpmmHWGwRieSYZBt8sdAnRJBIF4wrOswA6
         9EsmgCA5h4w1NZ0pLKGGSBWevtLKPcqBW/HSxCxsmVCJ5Jg9KhhyrJd67oXGCyEe6N6/
         pn15rGtkrQhx64H6iMcyBdcxtjG1g7KJidn1Y=
Subject: [PATCH] ASoC: pxa-ssp: fix a memory leak in pxa_ssp_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 25 Aug 2010 16:59:11 +0800
Message-Id: <1282726751.5051.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "priv" allocated in pxa_ssp_probe() should be kfreed in pxa_ssp_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against 2.6.36-rc2-git3.
 sound/soc/pxa/pxa-ssp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index a1fd23e..2a9cac7 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -760,6 +760,7 @@ static void pxa_ssp_remove(struct platform_device *pdev,
 {
 	struct ssp_priv *priv = dai->private_data;
 	pxa_ssp_free(priv->ssp);
+	kfree(priv);
 }
 
 #define PXA_SSP_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
-- 
1.7.2



