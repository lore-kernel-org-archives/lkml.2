Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1JGU5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:57:47 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:33231 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935298Ab1JGU5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:57:45 -0400
Message-ID: <4E8F67C6.5020603@xenotime.net>
Date: Fri, 07 Oct 2011 13:57:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] usb gadget: fix langwell_udc.c build error
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
In-Reply-To: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Move function to fix langwell_udc.c build error:

drivers/usb/gadget/langwell_udc.c: In function 'show_langwell_udc':
drivers/usb/gadget/langwell_udc.c:1693:3: error: implicit declaration of function 'lpm_device_speed'
drivers/usb/gadget/langwell_udc.c: At top level:
drivers/usb/gadget/langwell_udc.c:2637:37: error: conflicting types for 'lpm_device_speed'
drivers/usb/gadget/langwell_udc.c:1693:20: note: previous implicit declaration of 'lpm_device_speed' was here

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Felipe Balbi <balbi@ti.com>
Cc:	linux-usb@vger.kernel.org
---
 drivers/usb/gadget/langwell_udc.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- next-2011-1007.orig/drivers/usb/gadget/langwell_udc.c
+++ next-2011-1007/drivers/usb/gadget/langwell_udc.c
@@ -1562,6 +1562,20 @@ static ssize_t show_function(struct devi
 static DEVICE_ATTR(function, S_IRUGO, show_function, NULL);
 
 
+static inline enum usb_device_speed lpm_device_speed(u32 reg)
+{
+	switch (LPM_PSPD(reg)) {
+	case LPM_SPEED_HIGH:
+		return USB_SPEED_HIGH;
+	case LPM_SPEED_FULL:
+		return USB_SPEED_FULL;
+	case LPM_SPEED_LOW:
+		return USB_SPEED_LOW;
+	default:
+		return USB_SPEED_UNKNOWN;
+	}
+}
+
 /* device "langwell_udc" sysfs attribute file */
 static ssize_t show_langwell_udc(struct device *_dev,
 		struct device_attribute *attr, char *buf)
@@ -2634,20 +2648,6 @@ done:
 	dev_vdbg(&dev->pdev->dev, "<--- %s()\n", __func__);
 }
 
-static inline enum usb_device_speed lpm_device_speed(u32 reg)
-{
-	switch (LPM_PSPD(reg)) {
-	case LPM_SPEED_HIGH:
-		return USB_SPEED_HIGH;
-	case LPM_SPEED_FULL:
-		return USB_SPEED_FULL;
-	case LPM_SPEED_LOW:
-		return USB_SPEED_LOW;
-	default:
-		return USB_SPEED_UNKNOWN;
-	}
-}
-
 /* port change detect interrupt handler */
 static void handle_port_change(struct langwell_udc *dev)
 {
