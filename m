Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2JBIHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:07:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59098 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2JBIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:07:09 -0400
Date: Tue, 2 Oct 2012 17:06:55 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Joonsoo Kim <js1304@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        emilgoode@gmail.com,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: [PATCH] HID: picoLCD: Remove use of deprecated function
Message-ID: <20121002080655.GA8717@localhost>
References: <20121002070010.GB6144@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121002070010.GB6144@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Goode <emilgoode@gmail.com>

The flush_delayed_work_sync function is deprecated,
we can instead call flush_delayed_work directly.

Sparse is giving a warning:
drivers/hid/hid-picolcd_fb.c:611:2: warning:
	‘flush_delayed_work_sync’ is deprecated
	(declared at include/linux/workqueue.h:454)
	[-Wdeprecated-declarations]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
---
This can be applied as part of the merge or on top after merge.

Thanks.

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
