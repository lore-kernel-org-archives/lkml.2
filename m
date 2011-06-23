Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413Ab1FWWkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:40:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24525 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab1FWWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:40:38 -0400
Date: Fri, 24 Jun 2011 00:31:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 16/37] Remove unneeded version.h includes (and add where
 needed) for drivers/usb/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240030390.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
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

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
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
index 5e807f0..a715805 100644
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
index d509a4a..fe21104 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -26,7 +26,6 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

