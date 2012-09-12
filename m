Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2ILFjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:39:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44454 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2ILFjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:39:19 -0400
Message-ID: <1347428349.14558.1.camel@phoenix>
Subject: [PATCH] HID: picolcd_fb: Use flush_delayed_work instead of
 flush_delayed_work_sync
From: Axel Lin <axel.lin@gmail.com>
To: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>
Cc: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Sep 2012 13:39:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems this is a left over of commit 4382973
"workqueue: deprecate flush[_delayed]_work_sync()"

This fixes below build warning:

  CC [M]  drivers/hid/hid-picolcd_fb.o
drivers/hid/hid-picolcd_fb.c: In function 'picolcd_exit_framebuffer':
drivers/hid/hid-picolcd_fb.c:611:2: warning: 'flush_delayed_work_sync' is deprecated (declared at include/linux/workqueue.h:454) [-Wdeprecated-declarations]

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
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
1.7.9.5



