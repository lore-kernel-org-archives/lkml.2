Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab0FDUpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:45:05 -0400
Received: from kroah.org ([198.145.64.141]:43901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab0FDUpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:45:03 -0400
Date: Fri, 4 Jun 2010 13:44:36 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.35-git
Message-ID: <20100604204436.GA19761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few USB bugfixes for your 2.6.35-git tree.

The majority are for the s3c gadget driver, and the xhci host
controller, with a smattering of other bugfixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

Most of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c          |    6 ++-
 drivers/usb/core/driver.c            |    2 +
 drivers/usb/gadget/Kconfig           |    1 +
 drivers/usb/gadget/s3c-hsotg.c       |   57 ++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c          |   20 ++++++++++--
 drivers/usb/host/isp1362.h           |    2 +-
 drivers/usb/host/xhci-pci.c          |    2 +
 drivers/usb/host/xhci-ring.c         |   31 ++++++++++++++++++-
 drivers/usb/host/xhci.c              |   57 +++++++++++++++++++++++++++++-----
 drivers/usb/host/xhci.h              |   12 +++++++
 drivers/usb/serial/digi_acceleport.c |    3 +-
 drivers/usb/serial/ftdi_sio.c        |    4 ++
 drivers/usb/serial/mos7840.c         |    1 -
 13 files changed, 180 insertions(+), 18 deletions(-)

---------------

Alan Stern (1):
      USB: unbind all interfaces before rebinding them

Axel Lin (1):
      USB: cdc-acm: fix resource reclaim in error path of acm_probe

Ben Dooks (3):
      USB: s3c-hsotg: Ensure TX FIFO addresses setup when initialising FIFOs
      USB: s3c-hsotg: SoftDisconnect minimum 3ms
      USB: s3c-hsotg: Ensure FIFOs are fully flushed after layout

Daniel Mack (1):
      USB: ftdi_sio: fix DTR/RTS line modes

Grant Likely (1):
      usb: fix ehci_hcd build failure when both generic-OF and xilinx is selected

Johan Hovold (1):
      USB: mos7840: fix null-pointer dereference

Julia Lawall (1):
      USB: serial: digi_acceleport: Eliminate a NULL pointer dereference

Maurus Cuelenaere (1):
      USB: s3c_hsotg: define USB_GADGET_DUALSPEED in Kconfig

Mike Frysinger (1):
      USB: isp1362: fix inw warning on Blackfin systems

Sarah Sharp (3):
      USB: xhci: Wait for controller to be ready after reset.
      USB: xhci: Wait for host to start running.
      USB: xhci: Print NEC firmware version.

Thomas Abraham (1):
      USB: s3c: Enable soft disconnect during initialization

