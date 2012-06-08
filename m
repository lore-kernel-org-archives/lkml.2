Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405Ab2FHW1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:27:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41913 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2FHWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:24:55 -0400
From: mathieu.poirier@linaro.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH RESEND 1/6] drivers/video: use correct __devexit_p annotation
Date: Fri,  8 Jun 2012 16:24:35 -0600
Message-Id: <1339194280-27475-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
References: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

__devexit functions are discarded when CONFIG_HOTPLUG
is not set, so the symbol needs to be referenced carefully.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/video/broadsheetfb.c |    2 +-
 drivers/video/mbx/mbxfb.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
index 377dde3..c95b417 100644
--- a/drivers/video/broadsheetfb.c
+++ b/drivers/video/broadsheetfb.c
@@ -1211,7 +1211,7 @@ static int __devexit broadsheetfb_remove(struct platform_device *dev)
 
 static struct platform_driver broadsheetfb_driver = {
 	.probe	= broadsheetfb_probe,
-	.remove = broadsheetfb_remove,
+	.remove = __devexit_p(broadsheetfb_remove),
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "broadsheetfb",
diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index ab0a8e5..85e4f44 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -1045,7 +1045,7 @@ static int __devexit mbxfb_remove(struct platform_device *dev)
 
 static struct platform_driver mbxfb_driver = {
 	.probe = mbxfb_probe,
-	.remove = mbxfb_remove,
+	.remove = __devexit_p(mbxfb_remove),
 	.suspend = mbxfb_suspend,
 	.resume = mbxfb_resume,
 	.driver = {
-- 
1.7.5.4

