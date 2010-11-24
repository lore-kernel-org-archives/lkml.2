Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab0KXHPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:15:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40532 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0KXHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ekux9vjb4Cw8A5oiU8qSBPxYYbFs1D0uHU13gsCHqP26zNIQrtHPmT8F7jwpHwOFPT
         P5Iocqkphky2Tybe8deG8eUFze5zhKWl1TOJlob0zb/FB4SMIlLsSdfqFcWDub163O3m
         KUYjvXCAsv03I3oTJ7q4ADDbQBHEvBeg/m4zg=
Subject: [PATCH 1/2] ASoC: Return proper error for omap3pandora_soc_init
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Grazvydas Ignotas <notasas@gmail.com>, Jarkko Nikula <jhnikula@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Content-Type: text/plain
Date: Wed, 24 Nov 2010 15:20:48 +0800
Message-Id: <1290583248.20639.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return PTR_ERR(omap3pandora_dac_reg) instead of 0 if regulator_get failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/omap/omap3pandora.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/omap/omap3pandora.c b/sound/soc/omap/omap3pandora.c
index bff9864..8047c52 100644
--- a/sound/soc/omap/omap3pandora.c
+++ b/sound/soc/omap/omap3pandora.c
@@ -307,6 +307,7 @@ static int __init omap3pandora_soc_init(void)
 		pr_err(PREFIX "Failed to get DAC regulator from %s: %ld\n",
 			dev_name(&omap3pandora_snd_device->dev),
 			PTR_ERR(omap3pandora_dac_reg));
+		ret = PTR_ERR(omap3pandora_dac_reg);
 		goto fail3;
 	}
 
-- 
1.7.2



