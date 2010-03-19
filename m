Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0CSPNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:13:48 -0400
Received: from kroah.org ([198.145.64.141]:51543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab0CSPNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:13:31 -0400
Date: Fri, 19 Mar 2010 08:13:18 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.34-git
Message-ID: <20100319151318.GB8541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of USB bugfixes and new device ids for your 2.6.34-git
tree.

Biggest here is a rename of a file to allow the xhci driver to follow
the naming convention of the other USB host controller drivers (it is
moving from xhci.ko to xhci-hcd.ko).

The cdc-wdm driver also got a lot of fixes and there is a regression fix
for the usbfs userspace issue that was reported.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-usb |    2 +-
 drivers/usb/class/cdc-acm.c             |    2 +-
 drivers/usb/class/cdc-wdm.c             |  134 ++++++++++++++++++-------------
 drivers/usb/core/devio.c                |   17 +++-
 drivers/usb/core/urb.c                  |    1 +
 drivers/usb/gadget/Kconfig              |    2 +-
 drivers/usb/gadget/epautoconf.c         |    2 +-
 drivers/usb/gadget/f_mass_storage.c     |    3 +-
 drivers/usb/gadget/gadget_chips.h       |    8 ++
 drivers/usb/gadget/goku_udc.c           |    2 +-
 drivers/usb/gadget/multi.c              |    2 -
 drivers/usb/gadget/r8a66597-udc.c       |    1 +
 drivers/usb/host/Makefile               |    4 +-
 drivers/usb/host/ehci-hcd.c             |    2 +-
 drivers/usb/host/ehci-sched.c           |   28 +++++--
 drivers/usb/host/ehci.h                 |    5 +-
 drivers/usb/host/r8a66597-hcd.c         |   16 +++-
 drivers/usb/host/xhci-mem.c             |    9 ++-
 drivers/usb/host/{xhci-hcd.c => xhci.c} |    1 +
 drivers/usb/musb/musb_core.c            |   13 ++-
 drivers/usb/musb/musb_core.h            |    4 +-
 drivers/usb/musb/musb_host.c            |    2 +-
 drivers/usb/musb/musb_regs.h            |   28 +++++++
 drivers/usb/serial/Kconfig              |    4 +-
 drivers/usb/serial/cp210x.c             |    5 -
 drivers/usb/serial/ftdi_sio.c           |    7 +-
 drivers/usb/serial/ftdi_sio_ids.h       |    7 ++
 drivers/usb/serial/generic.c            |   49 ++++++-----
 drivers/usb/serial/option.c             |   53 ++++++++++++-
 drivers/usb/serial/qcserial.c           |   29 +++++++
 drivers/usb/storage/unusual_devs.h      |   23 ++---
 include/linux/usb.h                     |   18 +++-
 32 files changed, 335 insertions(+), 148 deletions(-)
 rename drivers/usb/host/{xhci-hcd.c => xhci.c} (99%)

---------------

Alan Stern (1):
      USB: fix usbfs regression

Alessio Igor Bogani (1):
      USB: ftdi_sio: Fix locking for change_speed() function

Alex Chiang (1):
      USB: xhci: rename driver to xhci_hcd

Andiry Xu (1):
      USB: xHCI: re-initialize cmd_completion

Bernhard Rosenkraenzer (1):
      USB: qcserial: add new device ids

Christoph Egger (1):
      USB: Remove last bit of CONFIG_USB_BERRY_CHARGE

Clemens Ladisch (2):
      USB: EHCI: fix ITD list order
      USB: EHCI: adjust ehci_iso_stream for changes in ehci_qh

Dan Carpenter (1):
      USB: goku_udc: remove potential null dereference

Daniel Sangorrin (1):
      USB: serial: ftdi: add CONTEC vendor and product id

Felipe Balbi (1):
      usb: musb: core: declare mbase only where it's used

Grant Likely (1):
      usb/gadget: fix compile error on r8a66597-udc.c

Huang Ying (1):
      USB: Option: Add support for a variant of DLink DWM 652 U5

Johan Hovold (3):
      USB: serial: fix error message on close in generic driver
      USB: serial: fix softint not being called on errors
      USB: serial: use port endpoint size to determine if ep is available

Matthew Wilcox (1):
      USB: Fix usb_fill_int_urb for SuperSpeed devices

Maurus Cuelenaere (1):
      USB: gadget: add gadget controller number for s3c-hsotg driver

Michael Brunner (1):
      USB: cp210x: Remove double usb_control_msg from cp210x_set_config

Michal Nazarewicz (1):
      USB: g_mass_storage: fixed module name in Kconfig

Mike Frysinger (4):
      usb: musb: abstract out ULPI_BUSCONTROL register reads/writes
      USB: musb: fix warnings in Blackfin regs
      USB: gadget: fix Blackfin builds after gadget cleansing
      USB: g_mass_storage: fix section mismatch warnings

Nathaniel McCallum (3):
      USB: option: fix incorrect manufacturer name in usb/serial/option: MAXON->CMOTECH
      USB: option: move hardcoded PID to a macro in usb/serial/option
      USB: option: add support for a new CMOTECH device to usb/serial/option

Oliver Neukum (9):
      USB: cdc-acm: Fix stupid NULL pointer in resume()
      USB: Fix documentation for avoid_reset_quirk
      usb: cdc-wdm: Fix race between write and disconnect
      usb: cdc-wdm: Fix race between autosuspend and reading from the device
      usb: cdc-wdm: Fix race between disconnect and debug messages
      usb: cdc-wdm: Fix submission of URB after suspension
      usb: cdc-wdm:Fix loss of data due to autosuspend
      usb: cdc-wdm: Fix order in disconnect and fix locking
      usb: cdc-wdm: Fix deadlock between write and resume

Ondrej Zary (1):
      USB: unusual_devs.h: Fix capacity for SL11R-IDE 2.6c

Peter Korsgaard (2):
      USB: gadget: f_mass_storage::fsg_bind(): fix error handling
      USB: gadget/multi: cdc_do_config: remove redundant check

Sarah Sharp (1):
      USB: xhci: Make endpoint interval debugging clearer.

Sonic Zhang (1):
      USB: musb: fix build error introduced by isoc change

Stefan Schmidt (1):
      USB: serial: Fix module name typo for qcaux Kconfig entry.

Tony Lindgren (1):
      usb: musb: Fix compile error for omaps for musb_hdrc

Yoshihiro Shimoda (1):
      usb: r8a66597-hcd: fix removed from an attached hub

spark (1):
      USB: option.c: Add Pirelli VID/PID and indicate Pirelli's modem interface is 0xff

