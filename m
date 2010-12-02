Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0LBUwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:52:18 -0500
Received: from kroah.org ([198.145.64.141]:60373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab0LBUwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:52:17 -0500
Date: Thu, 2 Dec 2010 12:48:37 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .37-rc4
Message-ID: <20101202204837.GC5927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of USB patches for your .37-rc4 tree.

The largest here is some xhci suspend/resume fixes that have been
reported, and tested that they fix the issues.

Also, some musb fixes, as well as a variety of other minor stuff.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------


 drivers/usb/core/hcd.c            |    2 +
 drivers/usb/host/ehci-pci.c       |   12 +++
 drivers/usb/host/xhci-hub.c       |    7 ++
 drivers/usb/host/xhci-mem.c       |  164 +++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.c           |   18 ++++
 drivers/usb/host/xhci.h           |   26 ++++++
 drivers/usb/misc/yurex.c          |    1 +
 drivers/usb/musb/musb_core.c      |    3 +
 drivers/usb/musb/musb_gadget.c    |  124 +++++++++++++++++++---------
 drivers/usb/serial/ftdi_sio.c     |    2 +
 drivers/usb/serial/ftdi_sio_ids.h |    4 +
 drivers/usb/serial/usb-serial.c   |    3 +
 include/linux/usb.h               |    4 +
 13 files changed, 332 insertions(+), 38 deletions(-)

---------------

Ajay Kumar Gupta (1):
      usb: musb: gadget: fix compilation warning

Alan Stern (1):
      USB: fix autosuspend bug in usb-serial

Anand Gadiyar (1):
      usb: musb: do not use dma for control transfers

Brian J. Tarricone (1):
      USB: ehci: disable LPM and PPCD for nVidia MCP89 chips

Hema Kalliguddi (1):
      usb: musb: unmap dma buffer when switching to PIO

Jacques Viviers (1):
      USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added

Michael Stuermer (1):
      USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable

Ming Lei (1):
      usb: musb: clear RXCSR_AUTOCLEAR before PIO read

Paul Zimmerman (1):
      xhci: Fix reset-device and configure-endpoint commands

Sarah Sharp (2):
      xhci: Setup array of USB 2.0 and USB 3.0 ports.
      xhci: Don't let the USB core disable SuperSpeed ports.

Tomoki Sekiyama (1):
      USB: yurex: add .llseek fop to file_operations

