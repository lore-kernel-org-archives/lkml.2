Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966873Ab2EOVDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:03:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60949 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966830Ab2EOVDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:03:09 -0400
From: mathieu.poirier@linaro.org
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 1/5] drivers/video: use correct __devexit_p annotation
Date: Tue, 15 May 2012 15:02:57 -0600
Message-Id: <1337115781-27979-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
References: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
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
index 55bf619..56550ec 100644
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

