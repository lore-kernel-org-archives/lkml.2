Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0HIR5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:57:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53201 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0HIR53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:57:29 -0400
Date: Mon, 9 Aug 2010 10:55:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch -NEXT] usb/gadget/webcam: fix Kconfig depends again
Message-Id: <20100809105520.d17e4795.randy.dunlap@oracle.com>
In-Reply-To: <20100809132314.789e13f3.sfr@canb.auug.org.au>
References: <20100809132314.789e13f3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The USB gadget webcam driver uses V4L2 interfaces, so it should depend
on VIDEO_V4L2 instead of VIDEO_DEV.  This fixes a lot of build errors
when V4L2 is not enabled:

ERROR: "v4l2_event_unsubscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_queue" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_device_release" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_usercopy" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_dequeue" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_register_device" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_device_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_subscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_unregister_device" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_init" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_pending" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_devdata" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_add" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_del" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_exit" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_ctrl_fill" [drivers/media/video/v4l2-common.ko] undefined!
ERROR: "v4l2_ctrl_get_menu" [drivers/media/video/v4l2-common.ko] undefined!
ERROR: "v4l2_device_unregister_subdev" [drivers/media/video/v4l2-common.ko] undefined!
ERROR: "v4l2_device_register_subdev" [drivers/media/video/v4l2-common.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100809.orig/drivers/usb/gadget/Kconfig
+++ linux-next-20100809/drivers/usb/gadget/Kconfig
@@ -947,7 +947,7 @@ endif
 # or video class gadget drivers), or specific hardware, here.
 config USB_G_WEBCAM
 	tristate "USB Webcam Gadget"
-	depends on VIDEO_DEV
+	depends on VIDEO_V4L2
 	help
 	  The Webcam Gadget acts as a composite USB Audio and Video Class
 	  device. It provides a userspace API to process UVC control requests
