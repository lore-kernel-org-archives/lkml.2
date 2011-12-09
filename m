Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1LIB6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:58:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47365 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1LIB6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:58:00 -0500
Message-ID: <1323395873.3740.4.camel@phoenix>
Subject: [PATCH 1/3] video: convert mbxfb to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Date: Fri, 09 Dec 2011 09:57:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts mbxfb to use the module_platform_driver() macro
which makes the code smaller and a bit simpler.

Cc: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/mbx/mbxfb.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 6ce3416..55bf619 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -1053,18 +1053,7 @@ static struct platform_driver mbxfb_driver = {
 	},
 };
 
-int __devinit mbxfb_init(void)
-{
-	return platform_driver_register(&mbxfb_driver);
-}
-
-static void __devexit mbxfb_exit(void)
-{
-	platform_driver_unregister(&mbxfb_driver);
-}
-
-module_init(mbxfb_init);
-module_exit(mbxfb_exit);
+module_platform_driver(mbxfb_driver);
 
 MODULE_DESCRIPTION("loadable framebuffer driver for Marathon device");
 MODULE_AUTHOR("Mike Rapoport, Compulab");
-- 
1.7.5.4



