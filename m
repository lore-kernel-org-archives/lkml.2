Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab2DVJ5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 05:57:51 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47854 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2DVJ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 05:57:48 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kernel-janitors@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/xen-fbfront.c: add missing cleanup code
Date: Sun, 22 Apr 2012 11:57:40 +0200
Message-Id: <1335088660-13219-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The operations in the subsequent error-handling code appear to be also
useful here.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/video/xen-fbfront.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index cb4529c..b0bd59c 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -458,8 +458,13 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	xenfb_init_shared_page(info, fb_info);
 
 	ret = xenfb_connect_backend(dev, info);
-	if (ret < 0)
+	if (ret < 0) {
+		fb_deferred_io_cleanup(fb_info);
+		fb_dealloc_cmap(&fb_info->cmap);
+		framebuffer_release(fb_info);
+		xenbus_dev_fatal(dev, ret, "xenfb_connect_backend");
 		goto error;
+	}
 
 	ret = register_framebuffer(fb_info);
 	if (ret) {

