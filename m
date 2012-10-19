Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2JSS0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:26:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2JSS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:26:11 -0400
Date: Fri, 19 Oct 2012 11:26:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.7-rc2
Message-ID: <20121019182607.GA21191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.7-rc1

for you to fetch changes up to 4b35f1c52943851b310afb09047bfe991ac8f5ae:

  USB: option: add more ZTE devices (2012-10-18 08:27:21 -0700)

----------------------------------------------------------------
USB fixes for 3.7-rc2

Here are the USB patches against your 3.7-rc1 tree.

There are the usual UABI header file movements, and we finally are now
able to remove the dbg() macro that is over 15 years old (that had to
wait for after some other trees got merged into yours during the big
3.7-rc1 merge window.)

Other than that, nothing major, just a number of bugfixes and new device
ids.  It turns out that almost all of the usb-serial drivers had bugs in
how they were handling their internal data, leaking memory, hence all of
those fixups.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: fix port probing and removal in garmin_gps

Alexandre Pereira da Silva (1):
      usb: gadget: lpc32xx_udc: Fix compatibility with STOTG04

Alexis R. Cortes (1):
      usb: host: xhci: New system added for Compliance Mode Patch on SN65LVPE502CP

Bjørn Mork (2):
      USB: option: blacklist net interface on ZTE devices
      USB: option: add more ZTE devices

David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/usb

Felipe Balbi (1):
      usb: dwc3: gadget: fix 'endpoint always busy' bug

Greg Kroah-Hartman (5):
      Merge tag 'for-usb-linus-2012-10-11' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'disintegrate-usb-20121009' of git://git.infradead.org/users/dhowells/linux-headers into usb-linus
      Merge 3.7-rc1 usb-linus
      USB: usb.h: remove dbg() macro
      Merge tag 'fixes-for-v3.7-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus

Henrik Rydberg (1):
      usbdevfs: Fix broken scatter-gather transfer

Johan Hovold (19):
      USB: ark3116: fix NULL-pointer dereference
      USB: cyberjack: fix port-data memory leak
      USB: belkin_sa: fix port-data memory leak
      USB: cp210x: fix port-data memory leak
      USB: pl2303: fix port-data memory leak
      USB: cypress_m8: fix port-data memory leak
      USB: kobil_sct: fix port-data memory leak
      USB: io_edgeport: fix port-data memory leak
      USB: f81232: fix port-data memory leak
      USB: keyspan_pda: fix port-data memory leak
      USB: io_ti: fix port-data memory leak
      USB: kl5kusb105: fix port-data memory leak
      USB: iuu_phoenix: fix port-data memory leak
      USB: oti6858: fix port-data memory leak
      USB: ti_usb_3410_5052: fix port-data memory leak
      USB: ssu100: fix port-data memory leak
      USB: spcp8x5: fix port-data memory leak
      USB: iuu_phoenix: fix sysfs-attribute creation
      USB: io_ti: fix sysfs-attribute creation

Kuninori Morimoto (2):
      usb: renesas_usbhs: fixup __usbhs_for_each_pipe 1st pos
      usb: renesas_usbhs: fixup interrupt status clear method

Laurent Pinchart (2):
      usb: gadget: Make webcam gadget select USB_LIBCOMPOSITE
      MAINTAINERS: Add maintainer entry for the USB webcam gadget

Ming Lei (1):
      USB: cdc-acm: fix pipe type of write endpoint

Nicolas Boullis (1):
      usb: acm: fix the computation of the number of data bits

Sarah Sharp (4):
      USB: Enable LPM after a failed probe.
      usb: Don't enable LPM if the exit latency is zero.
      usb: Send Set SEL before enabling parent U1/U2 timeout.
      usb: trival: Fix debugging units mistake.

Stefano Babic (1):
      usb: musb: am35xx: drop spurious unplugging a device

Tony Prisk (2):
      usb: Missing dma_mask in uhci-platform.c when probed from device-tree
      usb: Missing dma_mask in ehci-vt8500.c when probed from device-tree

Vivek Gautam (1):
      usb: dwc3: shutdown usb_phy when removing the device

 MAINTAINERS                              |   7 +
 drivers/usb/class/cdc-acm.c              |  22 ++-
 drivers/usb/core/devio.c                 |   1 +
 drivers/usb/core/driver.c                |   4 +
 drivers/usb/core/hub.c                   |  36 ++--
 drivers/usb/dwc3/core.c                  |   4 +
 drivers/usb/dwc3/gadget.c                |   2 +-
 drivers/usb/gadget/Kconfig               |   1 +
 drivers/usb/gadget/lpc32xx_udc.c         |   4 +-
 drivers/usb/host/ehci-vt8500.c           |  10 ++
 drivers/usb/host/uhci-platform.c         |   9 +
 drivers/usb/host/xhci.c                  |   3 +-
 drivers/usb/musb/am35x.c                 |   6 +
 drivers/usb/renesas_usbhs/mod.c          |   6 +-
 drivers/usb/renesas_usbhs/pipe.h         |   2 +-
 drivers/usb/serial/ark3116.c             |  26 +--
 drivers/usb/serial/belkin_sa.c           |  31 ++--
 drivers/usb/serial/cp210x.c              |  40 ++---
 drivers/usb/serial/cyberjack.c           |  49 +++---
 drivers/usb/serial/cypress_m8.c          |  75 ++++----
 drivers/usb/serial/f81232.c              |  43 ++---
 drivers/usb/serial/garmin_gps.c          |  24 +--
 drivers/usb/serial/io_edgeport.c         |  54 +++---
 drivers/usb/serial/io_tables.h           |   8 +
 drivers/usb/serial/io_ti.c               |  91 +++++-----
 drivers/usb/serial/iuu_phoenix.c         |  76 ++++-----
 drivers/usb/serial/keyspan_pda.c         |  30 ++--
 drivers/usb/serial/kl5kusb105.c          |  68 +++-----
 drivers/usb/serial/kobil_sct.c           |  23 +--
 drivers/usb/serial/option.c              |  84 ++++++---
 drivers/usb/serial/oti6858.c             |  68 +++-----
 drivers/usb/serial/pl2303.c              |  90 ++++++----
 drivers/usb/serial/spcp8x5.c             |  46 ++---
 drivers/usb/serial/ssu100.c              |  34 ++--
 drivers/usb/serial/ti_usb_3410_5052.c    |  88 +++++-----
 include/linux/usb.h                      |  11 --
 include/linux/usb/Kbuild                 |  10 --
 include/linux/usb/audio.h                | 524 +-------------------------------------------------------
 include/linux/usb/ch9.h                  | 960 +-----------------------------------------------------------------------------------------------------
 include/linux/usb/functionfs.h           | 167 +-----------------
 include/uapi/linux/usb/Kbuild            |  10 ++
 include/uapi/linux/usb/audio.h           | 545 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/{ => uapi}/linux/usb/cdc.h       |   0
 include/{ => uapi}/linux/usb/ch11.h      |   0
 include/uapi/linux/usb/ch9.h             | 993 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/usb/functionfs.h      | 169 ++++++++++++++++++
 include/{ => uapi}/linux/usb/g_printer.h |   0
 include/{ => uapi}/linux/usb/gadgetfs.h  |   0
 include/{ => uapi}/linux/usb/midi.h      |   0
 include/{ => uapi}/linux/usb/tmc.h       |   0
 include/{ => uapi}/linux/usb/video.h     |   0
 51 files changed, 2333 insertions(+), 2221 deletions(-)
 create mode 100644 include/uapi/linux/usb/audio.h
 rename include/{ => uapi}/linux/usb/cdc.h (100%)
 rename include/{ => uapi}/linux/usb/ch11.h (100%)
 create mode 100644 include/uapi/linux/usb/ch9.h
 create mode 100644 include/uapi/linux/usb/functionfs.h
 rename include/{ => uapi}/linux/usb/g_printer.h (100%)
 rename include/{ => uapi}/linux/usb/gadgetfs.h (100%)
 rename include/{ => uapi}/linux/usb/midi.h (100%)
 rename include/{ => uapi}/linux/usb/tmc.h (100%)
 rename include/{ => uapi}/linux/usb/video.h (100%)
