Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab1FPMQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:16:08 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55435 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757771Ab1FPMP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:15:56 -0400
Date: Thu, 16 Jun 2011 14:15:54 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: Pete Zaitcev <zaitcev@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 11/11] usb/class: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <3842dc0135657cd0b1ba08436a1c501c19ad0116.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited()

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/usb/class/usblp.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 9eca405..cb3a932 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -58,6 +58,7 @@
 #include <linux/mutex.h>
 #undef DEBUG
 #include <linux/usb.h>
+#include <linux/ratelimit.h>
 
 /*
  * Version Information
@@ -348,8 +349,7 @@ static int usblp_check_status(struct usblp *usblp, int err)
 	mutex_lock(&usblp->mut);
 	if ((error = usblp_read_status(usblp, usblp->statusbuf)) < 0) {
 		mutex_unlock(&usblp->mut);
-		if (printk_ratelimit())
-			printk(KERN_ERR
+		printk_ratelimited(KERN_ERR
 				"usblp%d: error %d reading printer status\n",
 				usblp->minor, error);
 		return 0;
@@ -653,8 +653,7 @@ static long usblp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		case LPGETSTATUS:
 			if ((retval = usblp_read_status(usblp, usblp->statusbuf))) {
-				if (printk_ratelimit())
-					printk(KERN_ERR "usblp%d:"
+				printk_ratelimited(KERN_ERR "usblp%d:"
 					    "failed reading printer status (%d)\n",
 					    usblp->minor, retval);
 				retval = -EIO;
-- 
1.7.4.1

