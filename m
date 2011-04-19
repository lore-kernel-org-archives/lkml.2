Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1DSUWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:22:31 -0400
Received: from kroah.org ([198.145.64.141]:35664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab1DSURd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:48 2011
Message-Id: <20110419201048.481217763@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>
Subject: [50/70] usb: musb: temporarily make it bool
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 7a180e70cfc56e131bfe4796773df2acfc7d4180 upstream.

Due to the recent changes to musb's glue layers,
we can't compile musb-hdrc as a module - compilation
will break due to undefined symbol musb_debug. In
order to fix that, we need a big re-work of the
debug support on the MUSB driver.

Because that would mean a lot of new code coming
into the -rc series, it's best to defer that to
next merge window and for now just disable module
support for MUSB.

Once we get the refactor of the debugging support
done, we can simply revert this patch and things
will go back to normal again.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -14,7 +14,7 @@ config USB_MUSB_HDRC
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
 	select USB_OTG_UTILS
-	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
+	bool 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	help
 	  Say Y here if your system has a dual role high speed USB
 	  controller based on the Mentor Graphics silicon IP.  Then
@@ -30,8 +30,8 @@ config USB_MUSB_HDRC
 
 	  If you do not know what this is, please say N.
 
-	  To compile this driver as a module, choose M here; the
-	  module will be called "musb-hdrc".
+#	  To compile this driver as a module, choose M here; the
+#	  module will be called "musb-hdrc".
 
 choice
 	prompt "Platform Glue Layer"


