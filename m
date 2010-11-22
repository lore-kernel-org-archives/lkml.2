Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0KVTtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:49:24 -0500
Received: from kroah.org ([198.145.64.141]:36542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab0KVTtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:49:23 -0500
Date: Mon, 22 Nov 2010 11:49:19 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .37-rc3
Message-ID: <20101122194919.GA29971@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of USB patches for your .37-rc3 tree.

Nothing big, just a number of little things, full details below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/atm/ueagle-atm.c        |    7 +--
 drivers/usb/gadget/atmel_usba_udc.c |    2 +-
 drivers/usb/host/ehci-dbg.c         |    2 +-
 drivers/usb/host/ehci-hcd.c         |   10 ++--
 drivers/usb/host/ehci-mem.c         |   26 +++++++++++-
 drivers/usb/host/ehci-pci.c         |   13 ++++++
 drivers/usb/host/ehci-sched.c       |   21 +++++++++-
 drivers/usb/host/ehci.h             |    2 +
 drivers/usb/host/isp1362-hcd.c      |    2 +-
 drivers/usb/host/xhci-mem.c         |    4 +-
 drivers/usb/host/xhci-ring.c        |    1 -
 drivers/usb/host/xhci.c             |   73 ++++++++++++++++++++++++++++++-----
 drivers/usb/host/xhci.h             |    5 ++
 drivers/usb/misc/cypress_cy7c63.c   |    6 +--
 drivers/usb/misc/trancevibrator.c   |    2 +-
 drivers/usb/misc/usbled.c           |    2 +-
 drivers/usb/misc/usbsevseg.c        |   10 ++---
 drivers/usb/otg/langwell_otg.c      |    9 ++--
 drivers/usb/storage/sierra_ms.c     |    2 +-
 19 files changed, 151 insertions(+), 48 deletions(-)

---------------

Alan Stern (1):
      USB: EHCI: fix obscure race in ehci_endpoint_disable

Andiry Xu (3):
      xHCI: release spinlock when setup interrupt
      xHCI: fix wMaxPacketSize mask
      USB: EHCI: AMD periodic frame list table quirk

Axel Lin (1):
      USB: isp1362-hcd - fix section mismatch warning

Greg Kroah-Hartman (8):
      USB: atm: ueagle-atm: fix up some permissions on the sysfs files
      USB: ehci: fix debugfs 'lpm' permissions
      USB: storage: sierra_ms: fix sysfs file attribute
      USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
      USB: misc: trancevibrator: fix up a sysfs attribute permission
      USB: misc: usbled: fix up some sysfs attribute permissions
      USB: misc: usbsevseg: fix up some sysfs attribute permissions
      USB: OTG: langwell_otg: fix up some sysfs attribute permissions

Josh Wu (1):
      USB: gadget: AT91: fix typo in atmel_usba_udc driver

Sarah Sharp (2):
      xhci: Remove excessive printks with shared IRQs.
      xhci: Fix command ring replay after resume.

