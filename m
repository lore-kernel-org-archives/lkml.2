Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1AaExw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:53:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48939 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AaExu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:53:50 -0500
Date: Mon, 31 Jan 2011 15:53:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        "Yuan-Hsin Chen" <yhchen@faraday-tech.com>
Subject: linux-next: manual merge of the usb tree with the arm tree
Message-Id: <20110131155346.d824d38a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/gadget/Kconfig between commit
82e6923e1862428b755ec306b3dbccf926849314 ("ARM: lh7a40x: remove
unmaintained platform support") from the arm tree and commit
0fe6f1d1f612035d78d8d195bbc3485a341386d5 ("usb: udc: add Faraday fusb300
driver") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/Kconfig
index 88d191b,4845539..0000000
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@@ -176,6 -176,30 +176,18 @@@ config USB_FSL_USB
  	default USB_GADGET
  	select USB_GADGET_SELECTED
  
+ config USB_GADGET_FUSB300
+ 	boolean "Faraday FUSB300 USB Peripheral Controller"
+ 	select USB_GADGET_DUALSPEED
+ 	help
+ 	   Faraday usb device controller FUSB300 driver
+ 
+ config USB_FUSB300
+ 	tristate
+ 	depends on USB_GADGET_FUSB300
+ 	default USB_GADGET
+ 	select USB_GADGET_SELECTED
+ 
 -config USB_GADGET_LH7A40X
 -	boolean "LH7A40X"
 -	depends on ARCH_LH7A40X
 -	help
 -	   This driver provides USB Device Controller driver for LH7A40x
 -
 -config USB_LH7A40X
 -	tristate
 -	depends on USB_GADGET_LH7A40X
 -	default USB_GADGET
 -	select USB_GADGET_SELECTED
 -
  config USB_GADGET_OMAP
  	boolean "OMAP USB Device Controller"
  	depends on ARCH_OMAP
