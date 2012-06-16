Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab2FPWFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 18:05:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62622 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2FPWFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 18:05:00 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 10/10] fblog: add "activate" module parameter
Date: Sun, 17 Jun 2012 00:04:26 +0200
Message-Id: <1339884266-9201-11-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new parameter controls whether fblog is automatically activated when
it is loaded. This defaults to "true".

We can now compile with CONFIG_VT=n and CONFIG_FBLOG=y and control fblog
with fblog.activate=0/1 on the kernel command line to enable/disable
debugging.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 9d3b072..cabc550 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -94,6 +94,7 @@ struct fblog_fb {
 static struct fblog_fb *fblog_fbs[FB_MAX];
 static struct device *fblog_device;
 static atomic_t fblog_active;
+static bool activate = 1;
 
 static void fblog_buf_resize(struct fblog_buf *buf, size_t width,
 			     size_t height)
@@ -653,6 +654,12 @@ static int __init fblog_init(void)
 
 	register_console(&fblog_con_driver);
 
+	if (activate) {
+		console_lock();
+		fblog_activate();
+		console_unlock();
+	}
+
 	return 0;
 
 err_fb:
@@ -677,6 +684,9 @@ static void __exit fblog_exit(void)
 	put_device(fblog_device);
 }
 
+module_param(activate, bool, S_IRUGO);
+MODULE_PARM_DESC(activate, "Activate fblog by default");
+
 module_init(fblog_init);
 module_exit(fblog_exit);
 MODULE_LICENSE("GPL");
-- 
1.7.10.4

