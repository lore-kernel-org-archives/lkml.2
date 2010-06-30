Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab0F3PYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:24:46 -0400
Received: from kroah.org ([198.145.64.141]:39956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab0F3PY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:24:27 -0400
Date: Wed, 30 Jun 2010 08:23:26 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.35-git
Message-ID: <20100630152326.GB11236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few USB bugfixes for your 2.6.35-git tree.

The most changes here are in the gadget drivers, but there are also a
number of other needed fixes as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/driver.c           |   13 +--
 drivers/usb/core/message.c          |    7 +-
 drivers/usb/gadget/f_eem.c          |    3 +-
 drivers/usb/gadget/f_mass_storage.c |  194 +++++++++++++----------------------
 drivers/usb/gadget/g_ffs.c          |   11 ++
 drivers/usb/gadget/printer.c        |   32 +++---
 drivers/usb/gadget/s3c2410_udc.c    |    6 +-
 drivers/usb/gadget/u_serial.c       |   16 +---
 drivers/usb/host/ehci-mxc.c         |   13 ++-
 drivers/usb/host/isp1362-hcd.c      |   15 ++-
 drivers/usb/host/r8a66597-hcd.c     |    2 +-
 drivers/usb/host/xhci-ring.c        |   62 ++++++++---
 drivers/usb/musb/musb_core.c        |   13 +--
 drivers/usb/musb/musb_core.h        |    6 +-
 drivers/usb/musb/musbhsdma.c        |   13 +--
 drivers/usb/otg/ulpi.c              |   15 ++-
 drivers/usb/serial/ftdi_sio.c       |    1 -
 drivers/usb/serial/ftdi_sio_ids.h   |    7 --
 drivers/usb/serial/qcserial.c       |    3 +
 19 files changed, 208 insertions(+), 224 deletions(-)

---------------

Alan Stern (2):
      USB: fix oops in usb_sg_init()
      USB: obey the sysfs power/wakeup setting

Axel Lin (1):
      USB: qcserial: fix a memory leak in qcprobe error path

Daniel Sangorrin (1):
      USB: serial: ftdi: correct merge conflict with CONTEC id

Hema HK (1):
      USB: musb: Enable the maximum supported burst mode for DMA

Jiri Pinkava (1):
      USB: gadget eth: Fix calculate CRC32 in EEM

Jiri Slaby (2):
      USB: isp1362-hcd, fix double lock
      USB: gadget/printer, fix sleep inside atomic

Jon Povey (2):
      USB: g_serial: don't set low_latency flag
      USB: g_serial: fix tty cleanup on unload

Maulik Mankad (1):
      usb: musb: Fix a bug by making suspend interrupt available in device mode

Michal Nazarewicz (3):
      USB: gadget: g_fs: possible invalid pointer reference bug fixed
      USB: gadget: f_mass_storage: fixed fs descriptors not being updated
      USB: gadget: f_mass_storage: stale common->fsg value bug fix

Mike Frysinger (1):
      USB: musb: fix Blackfin ulpi stubs

Nobuhiro Iwamatsu (1):
      USB: r8a66597: Fix failure in change of status

Sarah Sharp (1):
      USB: xHCI: Fix bug in link TRB activation change.

Sergei Shtylyov (2):
      USB: musb_core: make disconnect and suspend interrupts work again
      USB: MUSB: make non-OMAP platforms build with CONFIG_PM=y

Vladimir Zapolskiy (1):
      USB: s3c2410: deactivate endpoints before gadget unbinding

Wolfram Sang (2):
      USB: otg/ulpi: bail out on read errors
      USB: ehci-mxc: bail out on transceiver problems

