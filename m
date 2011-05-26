Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab1EZKgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:36:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:64103 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1EZKgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:36:15 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] sound: atmel_ssc_dai: fix ssc error path
Date: Thu, 26 May 2011 13:44:12 +0200
Message-Id: <6ad886bb3afb73fc9db55fd2e01bb453cfb3febd.1306409927.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1306410252-31534-1-git-send-email-nicolas.ferre@atmel.com>
References: <1306410252-31534-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <ff83ef6ea865da7cb32921154711e672293a7d83.1306409927.git.nicolas.ferre@atmel.com>
References: <ff83ef6ea865da7cb32921154711e672293a7d83.1306409927.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not have to free a resource that is not allocated yet.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/soc/atmel/atmel_ssc_dai.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 7fbfa05..a7a7bbc 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -838,10 +838,8 @@ int atmel_ssc_set_audio(int ssc_id)
 	}
 
 	ssc_pdev = platform_device_alloc("atmel-ssc-dai", ssc_id);
-	if (!ssc_pdev) {
-		ssc_free(ssc);
+	if (!ssc_pdev)
 		return -ENOMEM;
-	}
 
 	/* If we can grab the SSC briefly to parent the DAI device off it */
 	ssc = ssc_request(ssc_id);
-- 
1.7.3

