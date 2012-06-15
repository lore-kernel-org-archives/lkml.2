Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2FOXrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:47:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50240 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab2FOXrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:47:13 -0400
Date: Fri, 15 Jun 2012 16:47:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.5-rc3
Message-ID: <20120615234709.GA9791@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.5-rc3

for you to fetch changes up to b3a3dd074f7053ef824ad077e5331b52220ceba1:

  USB: fix gathering of interface associations (2012-06-14 17:13:34 -0700)

----------------------------------------------------------------
USB fixes for 3.5-rc3

Here are a bunch of tiny fixes for the USB core and drivers for 3.5-rc3

A bunch of gadget fixes, and new device ids, as well as some fixes for a number
of different regressions that have been reported recently.  We also fixed some
PCI host controllers to resolve a long-standing bug with a whole class of host
controllers that have been plaguing people for a number of kernel releases,
preventing their systems from suspending properly.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      USB: mct_u232: Fix incorrect TIOCMSET return

Alan Stern (2):
      USB: add NO_D3_DURING_SLEEP flag and revert 151b61284776be2
      USB: serial-generic: use a single set of device IDs

Anand Gadiyar (1):
      Fix OMAP EHCI suspend/resume failure (i693)

Andiry Xu (1):
      xHCI: Increase the timeout for controller save/restore state operation

Andrew Bird (1):
      USB: option: Updated Huawei K4605 has better id

Bjørn Mork (4):
      USB: cdc-wdm: Add Vodafone/Huawei K5005 support
      USB: option: Add Vodafone/Huawei K5005 support
      USB: qcserial: Add Sierra Wireless device IDs
      USB: serial: Enforce USB driver and USB serial driver match

Christoph Fritz (1):
      usb: gadget: regression fix - usage of usb_ep

Dan Carpenter (1):
      USB: Checking the wrong variable in usb_disable_lpm()

Daniel Mack (1):
      USB: fix gathering of interface associations

Evan McNabb (1):
      USB: ftdi-sio: Add support for RT Systems USB-RTS01 serial adapter

Grazvydas Ignotas (1):
      usb: musb_gadget: fix crash caused by dangling pointer

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.5-rc1' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2012-06-13' of git://git.kernel.org/.../sarah/xhci into usb-linus

Hans de Goede (1):
      usb-storage: Add 090c:1000 to unusal-devs

Herton Ronaldo Krzesinski (1):
      USB: EHCI: Fix build warning in xilinx ehci driver

Ido Shayevitz (9):
      usb: gadget: atmel_usba_udc: Remove unneeded condition
      usb: gadget: fsl_qe_udc: Remove unneeded condition
      usb: gadget: fsl_udc_core: Remove unneeded condition
      usb: gadget: goku_udc: Remove unneeded condition
      usb: gadget: mv_udc_core: Remove unneeded condition
      usb: gadget: omap_udc: Remove unneeded condition
      usb: gadget: pxa25x_udc: Remove unneeded condition
      usb: gadget: s3c2410_udc: Remove unneeded condition
      usb: gadget: s3c-hsudc.c: Remove unneeded condition

Jan Safrata (1):
      usb: use usb_serial_put in usb_serial_probe errors

Johan Hovold (2):
      USB: option: fix port-data abuse
      USB: option: fix memory leak

Jon Povey (1):
      usb: musb: davinci: Fix build breakage

Mikko Tuumanen (1):
      USB: serial: cp210x: add Optris MS Pro usb id

Otto Meta (1):
      usb: cdc-acm: fix devices not unthrottled on open

Ricardo Martins (1):
      USB: fix PS3 EHCI systems

Roland Stigge (1):
      USB: ohci-hub: Mark ohci_finish_controller_resume() as __maybe_unused

Sarah Sharp (1):
      xhci: Fix error path return value.

Shimoda, Yoshihiro (1):
      usb: ehci-sh: fix illegal phy_init() running when platform_data is NULL

Takashi Iwai (2):
      xhci: Fix invalid loop check in xhci_free_tt_info()
      xhci: Don't free endpoints in xhci_mem_cleanup()

Tom Cassidy (1):
      USB: serial: sierra: Add support for Sierra Wireless AirCard 320U modem

Tony Zelenoff (1):
      USB: mos7840: Fix compilation of usb serial driver

说不得 (1):
      USB: option: add more YUGA device ids

 drivers/pci/pci.c                   |    5 ++
 drivers/pci/quirks.c                |   26 ++++++
 drivers/usb/class/cdc-acm.c         |    8 ++
 drivers/usb/class/cdc-wdm.c         |    9 ++
 drivers/usb/core/hcd-pci.c          |    9 --
 drivers/usb/core/hub.c              |    2 +-
 drivers/usb/core/message.c          |    3 +-
 drivers/usb/gadget/atmel_usba_udc.c |    6 --
 drivers/usb/gadget/fsl_qe_udc.c     |    2 +-
 drivers/usb/gadget/fsl_udc_core.c   |    4 +-
 drivers/usb/gadget/fsl_usb2_udc.h   |    4 +-
 drivers/usb/gadget/goku_udc.c       |    2 +-
 drivers/usb/gadget/mv_udc_core.c    |    2 +-
 drivers/usb/gadget/omap_udc.c       |    2 +-
 drivers/usb/gadget/pxa25x_udc.c     |    2 +-
 drivers/usb/gadget/s3c-hsudc.c      |    2 +-
 drivers/usb/gadget/s3c2410_udc.c    |    2 +-
 drivers/usb/host/ehci-hcd.c         |    2 +
 drivers/usb/host/ehci-omap.c        |  168 ++++++++++++++++++++++++++++++++++-
 drivers/usb/host/ehci-pci.c         |    8 --
 drivers/usb/host/ehci-sh.c          |    3 +-
 drivers/usb/host/ehci-xilinx-of.c   |    4 +-
 drivers/usb/host/ohci-hub.c         |    2 +-
 drivers/usb/host/xhci-mem.c         |   74 +++++----------
 drivers/usb/host/xhci.c             |   10 +--
 drivers/usb/musb/davinci.c          |    1 +
 drivers/usb/musb/davinci.h          |    4 +-
 drivers/usb/musb/musb_gadget.c      |    1 +
 drivers/usb/serial/cp210x.c         |    1 +
 drivers/usb/serial/ftdi_sio.c       |    1 +
 drivers/usb/serial/ftdi_sio_ids.h   |    1 +
 drivers/usb/serial/generic.c        |   10 +--
 drivers/usb/serial/mct_u232.c       |   13 +--
 drivers/usb/serial/mos7840.c        |    2 +-
 drivers/usb/serial/option.c         |   96 ++++++++++----------
 drivers/usb/serial/qcserial.c       |    6 ++
 drivers/usb/serial/sierra.c         |    4 +
 drivers/usb/serial/usb-serial.c     |   12 +--
 drivers/usb/storage/unusual_devs.h  |    7 ++
 include/linux/pci.h                 |    2 +
 include/linux/usb/hcd.h             |    2 -
 41 files changed, 354 insertions(+), 170 deletions(-)
