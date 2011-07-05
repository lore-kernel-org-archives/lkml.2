Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1GEFA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:00:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63307 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1GEFA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:00:26 -0400
Subject: [PATCH] backlight: ams369fg06: Staticize ams369fg06_shutdown
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jingoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 13:00:14 +0800
Message-ID: <1309842014.10981.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only used in ams369fg06.c, no need for it to be in the global namespace.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/ams369fg06.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 201a593..59fab88 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -608,7 +608,7 @@ static int ams369fg06_resume(struct spi_device *spi)
 #define ams369fg06_resume	NULL
 #endif
 
-void ams369fg06_shutdown(struct spi_device *spi)
+static void ams369fg06_shutdown(struct spi_device *spi)
 {
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
-- 
1.7.4.1



