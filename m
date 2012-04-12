Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966114Ab2DLW1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:27:33 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50608 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012Ab2DLW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:27:31 -0400
Date: Thu, 12 Apr 2012 15:27:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.4-rc2
Message-ID: <20120412222728.GD11612@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git tags/usb-3.4-rc2

for you to fetch changes up to 9de29225bdd25958c1fa82521ff02726f1cab953:

  USB: update usbtmc api documentation (2012-04-12 08:26:22 -0700)

----------------------------------------------------------------
USB fixes for 3.4-rc2

Here are a number of fixes for the USB core and drivers for 3.4-rc2

Lots of tiny xhci fixes here, a few usb-serial driver fixes and new device ids,
and a smattering of other minor fixes in different USB drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (7):
      USB: don't clear urb->dev in scatter-gather library
      USB documentation: explain lifetime rules for unlinking URBs
      USB: fix bug in serial driver unregistration
      USB: don't ignore suspend errors for root hubs
      USB: fix race between root-hub suspend and remote wakeup
      EHCI: keep track of ports being resumed and indicate in hub_status_data
      UHCI: hub_status_data should indicate if ports are resuming

Aleksey Babahin (1):
      USB: serial: metro-usb: Fix idProduct for Uni-Directional mode.

Alex He (2):
      xHCI: correct to print the true HSEE of USBCMD
      xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI

Anton Samokhvalov (1):
      USB: sierra: add support for Sierra Wireless MC7710

Dan Carpenter (1):
      xHCI: use gfp flags from caller instead of GFP_ATOMIC

David Daney (1):
      usb: Put USB Kconfig items back under USB.

Elric Fu (2):
      USB: fix bug of device descriptor got from superspeed device
      xHCI: add XHCI_RESET_ON_RESUME quirk for VIA xHCI host

Felipe Balbi (1):
      xhci: don't re-enable IE constantly

Gerard Snitselaar (1):
      usb: xhci: fix section mismatch in linux-next

Greg Kroah-Hartman (2):
      Merge 3.2-rc1 into usb-linus
      Merge tag 'for-usb-linus-2012-04-11' of git://git.kernel.org/.../sarah/xhci into usb-linus

Johan Hovold (2):
      USB: pl2303: fix DTR/RTS being raised on baud rate change
      USB: serial: fix race between probe and open

Michael BRIGHT (1):
      USB: remove compile warning on gadget/inode.c

Ming Lei (1):
      usb: storage: fix lockdep warning inside usb_stor_pre_reset(v2)

Santiago Garcia Mantinan (1):
      USB: option: re-add NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option_id array

Sarah Sharp (4):
      xhci: Warn when hosts don't halt.
      xhci: Don't write zeroed pointers to xHC registers.
      xhci: Restore event ring dequeue pointer on resume.
      xhci: Fix register save/restore order.

Sebastian Andrzej Siewior (1):
      usb/usbmon: correct the data interpretation of usbmon's output

Simon Arlott (2):
      USB: ftdi_sio: fix status line change handling for TIOCMIWAIT and TIOCGICOUNT
      USB: ftdi_sio: fix race condition in TIOCMIWAIT, and abort of TIOCMIWAIT when the device is removed

Stephen Lewis (1):
      USB: update usbtmc api documentation

 Documentation/ABI/stable/sysfs-driver-usb-usbtmc |   14 ++++-----
 Documentation/usb/URB.txt                        |   22 +++++++++++++
 Documentation/usb/usbmon.txt                     |    6 ++--
 drivers/usb/Kconfig                              |   16 +++++-----
 drivers/usb/core/driver.c                        |    9 ++++--
 drivers/usb/core/hcd.c                           |   12 ++++++++
 drivers/usb/core/hub.c                           |   16 ++++++++++
 drivers/usb/core/message.c                       |   11 ++++---
 drivers/usb/core/urb.c                           |   12 ++++++++
 drivers/usb/gadget/inode.c                       |    1 -
 drivers/usb/host/ehci-hcd.c                      |    3 ++
 drivers/usb/host/ehci-hub.c                      |   31 ++++++++++---------
 drivers/usb/host/ehci-tegra.c                    |    2 ++
 drivers/usb/host/ehci.h                          |    2 ++
 drivers/usb/host/pci-quirks.c                    |   10 ++++--
 drivers/usb/host/uhci-hub.c                      |    5 +--
 drivers/usb/host/xhci-dbg.c                      |    2 +-
 drivers/usb/host/xhci-ext-caps.h                 |    5 +--
 drivers/usb/host/xhci-mem.c                      |    9 ++----
 drivers/usb/host/xhci-pci.c                      |    4 ++-
 drivers/usb/host/xhci-ring.c                     |    6 ++--
 drivers/usb/host/xhci.c                          |   12 +++++---
 drivers/usb/host/xhci.h                          |    4 +++
 drivers/usb/serial/bus.c                         |    5 ---
 drivers/usb/serial/ftdi_sio.c                    |   36 ++++++++++++----------
 drivers/usb/serial/metro-usb.c                   |    6 ++--
 drivers/usb/serial/option.c                      |    1 +
 drivers/usb/serial/pl2303.c                      |    2 +-
 drivers/usb/serial/sierra.c                      |    1 +
 drivers/usb/serial/usb-serial.c                  |   31 ++++++-------------
 drivers/usb/storage/usb.c                        |   30 ++++++++++++++++++
 include/linux/usb/serial.h                       |    8 -----
 32 files changed, 216 insertions(+), 118 deletions(-)
