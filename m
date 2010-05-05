Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0EEWrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:47:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63163 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904Ab0EEWq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:46:57 -0400
Date: Wed, 5 May 2010 15:46:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de
Subject: [PATCH -next] usb gadget webcam: depends on VIDEO_DEV
Message-Id: <20100505154626.2c036f1d.randy.dunlap@oracle.com>
In-Reply-To: <20100505123409.ed5678a2.sfr@canb.auug.org.au>
References: <20100505123409.ed5678a2.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4BE1F554.0199:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

g_webcam uses v4l[2] interfaces, so it should depend on VIDEO_DEV.

ERROR: "v4l2_event_unsubscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_queue" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_device_release" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_usercopy" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_dequeue" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_register_device" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_device_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_subscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_unregister_device" [drivers/usb/gadget/g_webcam.ko] ndefined!
ERROR: "v4l2_event_pending" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_init" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_devdata" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_add" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_del" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_exit" [drivers/usb/gadget/g_webcam.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100505.orig/drivers/usb/gadget/Kconfig
+++ linux-next-20100505/drivers/usb/gadget/Kconfig
@@ -879,6 +879,7 @@ config USB_G_HID
 # or video class gadget drivers), or specific hardware, here.
 config USB_G_WEBCAM
 	tristate "USB Webcam Gadget"
+	depends on VIDEO_DEV
 	help
 	  The Webcam Gadget acts as a composite USB Audio and Video Class
 	  device. It provides a userspace API to process UVC control requests
