Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab0GHArK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 20:47:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47202 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab0GHArJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 20:47:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6036"; a="46796833"
Message-ID: <4C35200C.2040209@codeaurora.org>
Date: Wed, 07 Jul 2010 17:47:08 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: sboyd@codeaurora.org
Subject: [PATCH] usb: gadget: #include device.h in gadget.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gadget.h uses structures defined in device.h, it must include it. In
most cases, gadget.h is preceded by linux/platform_device.h, but if
you are grouping headers sanely, device.h may not be pulled in until
*after* gadget (e.g. mach/msm_device.h), thus gadget.h should not
rely on something else #including device.h

include/linux/usb/gadget.h:488: error: field 'dev' has incomplete type
include/linux/usb/gadget.h: In function 'set_gadget_data':
include/linux/usb/gadget.h:492:
	error: implicit declaration of function 'dev_set_drvdata'
include/linux/usb/gadget.h: In function 'get_gadget_data':
include/linux/usb/gadget.h:494:
	error: implicit declaration of function 'dev_get_drvdata'
include/linux/usb/gadget.h:494:
	warning: return makes pointer from integer without a cast
include/linux/usb/gadget.h: At top level:
include/linux/usb/gadget.h:780: error: field 'driver' has incomplete type
In file included from include/linux/dmaengine.h:24,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:124,
                 from drivers/usb/gadget/u_ether.h:27,
                 from drivers/usb/gadget/android.c:37:
include/linux/device.h:494: error: conflicting types for 'dev_get_drvdata'
include/linux/usb/gadget.h:494:
	note: previous implicit declaration of 'dev_get_drvdata' was here
include/linux/device.h:495:
	warning: conflicting types for 'dev_set_drvdata'
include/linux/usb/gadget.h:492:
	note: previous implicit declaration of 'dev_set_drvdata' was here

Change-Id: Ia06309b76ac91fc305a1a50fb5e3469cb6adb623
Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 include/linux/usb/gadget.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index bbf45d5..ddca035 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -15,6 +15,8 @@
 #ifndef __LINUX_USB_GADGET_H
 #define __LINUX_USB_GADGET_H
 
+#include <linux/device.h>
+
 struct usb_ep;
 
 /**
-- 
1.7.1

