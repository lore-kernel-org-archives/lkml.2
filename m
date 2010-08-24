Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab0HXEFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:05:22 -0400
Received: from kroah.org ([198.145.64.141]:39647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab0HXEFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:05:21 -0400
Date: Mon, 23 Aug 2010 21:04:58 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .36-rc2
Message-ID: <20100824040458.GA16749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some usb driver fixes for .36-rc2.

The big one overall is a bunch of fixes for the new ssu100 driver to
make it work properly, as well as some ARM build fixes, and other
minor things as well as some device ids added.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 arch/arm/mach-imx/mach-cpuimx27.c  |    4 +-
 arch/arm/mach-imx/mach-pca100.c    |    4 +-
 arch/arm/mach-mx25/mach-cpuimx25.c |    2 +-
 arch/arm/mach-mx3/mach-cpuimx35.c  |    2 +-
 drivers/usb/gadget/composite.c     |    4 +-
 drivers/usb/gadget/m66592-udc.c    |    1 +
 drivers/usb/gadget/r8a66597-udc.c  |    1 +
 drivers/usb/gadget/uvc_v4l2.c      |    2 +-
 drivers/usb/host/isp1760-hcd.c     |    2 +
 drivers/usb/host/xhci-ring.c       |    6 +-
 drivers/usb/misc/adutux.c          |    2 +-
 drivers/usb/misc/iowarrior.c       |    4 +-
 drivers/usb/otg/twl4030-usb.c      |    6 +-
 drivers/usb/serial/cp210x.c        |    4 +-
 drivers/usb/serial/ftdi_sio.c      |    5 +-
 drivers/usb/serial/ftdi_sio_ids.h  |    9 ++
 drivers/usb/serial/generic.c       |    1 +
 drivers/usb/serial/io_ti.c         |    4 +-
 drivers/usb/serial/navman.c        |    1 +
 drivers/usb/serial/option.c        |    7 +-
 drivers/usb/serial/pl2303.c        |    1 +
 drivers/usb/serial/pl2303.h        |    4 +
 drivers/usb/serial/ssu100.c        |  254 +++++++++++++++++++++++-------------
 drivers/usb/serial/usb-serial.c    |   23 +---
 include/linux/usb/composite.h      |    1 +
 25 files changed, 228 insertions(+), 126 deletions(-)

---------------

Andiry Xu (1):
      USB: xHCI: update ring dequeue pointer when process missed tds

Axel Lin (1):
      USB: r8a66597-udc: return -ENOMEM if kzalloc() fails

Bill Pemberton (8):
      USB: ssu100: add locking for port private data in ssu100
      USB: ssu100: refine process_packet in ssu100
      USB: ssu100: remove duplicate #defines in ssu100
      USB: ssu100: add register parameter to ssu100_setregister
      USB: ssu100: rework logic for TIOCMIWAIT
      USB: serial: export symbol usb_serial_generic_disconnect
      USB: ssu100: add disconnect function for ssu100
      USB: ssu100: set tty_flags in ssu100_process_packet

Craig Shelley (1):
      USB: CP210x Fix Break On/Off

Dan Carpenter (1):
      USB: uvc_v4l2: cleanup test for end of loop

Felipe Balbi (1):
      USB: otg: twl4030: fix wrong assumption of starting state

Galen Seitz (1):
      USB: ftdi_sio: add product ID for Lenz LI-USB

Greg Kroah-Hartman (1):
      USB: io_ti: check firmware version before updating

Jef Driesen (1):
      USB: pl2303: New vendor and product id

John Youn (1):
      USB: xhci: Remove buggy assignment in next_trb()

Julia Lawall (1):
      USB: gadget: Return -ENOMEM on memory allocation failure

Kulikov Vasiliy (2):
      USB: iowarrior: fix misuse of return value of copy_to_user()
      USB: adutux: fix misuse of return value of copy_to_user()

Martin Michlmayr (1):
      USB: ftdi_sio: Add ID for Ionics PlugComputer

Michael Hennerich (1):
      USB: isp1760: use a write barrier to ensure proper ndelay timing

Michael Tokarev (1):
      USB: option: add Celot CT-650

Michael Wileczka (1):
      USB: ftdi_sio: fix endianess of max packet size

Ming Lei (1):
      USB: serial: fix leak of usb serial module refrence count

Randy Dunlap (1):
      USB: gadget: fix composite kernel-doc warnings

Roel Kluin (1):
      USB: serial: io_ti.c: don't return 0 if writing the download record failed

Ross Burton (1):
      USB: add device IDs for igotu to navman

Uwe Kleine-König (1):
      ARM: imx: fix build failure concerning otg/ulpi

