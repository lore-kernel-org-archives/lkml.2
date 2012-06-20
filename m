Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab2FTSWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab2FTSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:48 -0400
Message-Id: <20120620173024.018090781@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jon Povey <jon.povey@racelogic.co.uk>,
        Sekhar Nori <nsekhar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 36/61] usb: musb: davinci: Fix build breakage
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Povey <jon.povey@racelogic.co.uk>

commit 6594b2d7b1ef8260e6e36ddc96bd37a40e39ba80 upstream.

This appears to have been broken by
commit 5cfb19ac604a68c030b245561f575c2d1bac1d49
(ARM: davinci: streamline sysmod access)

For now, fix by hardcoding USB_PHY_CTRL and DM355_DEEPSLEEP

Tested on DM365 with defconfig changes.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
Acked-by: Sekhar Nori <nsekhar@ti.com>
CC: Felipe Balbi <balbi@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/davinci.c |    1 +
 drivers/usb/musb/davinci.h |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -34,6 +34,7 @@
 #include <linux/dma-mapping.h>
 
 #include <mach/cputype.h>
+#include <mach/hardware.h>
 
 #include <asm/mach-types.h>
 
--- a/drivers/usb/musb/davinci.h
+++ b/drivers/usb/musb/davinci.h
@@ -15,7 +15,7 @@
  */
 
 /* Integrated highspeed/otg PHY */
-#define USBPHY_CTL_PADDR	(DAVINCI_SYSTEM_MODULE_BASE + 0x34)
+#define USBPHY_CTL_PADDR	0x01c40034
 #define USBPHY_DATAPOL		BIT(11)	/* (dm355) switch D+/D- */
 #define USBPHY_PHYCLKGD		BIT(8)
 #define USBPHY_SESNDEN		BIT(7)	/* v(sess_end) comparator */
@@ -27,7 +27,7 @@
 #define USBPHY_OTGPDWN		BIT(1)
 #define USBPHY_PHYPDWN		BIT(0)
 
-#define DM355_DEEPSLEEP_PADDR	(DAVINCI_SYSTEM_MODULE_BASE + 0x48)
+#define DM355_DEEPSLEEP_PADDR	0x01c40048
 #define DRVVBUS_FORCE		BIT(2)
 #define DRVVBUS_OVERRIDE	BIT(1)
 


