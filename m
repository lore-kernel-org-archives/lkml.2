Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1I1OCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:02:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43859 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1I1OCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:02:18 -0400
Subject: [PATCH 2/2] ASoC: Add BUG() assertion if max98095_get_bq_channel
 returns -EINVAL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
In-Reply-To: <1317218471.8008.3.camel@phoenix>
References: <1317218471.8008.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 22:02:10 +0800
Message-ID: <1317218530.8008.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers use the return value of max98095_get_bq_channel as array index to
access max98095->dai[] array.
Add BUG() assertion for out of bound access of max98095->dai[] array.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/max98095.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 668434d..973c02d 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1998,6 +1998,7 @@ static int max98095_get_bq_channel(const char *name)
 		return 0;
 	if (strcmp(name, "Biquad2 Mode") == 0)
 		return 1;
+	BUG();
 	return -EINVAL;
 }
 
-- 
1.7.4.1



