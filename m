Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab2HQRNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:13:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42666 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2HQRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:12:56 -0400
Date: Fri, 17 Aug 2012 10:12:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.6-rc3
Message-ID: <20120817171245.GA13930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.6-rc3

for you to fetch changes up to 731879f8e3d4c61220462160311fa650a8b96abf:

  USB: qcserial: fix port handling on Gobi 1K and 2K+ (2012-08-16 09:48:03 -0700)

----------------------------------------------------------------
USB patches for 3.6-rc3

Here are a number of small USB patches for 3.6-rc3.  The "large" one is just a
number of device id updates to the option driver, done by the manufacturer,
properly fixing up the device ids based on shipping devices.  Other than that,
some gadget driver fixes, the obligitary XHCI patches, and some other device
ids and bugs fixed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ajay Kumar Gupta (3):
      usb: musb: Fix wrong config for am33xx and ti81xx
      usb: musb: am335x: fix pdev resource bug
      usb: musb: reorder runtime pm call

Bjørn Mork (4):
      usb: usb_wwan: replace release and disconnect with a port_remove hook
      usb: serial: prevent suspend/resume from racing against probe/remove
      usb: usb_wwan: resume/suspend can be called after port is gone
      USB: option: add ZTE K5006-Z

Bruno Morelli (1):
      USB: isp1362-hcd.c: usb message always saved in case of underrun

Dan Williams (1):
      USB: qcserial: fix port handling on Gobi 1K and 2K+

Greg Kroah-Hartman (3):
      Merge tag 'fixes-for-v3.6-rc1' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2012-08-08' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'for-usb-linus-2012-08-09' of git://git.kernel.org/.../sarah/xhci into usb-linus

Keshava Munegowda (1):
      OMAP: USB : Fix the EHCI enumeration and core retention issue

Kuninori Morimoto (2):
      usb: renesas_usbhs: mod_host: add missing .bus_suspend/resume
      usb: renesas_usbhs: fixup resume method for autonomy mode

Marc Kleine-Budde (1):
      usb: chipidea: fix and improve dependencies if usb host or gadget support is built as module

Mark Ferrell (2):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()
      USB: serial: Fix mos7840 timeout

Michael Grzeschik (1):
      usb: gadget: u_ether: fix kworker 100% CPU issue with still used interfaces in eth_stop

Oliver Neukum (1):
      update MAINTAINERS for Oliver Neukum

Ozan Çağlayan (1):
      USB: ftdi_sio: Add VID/PID for Kondo Serial USB

Sarah Sharp (5):
      xhci: Increase reset timeout for Renesas 720201 host.
      xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.
      xhci: Rate-limit XHCI_TRUST_TX_LENGTH quirk warning.
      xhci: Fix bug after deq ptr set to link TRB.
      xhci: Switch PPT ports to EHCI on shutdown.

Steven J. Hill (1):
      usb: host: mips: sead3: Update for EHCI register structure.

Venu Byravarasu (1):
      usb: host: tegra: fix warning messages in ehci_remove

fangxiaozhi (1):
      USB: support the new interfaces of Huawei Data Card devices in option driver

 MAINTAINERS                          |  10 +-
 drivers/usb/chipidea/Kconfig         |   9 +-
 drivers/usb/gadget/u_ether.c         |   6 +
 drivers/usb/host/ehci-omap.c         | 167 +-------------------
 drivers/usb/host/ehci-sead3.c        |   2 +-
 drivers/usb/host/ehci-tegra.c        |   3 +-
 drivers/usb/host/isp1362-hcd.c       |   8 +-
 drivers/usb/host/pci-quirks.c        |   7 +
 drivers/usb/host/pci-quirks.h        |   1 +
 drivers/usb/host/xhci-pci.c          |  10 ++
 drivers/usb/host/xhci-ring.c         |  40 +++--
 drivers/usb/host/xhci.c              |   8 +-
 drivers/usb/host/xhci.h              |   3 +
 drivers/usb/musb/Kconfig             |   4 +-
 drivers/usb/musb/musb_dsps.c         |  19 +--
 drivers/usb/renesas_usbhs/common.c   |   6 +-
 drivers/usb/renesas_usbhs/mod_host.c |   8 +
 drivers/usb/serial/bus.c             |  15 +-
 drivers/usb/serial/ftdi_sio.c        |   1 +
 drivers/usb/serial/ftdi_sio_ids.h    |   7 +
 drivers/usb/serial/ipw.c             |   3 +-
 drivers/usb/serial/mos7840.c         |  16 +-
 drivers/usb/serial/option.c          | 285 ++++++++++++++---------------------
 drivers/usb/serial/qcserial.c        |  47 +++---
 drivers/usb/serial/usb-wwan.h        |   3 +-
 drivers/usb/serial/usb_wwan.c        |  68 ++++-----
 26 files changed, 299 insertions(+), 457 deletions(-)
