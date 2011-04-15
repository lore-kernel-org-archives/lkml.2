Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1DPAAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 20:00:00 -0400
Received: from kroah.org ([198.145.64.141]:53932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1DOX76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:59:58 -0400
Date: Fri, 15 Apr 2011 16:59:43 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .39
Message-ID: <20110415235943.GA23557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a number of fixes for USB stuff for your .39 tree.

There are a lot of little things, new device ids and minor fixes.  The
larger stuff is USB 3.0 fixes that resolve a large number of reported
issues. The pci quirks change also resolves a problem reported by a
number of people.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these have been in the linux-next tree for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 arch/microblaze/Kconfig           |    1 -
 drivers/usb/Kconfig               |    1 +
 drivers/usb/core/devices.c        |   10 +-
 drivers/usb/core/hcd.c            |    2 +-
 drivers/usb/core/hub.c            |   12 ++-
 drivers/usb/gadget/f_audio.c      |    1 +
 drivers/usb/gadget/f_eem.c        |    8 +-
 drivers/usb/gadget/fsl_qe_udc.c   |   20 +++-
 drivers/usb/gadget/inode.c        |    4 +-
 drivers/usb/gadget/pch_udc.c      |    8 +-
 drivers/usb/gadget/r8a66597-udc.c |    2 +
 drivers/usb/host/ehci-q.c         |   15 ++-
 drivers/usb/host/isp1760-hcd.c    |    2 +-
 drivers/usb/host/ohci-au1xxx.c    |    2 +-
 drivers/usb/host/pci-quirks.c     |  117 +++++++++++++-------
 drivers/usb/host/xhci-mem.c       |  106 ++++++++++++------
 drivers/usb/host/xhci-pci.c       |    4 +
 drivers/usb/host/xhci-ring.c      |  219 ++++++++++++++++++++++--------------
 drivers/usb/host/xhci.c           |   23 +++-
 drivers/usb/host/xhci.h           |   11 ++-
 drivers/usb/musb/Kconfig          |    6 +-
 drivers/usb/musb/blackfin.c       |   24 ++++
 drivers/usb/musb/cppi_dma.c       |   27 +++--
 drivers/usb/musb/musb_core.c      |    2 +
 drivers/usb/musb/musb_core.h      |    5 +
 drivers/usb/musb/musb_gadget.c    |    4 +-
 drivers/usb/musb/musbhsdma.c      |    8 ++
 drivers/usb/musb/omap2430.c       |    3 +-
 drivers/usb/musb/ux500.c          |    2 +
 drivers/usb/serial/ftdi_sio.c     |    5 +
 drivers/usb/serial/ftdi_sio_ids.h |   12 ++
 drivers/usb/serial/option.c       |    5 +
 drivers/usb/serial/qcserial.c     |   31 ++++-
 33 files changed, 483 insertions(+), 219 deletions(-)

---------------

Alan Stern (1):
      USB: EHCI: unlink unused QHs when the controller is stopped

Alexey Khoroshilov (1):
      USB: usb-gadget: unlock data->lock mutex on error path in ep_read()

Andiry Xu (2):
      usbcore: Bug fix: system can't suspend with USB3.0 device connected to USB3.0 hub
      xHCI: Implement AMD PLL quirk

Christian Simon (1):
      USB: ftdi_sio: Added IDs for CTI USB Serial Devices

Dan Carpenter (6):
      USB: musb: add missing unlock in cppi_interrupt()
      USB: musb: using 0 instead of NULL
      USB: musb: silence printk format warning
      USB: musb: dereferencing an iomem pointer
      usb: pch_udc: unlock on allocation failure
      USB: xhci: unsigned char never equals -1

Dmitry Torokhov (6):
      USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
      USB: xhci - fix unsafe macro definitions
      USB: xhci - remove excessive 'inline' markings
      USB: xhci: simplify logic of skipping missed isoc TDs
      USB: xhci - fix math in xhci_get_endpoint_interval()
      USB: xhci - also free streams when resetting devices

Felipe Balbi (2):
      usb: musb: temporarily make it bool
      usb: musb: gadget: check the correct list_head

Greg Kroah-Hartman (1):
      Revert "USB: isp1760-hcd: move imask clear after pending work is done"

Hema HK (1):
      usb: musb: Fix the crash issue during reboot

Joerg Roedel (1):
      USB host: Fix lockdep warning in AMD PLL quirk

Johan Hovold (2):
      usb: musb: omap2430: fix build failure
      USB: ftdi_sio: add PID for OCT DK201 docking station

Marius B. Kotsbak (1):
      USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.

Matthew Wilcox (1):
      USB: Fix unplug of device with active streams

Mian Yousaf Kaukab (2):
      usb: musb: clear AUTOSET while clearing DMAENAB
      usb: musb: ux500: copy dma mask from platform device to musb device

Michal Simek (1):
      usb: Fix Kconfig unmet dependencies for Microblaze EHCI

Mike Frysinger (1):
      USB: musb: blackfin: work around anomaly 05000450

Paul Friedrich (1):
      USB: ftdi_sio: add ids for Hameg HO720 and HO730

Randy Dunlap (1):
      usb: fix ips1760-hcd printk format warning

Richard Retanubun (1):
      USB: isp1760-hcd: move imask clear after pending work is done

Sarah Sharp (2):
      xhci: Fix NULL pointer deref in handle_port_status()
      xhci: Tell USB core both roothubs lost power.

Sebastian Andrzej Siewior (1):
      usb/gadget: don't leak hs_descriptors

Steven Hardy (3):
      usb: Fix qcserial memory leak on rmmod
      usb: qcserial avoid pointing to freed memory
      usb: qcserial add missing errorpath kfrees

Valentin Longchamp (1):
      USB: fsl_qe_udc: send ZLP when zero flag and length % maxpacket == 0

Yauheni Kaliuta (1):
      usb: gadget: eem: fix echo command processing

Yoichi Yuasa (1):
      USB: ohci-au1xxx: fix warning "__BIG_ENDIAN" is not defined

Yoshihiro Shimoda (1):
      usb: r8a66597-udc: fix spinlock usage

