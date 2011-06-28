Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab1F1Pmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:42:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37824 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308Ab1F1Pjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:39:54 -0400
X-Sasl-enc: 7xK0DIf8fdbnYTuK35g08xCElmtx5EmHSK7WkQo2TOCH 1309275593
Date: Tue, 28 Jun 2011 08:39:01 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] more USB fixes for 3.0
Message-ID: <20110628153901.GC32710@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some small fixes for your 3.0 tree.

Nothing major, just the normal USB 3.0 fixes, some MAINTAINERS file
updates, device ids added, and other various bugs fixed that were being
reported as problems.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these have been in the linux-next tree for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/usb/error-codes.txt     |    9 ++++++-
 MAINTAINERS                           |   12 ++++++++-
 drivers/usb/core/driver.c             |   11 ++++++++-
 drivers/usb/core/hub.c                |   16 +++++++++----
 drivers/usb/core/message.c            |   15 +++++++++++-
 drivers/usb/host/ehci-ath79.c         |   10 +++++---
 drivers/usb/host/ehci-hcd.c           |    4 +++
 drivers/usb/host/isp1760-hcd.c        |    2 +-
 drivers/usb/host/ohci-hcd.c           |    4 ++-
 drivers/usb/host/r8a66597-hcd.c       |    1 +
 drivers/usb/host/xhci-mem.c           |    2 -
 drivers/usb/host/xhci-pci.c           |    8 ++++++
 drivers/usb/host/xhci-ring.c          |   30 +++++++++++++++++++++----
 drivers/usb/host/xhci.c               |   39 +++++++++++++++++++++++++++++---
 drivers/usb/host/xhci.h               |    3 ++
 drivers/usb/musb/musb_gadget.c        |    6 +++++
 drivers/usb/musb/musb_host.c          |    2 +-
 drivers/usb/serial/ftdi_sio.c         |   19 +++++++++++----
 drivers/usb/serial/ftdi_sio.h         |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h     |    1 +
 drivers/usb/serial/ti_usb_3410_5052.c |    1 +
 21 files changed, 164 insertions(+), 34 deletions(-)

---------------

Alan Stern (3):
      USB: change maintainership of ohci-hcd and ehci-hcd
      USB: don't let the hub driver prevent system sleep
      USB: don't let errors prevent system sleep

Alex He (2):
      xHCI 1.0: Force Stopped Event(FSE)
      xHCI 1.0: Incompatible Device Error

Arvid Brodin (1):
      usb/isp1760: Fix bug preventing the unlinking of control urbs

Gabor Juhos (1):
      USB: ehci-ath79: fix a NULL pointer dereference

Jesper Juhl (1):
      USB: TI 3410/5052 USB Serial Driver: Fix mem leak when firmware is too big.

Maarten Lankhorst (1):
      xhci: Add reset on resume quirk for asrock p67 host

Márton Németh (1):
      usb: musb: host: compare status for negative error values

Sarah Sharp (5):
      xhci: Reject double add of active endpoints.
      USB: Free bandwidth when usb_disable_device is called.
      xhci: Don't warn about zeroed bMaxBurst descriptor field.
      xhci: Always set urb->status to zero for isoc endpoints.
      USB: Fix up URB error codes to reflect implementation.

Uwe Bonnes (1):
      USB: Add new FT232H chip to drivers/usb/serial/ftdi_sio.c

Yauheni Kaliuta (1):
      usb: musb: gadget: clear TXPKTRDY flag when set FLUSHFIFO

Yoshihiro Shimoda (1):
      usb: r8a66597-hcd: fix cannot detect low/full speed device

matt mooney (1):
      MAINTAINERS: add myself as maintainer of USB/IP

