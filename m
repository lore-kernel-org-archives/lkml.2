Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab1LNLty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:49:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1LNLtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:33 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 4/7] remoteproc/omap: utilize module_platform_driver
Date: Wed, 14 Dec 2011 13:48:32 +0200
Message-Id: <1323863315-8159-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ditch some boilerplate code by employing the module_platform_driver
helper.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/omap_remoteproc.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index b49ecbb..aa3ce52 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -232,18 +232,7 @@ static struct platform_driver omap_rproc_driver = {
 	},
 };
 
-/* most of the below will go when module_platform_driver is merged */
-static int __init omap_rproc_init(void)
-{
-	return platform_driver_register(&omap_rproc_driver);
-}
-module_init(omap_rproc_init);
-
-static void __exit omap_rproc_exit(void)
-{
-	platform_driver_unregister(&omap_rproc_driver);
-}
-module_exit(omap_rproc_exit);
+module_platform_driver(omap_rproc_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("OMAP Remote Processor control driver");
-- 
1.7.5.4

