Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1AaSKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:10:19 -0500
Received: from kroah.org ([198.145.64.141]:45281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1AaSKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:10:18 -0500
Date: Mon, 31 Jan 2011 10:10:13 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .38
Message-ID: <20110131181013.GA6949@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes for your .38 tree.

Nothing major here, lots of little things and some xhci fixes that are
needed to resolve some reported bugs as well as a number of new device
ids and usb-storage quirks.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 MAINTAINERS                           |    6 +
 drivers/usb/class/cdc-wdm.c           |    2 +-
 drivers/usb/core/endpoint.c           |    2 +-
 drivers/usb/core/hcd-pci.c            |    7 +-
 drivers/usb/core/hub.c                |   21 +++
 drivers/usb/gadget/Kconfig            |    7 +-
 drivers/usb/gadget/ci13xxx_udc.c      |  268 +++++++++++++++++----------------
 drivers/usb/gadget/ci13xxx_udc.h      |    9 +-
 drivers/usb/gadget/composite.c        |    5 +-
 drivers/usb/gadget/pch_udc.c          |  127 +++++++++------
 drivers/usb/gadget/printer.c          |   19 +--
 drivers/usb/host/ehci-fsl.c           |   13 --
 drivers/usb/host/ehci-fsl.h           |    3 -
 drivers/usb/host/ehci-hcd.c           |   19 ++-
 drivers/usb/host/ehci-mxc.c           |   25 +++-
 drivers/usb/host/ehci-pci.c           |   33 +++--
 drivers/usb/host/fsl-mph-dr-of.c      |   11 +-
 drivers/usb/host/xhci-ring.c          |   91 ++++++-----
 drivers/usb/host/xhci.c               |   60 +++-----
 drivers/usb/host/xhci.h               |   16 +--
 drivers/usb/misc/usbled.c             |    2 +-
 drivers/usb/misc/uss720.c             |    1 -
 drivers/usb/otg/nop-usb-xceiv.c       |    2 +
 drivers/usb/otg/ulpi.c                |    2 +-
 drivers/usb/serial/ch341.c            |   10 ++
 drivers/usb/serial/cp210x.c           |   16 +--
 drivers/usb/serial/digi_acceleport.c  |   10 --
 drivers/usb/serial/ftdi_sio.c         |   12 ++-
 drivers/usb/serial/ftdi_sio_ids.h     |   22 ++-
 drivers/usb/serial/generic.c          |   20 +++
 drivers/usb/serial/io_tables.h        |    1 +
 drivers/usb/serial/iuu_phoenix.c      |    1 +
 drivers/usb/serial/keyspan.h          |    4 +
 drivers/usb/serial/keyspan_pda.c      |   17 --
 drivers/usb/serial/moto_modem.c       |    1 +
 drivers/usb/serial/option.c           |   23 +++-
 drivers/usb/serial/oti6858.c          |    1 +
 drivers/usb/serial/pl2303.c           |   12 ++
 drivers/usb/serial/pl2303.h           |    1 +
 drivers/usb/serial/qcaux.c            |    3 +
 drivers/usb/serial/siemens_mpi.c      |    1 +
 drivers/usb/serial/spcp8x5.c          |    7 +-
 drivers/usb/serial/usb-serial.c       |    8 +-
 drivers/usb/serial/usb_debug.c        |    1 +
 drivers/usb/storage/unusual_cypress.h |    5 +
 drivers/usb/storage/unusual_devs.h    |   18 +++
 include/linux/usb/hcd.h               |    1 +
 include/linux/usb/serial.h            |    3 +
 48 files changed, 568 insertions(+), 381 deletions(-)

---------------

Alan Stern (5):
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in unregistration
      USB: g_printer: fix bug in module parameter definitions
      USB serial: add missing .usb_driver field in serial drivers

Alex He (1):
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Andiry Xu (6):
      xHCI: synchronize irq in xhci_suspend()
      xHCI: fix queue_trb in isoc transfer
      xHCI: remove redundant parameter in giveback_first_trb()
      xHCI: fix cycle bit set in giveback_first_trb()
      xHCI: replace dev_dbg() with xhci_dbg()
      xHCI: fix printk_ratelimit() usage

Arnaud Patard (1):
      USB: ehci-mxc: add work-around for efika mx/sb bug

Craig Shelley (2):
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

Dan Williams (1):
      USB: qcaux: add Pantech UML290 device ID

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

David Sterba (1):
      USB: cdc-wdm: fix misuse of logical operation in place of bitop

Eric Bénard (1):
      USB: unbreak ehci-mxc on otg port of i.MX27

Fabio Estevam (1):
      usb: otg: Make USB3319 ULPI ID generic

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Matthew Wilcox (1):
      xhci: Remove more doorbell-related reads

Maulik Mankad (1):
      usb: gadget: composite: avoid access beyond array max length

Melchior FRANZ (1):
      USB: DL100B webmail notifier: initialize return value

Ming Lei (1):
      usb: otg: nop: fix oops triggered by otg_register_notifier

Nicolaus Colberg (1):
      USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Pavankumar Kondeti (2):
      USB: gadget: Fix error path in ci13xxx_udc gadget probe function
      USB: gadget: Fix endpoint representation in ci13xxx_udc

Peter Chen (1):
      usb: set ep_dev async suspend should be later than device_initialize

Peter Tyser (1):
      USB: ehci-fsl: Fix 'have_sysif_regs' detection

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure

Sarah Sharp (3):
      xhci: Resume bus on any port status change.
      usb: Realloc xHCI structures after a hub is verified.
      xhci: Use GFP_NOIO during device reset.

Sergei Shtylyov (1):
      USB: uss720: remove duplicate USB device

Stanislaw Gruszka (1):
      MAINTAINERS: add ueagle-atm entry

Tomoya MORINAGA (1):
      USB: pch_udc: support new device ML7213 IOH

Toshiharu Okada (2):
      usb: pch_udc: Fixed issue which does not work with g_serial
      usb: pch_udc: Fix the worning log issue at gadget driver remove

Zhang Rui (1):
      xhci: Do not run xhci_cleanup_msix with irq disabled

