Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1HAVdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:33:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14802 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1HAVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:33:30 -0400
Date: Mon, 1 Aug 2011 23:33:29 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH][Resend] Remove unneeded version.h includes (and add where
 needed) for drivers/usb/
Message-ID: <alpine.LNX.2.00.1108012329380.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that linux/version.h was not
always being included where needed and sometimes included needlessly
in drivers/usb/.
This patch fixes up the includes.

For the UVC gadget driver bits, this was ACK'ed by Laurent Pinchart.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/uvc.h         |    1 +
 drivers/usb/gadget/uvc_v4l2.c    |    1 -
 drivers/usb/storage/realtek_cr.c |    1 -
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index 5b79194..81971fb 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -56,6 +56,7 @@ struct uvc_event
 #include <linux/usb.h>	/* For usb_endpoint_* */
 #include <linux/usb/gadget.h>
 #include <linux/videodev2.h>
+#include <linux/version.h>
 #include <media/v4l2-fh.h>
 
 #include "uvc_queue.h"
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index 52f8f9e..cfb5838 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -16,7 +16,6 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 34adc4b..6fd1306 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -25,7 +25,6 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

