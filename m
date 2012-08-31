Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2HaNjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:39:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2HaNjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:39:14 -0400
Message-ID: <1346420343.3107.0.camel@phoenix>
Subject: [PATCH] video: mbxfb: Include linux/io.h instead of asm/io.h
From: Axel Lin <axel.lin@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Damien Cassou <damien.cassou@lifl.fr>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Aug 2012 21:39:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error:

  CC [M]  drivers/video/mbx/mbxfb.o
drivers/video/mbx/mbxfb.c: In function 'mbxfb_probe':
drivers/video/mbx/mbxfb.c:942:2: error: implicit declaration of function 'devm_ioremap_nocache' [-Werror=implicit-function-declaration]
drivers/video/mbx/mbxfb.c:942:22: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/video/mbx/mbxfb.c:952:21: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/mbx/mbxfb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 9229acf..6563e50 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -26,8 +26,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <video/mbxfb.h>
 
-- 
1.7.9.5




