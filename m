Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2HDMAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:00:45 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:62212 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292Ab2HDMAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:00:42 -0400
X-IronPort-AV: E=Sophos;i="4.77,711,1336341600"; 
   d="scan'208";a="169070474"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/video/auo_k190x.c: drop kfree of devm_kzalloc's data
Date: Sat,  4 Aug 2012 14:00:30 +0200
Message-Id: <1344081632-4729-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Using kfree to free data allocated with devm_kzalloc causes double frees.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x;
@@

x = devm_kzalloc(...)
...
?-kfree(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/auo_k190x.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/auo_k190x.c b/drivers/video/auo_k190x.c
index 77da6a2..c03ecdd 100644
--- a/drivers/video/auo_k190x.c
+++ b/drivers/video/auo_k190x.c
@@ -987,7 +987,6 @@ err_regfb:
 	fb_dealloc_cmap(&info->cmap);
 err_cmap:
 	fb_deferred_io_cleanup(info);
-	kfree(info->fbdefio);
 err_defio:
 	vfree((void *)info->screen_base);
 err_irq:
@@ -1022,7 +1021,6 @@ int  __devexit auok190x_common_remove(struct platform_device *pdev)
 	fb_dealloc_cmap(&info->cmap);
 
 	fb_deferred_io_cleanup(info);
-	kfree(info->fbdefio);
 
 	vfree((void *)info->screen_base);
 

