Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1KTQyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 11:54:36 -0500
Received: from smtp24.mail.ru ([94.100.176.177]:56070 "EHLO smtp24.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab1KTQyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 11:54:33 -0500
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] omap3isp: fix compilation of ispvideo.c
Date: Sun, 20 Nov 2011 20:54:26 +0400
Message-Id: <1321808066-1791-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following build error by explicitely including <linux/module.h>
header file.

  CC      drivers/media/video/omap3isp/ispvideo.o
drivers/media/video/omap3isp/ispvideo.c:1267: error: 'THIS_MODULE' undeclared here (not in a function)
make[4]: *** [drivers/media/video/omap3isp/ispvideo.o] Error 1
make[3]: *** [drivers/media/video/omap3isp] Error 2
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/media/video/omap3isp/ispvideo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d100072..f229057 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -26,6 +26,7 @@
 #include <asm/cacheflush.h>
 #include <linux/clk.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
-- 
1.7.4.rc3

