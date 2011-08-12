Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1HLVYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:24:32 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45314 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab1HLVYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:24:30 -0400
X-Sasl-enc: s0lIwt7KUAQ62Zeaa2G39uMMOy6zn6tpcjqPfBSXR99m 1313184268
Date: Fri, 12 Aug 2011 14:22:49 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.1
Message-ID: <20110812212249.GB7044@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some fixes for your 3.1 git tree for the USB subsystem.

Lots of little things, nothing really major, just stuff people reported,
and some new device ids.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All have been in the -next releases for a while now.

thanks,

greg k-h

------------

 drivers/usb/class/usbtmc.c             |    2 +-
 drivers/usb/core/config.c              |   11 ++--
 drivers/usb/gadget/Kconfig             |    2 +-
 drivers/usb/gadget/at91_udc.c          |    1 +
 drivers/usb/gadget/composite.c         |    6 +-
 drivers/usb/gadget/f_hid.c             |    7 ++
 drivers/usb/gadget/fusb300_udc.c       |  101 --------------------------------
 drivers/usb/gadget/net2272.c           |    2 +-
 drivers/usb/gadget/s3c2410_udc.c       |    1 +
 drivers/usb/host/ehci-hub.c            |   12 ++++
 drivers/usb/host/ehci-mxc.c            |    1 +
 drivers/usb/host/ehci-omap.c           |   16 +++++
 drivers/usb/host/isp1760-hcd.c         |    3 +
 drivers/usb/host/pci-quirks.c          |    4 +-
 drivers/usb/host/xhci.c                |   19 +++++--
 drivers/usb/musb/Kconfig               |    3 -
 drivers/usb/musb/musb_gadget.c         |    5 ++
 drivers/usb/musb/tusb6010_omap.c       |    2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c |    3 +-
 drivers/usb/serial/ftdi_sio.c          |    8 ++-
 drivers/usb/serial/ftdi_sio_ids.h      |    6 ++-
 drivers/usb/serial/option.c            |   12 ++++
 drivers/usb/serial/qcserial.c          |    2 +
 drivers/usb/storage/unusual_devs.h     |   10 +++
 24 files changed, 113 insertions(+), 126 deletions(-)

---------------

Andrew Bird (4):
      USB: option driver: add PID for Vodafone-Huawei K3770
      USB: option driver: add PID for Vodafone-Huawei K3771
      USB: option driver: add PID for Vodafone-Huawei K4510
      USB: option driver: add PID for Vodafone-Huawei K4511

Arnaud Lacombe (1):
      usb/host/pci-quirks.c: correct annotation of `ehci_dmi_nohandoff_table'

Artur Zimmer (1):
      USB: Serial: Add PID(0xF7C0) to FTDI SIO driver for a zeitcontrol-device

Arvid Brodin (1):
      usb/isp1760: Added missing call to usb_hcd_check_unlink_urb() during unlink

Axel Lin (1):
      usb: gadget: s3c2410_udc: fix unterminated platform_device_id table

Boris Todorov (1):
      USB: EHCI: Fix test mode sequence

Florian Echtler (1):
      USB: Serial: Add device ID for Sierra Wireless MC8305

Geert Uytterhoeven (1):
      usb: gadget: net2272 - Correct includes

Ionut Nicu (1):
      USB: ftdi_sio: fix minor typo in get_ftdi_divisor

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: at91_udc: include linux/prefetch.h explicitly

JiSheng Zhang (1):
      USB: xhci: fix OS want to own HC

John Stultz (1):
      usb: musb: fix oops on musb_gadget_pullup

Kuninori Morimoto (2):
      usb: renesas_usbhs: fix DMA build by including dma-mapping.h
      usb: renesas_usbhs: fixup usbhsg_for_each_uep 1st pos

Maxim Nikulin (1):
      USB: assign instead of equal in usbtmc.c

Ming Lei (1):
      usb: host: ehci-omap: fix .remove and failure handling path of .probe(v1)

Nick Bowler (1):
      USB: usb-storage: unusual_devs entry for ARM V2M motherboard.

Rabin Vincent (1):
      usb: musb: fix Kconfig

Sarah Sharp (1):
      xhci: Don't submit commands or URBs to halted hosts.

Sebastian Andrzej Siewior (3):
      usb/config: use proper endian access for wMaxPacketSize
      usb: gadget: fusb300: remove #if 0 block
      usb: gadget: composite: fix bMaxPacketSize for SuperSpeed

Sebastian Bauer (1):
      usb: gadget: hid: don't STALL when processing a HID Descriptor request

Sergei Trofimovich (1):
      usb: musb: tusb6010_omap: fix build failure: error: 'musb' undeclared

Shawn Guo (1):
      usb/ehci-mxc: add missing inclusion of mach/hardware.h

Uwe Bonnes (1):
      usb: serial: ftdi_sio.c: For the FT232H FTDI_SIO_SET_BAUDRATE_REQUEST, index needs to be shifted too

Vijay Chavan (1):
      USB: Serial: Added device ID for Qualcomm Modem in Sagemcom's HiLo3G

