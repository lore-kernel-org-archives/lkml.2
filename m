Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966848Ab2EOVDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:03:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50986 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966831Ab2EOVDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:03:10 -0400
From: mathieu.poirier@linaro.org
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 2/5] video/ili9320: do not mark exported functions __devexit
Date: Tue, 15 May 2012 15:02:58 -0600
Message-Id: <1337115781-27979-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
References: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

No symbol can be exported when the section is discarded - the only
solution I could think of is not to mark symbols as __devexit
when they are exported.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/video/backlight/ili9320.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 5118a9f..b67485a 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -267,7 +267,7 @@ int __devinit ili9320_probe_spi(struct spi_device *spi,
 
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
-int __devexit ili9320_remove(struct ili9320 *ili)
+int ili9320_remove(struct ili9320 *ili)
 {
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
 
-- 
1.7.5.4

