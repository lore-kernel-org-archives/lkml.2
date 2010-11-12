Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0KLVeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:34:36 -0500
Received: from kroah.org ([198.145.64.141]:57077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab0KLVeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:34:20 -0500
Date: Fri, 12 Nov 2010 13:32:19 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .37-rc1
Message-ID: <20101112213219.GC9294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of USB patches for your .37-rc1 tree.

Nothing big, just a lot of little things, largest being some blackfin
and musb fixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 MAINTAINERS                         |    2 +-
 drivers/usb/core/devio.c            |    7 ++-
 drivers/usb/gadget/Kconfig          |    2 +-
 drivers/usb/gadget/goku_udc.h       |    3 +-
 drivers/usb/gadget/u_serial.c       |   54 +++++++++++++++++------
 drivers/usb/host/Kconfig            |    2 +-
 drivers/usb/host/ehci-mxc.c         |   14 ++++--
 drivers/usb/host/ohci-jz4740.c      |    2 +-
 drivers/usb/misc/iowarrior.c        |    1 +
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 drivers/usb/musb/blackfin.c         |   80 +++++++++++++++++++++++-----------
 drivers/usb/musb/musb_core.c        |   41 ++++++++----------
 drivers/usb/musb/musb_core.h        |    2 +-
 drivers/usb/musb/musb_gadget.c      |   41 ++++++++++--------
 drivers/usb/musb/musb_regs.h        |    3 +-
 drivers/usb/musb/musbhsdma.c        |   14 ++++++
 drivers/usb/serial/ftdi_sio.c       |    2 +
 drivers/usb/serial/ftdi_sio_ids.h   |    7 +++
 drivers/usb/serial/option.c         |    2 +-
 drivers/uwb/allocator.c             |    3 +-
 include/linux/usb.h                 |    2 +-
 include/linux/usb/musb.h            |    2 +
 22 files changed, 188 insertions(+), 99 deletions(-)

---------------

Anand Gadiyar (1):
      usb: musb: fail unaligned DMA transfers on v1.8 and above

Andy Whitcroft (1):
      usb: gadget: goku_udc: add registered flag bit, fixing build

Bob Liu (4):
      USB: musb: pm: don't rely fully on clock support
      USB: musb: blackfin: pm: make it work
      USB: musb: blackfin: fix dynamic device<->host changing
      USB: musb: blackfin: push clkin value to platform resources

David Sterba (1):
      USB: xhci: Use GFP_ATOMIC under spin_lock

Grazvydas Ignotas (1):
      usb: musb: don't leave PHY enabled on shutdown()

Greg Kroah-Hartman (2):
      USB: the development of the usb tree is now in git
      Revert "USB: xhci: Use GFP_ATOMIC under spin_lock"

Heikki Krogerus (1):
      usb: musb: Fix handling of spurious SESSREQ

Ian Jeffray (1):
      USB: musb: blackfin: fix musb_read_txhubport() definition

Jesper Juhl (1):
      UWB: Return UWB_RSV_ALLOC_NOT_FOUND rather than crashing on NULL dereference if kzalloc fails

Jim Sung (1):
      usb: subtle increased memory usage in u_serial

Marc Kleine-Budde (1):
      USB: Fix FSL USB driver on non Open Firmware systems

Ming Lei (3):
      usb: musb: gadget: fix dma mode 0 in double buffer Rx case
      USB: musb: gadget: fix MUSB_TXMAXP and MUSB_RXMAXP configuration
      usb: musb: fix kernel oops when loading musb_hdrc module for the 2nd time

Rahul Ruikar (1):
      usb: musb: musb_gadget: fix resource leakage in error path

Randy Dunlap (1):
      usb.h: fix ioctl kernel-doc info

Sebastien Bourdeauducq (1):
      USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial

Sergei Shtylyov (1):
      usb: musb: gadget: kill duplicate code in musb_gadget_queue()

Stefan Weil (1):
      USB: ohci-jz4740: Fix spelling in MODULE_ALIAS

Uwe Kleine-König (1):
      USB: ehci/mxc: compile fix

Vasiliy Kulikov (3):
      usb: misc: sisusbvga: fix information leak to userland
      usb: misc: iowarrior: fix information leak to userland
      usb: core: fix information leak to userland

ma rui (1):
      USB: option: fix when the driver is loaded incorrectly for some Huawei devices.

