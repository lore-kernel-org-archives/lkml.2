Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab2GUIzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 04:55:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33342 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2GUIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 04:55:03 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 1/2] staging/iio: use module_platform_driver macro
Date: Sat, 21 Jul 2012 14:39:55 +0545
Message-Id: <1342860895-19401-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code which under _init and _exit does only the platform_driver_register
and platform_driver_unregister, and nothing else,
so its better to use the module_platform_driver macro rather duplicating
its implementation

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---

 drivers/staging/iio/iio_hwmon.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/iio/iio_hwmon.c b/drivers/staging/iio/iio_hwmon.c
index 27d27ec..4bb017a 100644
--- a/drivers/staging/iio/iio_hwmon.c
+++ b/drivers/staging/iio/iio_hwmon.c
@@ -215,17 +215,7 @@ static struct platform_driver __refdata iio_hwmon_driver = {
 	.remove = __devexit_p(iio_hwmon_remove),
 };
 
-static int iio_inkern_init(void)
-{
-	return platform_driver_register(&iio_hwmon_driver);
-}
-module_init(iio_inkern_init);
-
-static void iio_inkern_exit(void)
-{
-	platform_driver_unregister(&iio_hwmon_driver);
-}
-module_exit(iio_inkern_exit);
+module_platform_driver(iio_hwmon_driver);
 
 MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
 MODULE_DESCRIPTION("IIO to hwmon driver");
-- 
1.7.9.5

