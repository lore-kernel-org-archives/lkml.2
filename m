Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab1EYOj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:39:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58051 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757154Ab1EYOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:39:26 -0400
Date: Wed, 25 May 2011 10:39:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <Pine.LNX.4.44L0.1105251010580.1987-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1105251033550.1987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Alan Stern wrote:

> I have looked this over more carefully.  It turns out that both of you
> have misunderstood the purpose of CONFIG_USB_GADGET_DUALSPEED (and by
> extension, CONFIG_USB_GADGET_SUPERSPEED).  In fact, the existing
> Kconfig file is also wrong.
> 
> The _only_ reason for CONFIG_USB_GADGET_DUALSPEED is so that gadget
> drivers can use conditional compilation to avoid including the
> high-speed descriptors when the UDC doesn't support high-speed 
> operation.  That's all.  This means that the 
> CONFIG_USB_GAGDET_DUALSPEED option does not need to be 
> user-controllable in Kconfig.  It should default to N, and UDC drivers 
> that support high speed should select it.

In other words, we should merge the following patch and the new 
SuperSpeed support should follow the same pattern.

Alan Stern


---------------------------------------------------------------------


This patch (as1468) changes the Kconfig definition for
USB_GADGET_DUALSPEED.  This option is determined entirely by which
device controller drivers are to be built, through Select statements;
it does not need to be (and should not be) configurable by the user.

Also, the "default n" line is superfluous -- everything defaults to N.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

 drivers/usb/gadget/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: usb-2.6/drivers/usb/gadget/Kconfig
===================================================================
--- usb-2.6.orig/drivers/usb/gadget/Kconfig
+++ usb-2.6/drivers/usb/gadget/Kconfig
@@ -597,13 +597,10 @@ config USB_DUMMY_HCD
 
 endchoice
 
+# Selected by UDC drivers that support high-speed operation.
 config USB_GADGET_DUALSPEED
 	bool
 	depends on USB_GADGET
-	default n
-	help
-	  Means that gadget drivers should include extra descriptors
-	  and code to handle dual-speed controllers.
 
 #
 # USB Gadget Drivers

