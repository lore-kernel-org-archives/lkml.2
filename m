Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1I1OBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:01:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48318 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1I1OBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:01:19 -0400
Subject: [PATCH 1/2] ASoC: Add BUG() assertion if max98088_get_channel
 returns -EINVAL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 22:01:11 +0800
Message-ID: <1317218471.8008.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers use the return value of max98088_get_channel as array index to
access max98088->dai[] array.
Add BUG() assertion for out of bound access of max98088->dai[] array.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/max98088.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index ac65a2d..aaca91c 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1703,6 +1703,7 @@ static int max98088_get_channel(const char *name)
                return 0;
        if (strcmp(name, "EQ2 Mode") == 0)
                return 1;
+	BUG();
        return -EINVAL;
 }
 
-- 
1.7.4.1



