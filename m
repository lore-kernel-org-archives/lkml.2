Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2IFOnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:43:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54694 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab2IFOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:43:03 -0400
From: Emil Goode <emilgoode@gmail.com>
To: bonbons@linux-vserver.org, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] HID: picoLCD: Remove use of deprecated function
Date: Thu,  6 Sep 2012 16:46:20 +0200
Message-Id: <1346942780-8091-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flush_delayed_work_sync function is deprecated,
we can instead call flush_delayed_work directly.

Sparse is giving a warning:
drivers/hid/hid-picolcd_fb.c:611:2: warning:
	‘flush_delayed_work_sync’ is deprecated
	(declared at include/linux/workqueue.h:454)
	[-Wdeprecated-declarations]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/hid/hid-picolcd_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index 0008a51..eb00357 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -608,7 +608,7 @@ void picolcd_exit_framebuffer(struct picolcd_data *data)
 	/* make sure there is no running update - thus that fbdata->picolcd
 	 * once obtained under lock is guaranteed not to get free() under
 	 * the feet of the deferred work */
-	flush_delayed_work_sync(&info->deferred_work);
+	flush_delayed_work(&info->deferred_work);
 
 	data->fb_info = NULL;
 	unregister_framebuffer(info);
-- 
1.7.10.4

