Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab2JZRSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:18:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:59982 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829Ab2JZRSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:18:03 -0400
Date: Fri, 26 Oct 2012 10:17:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.7-rc3
Message-ID: <20121026171743.GA11426@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.7-rc3

for you to fetch changes up to 1d63f24697b1259921f08ad3684502216c1cd793:

  Merge tag 'for-usb-linus-2012-10-25' of git://git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci into usb-linus (2012-10-25 13:34:25 -0700)

----------------------------------------------------------------

USB fixes for 3.7-rc3

Here are a bunch of USB fixes for the 3.7-rc tree.

There's a lot of small USB serial driver fixes, and one larger one (the mos7840
driver changes are mostly just moving code around to fix problems.)  Thanks to
Johan Hovold for finding the problems and fixing them all up.

Other than those, there is the usual new device ids, xhci bugfixes, and gadget
driver fixes, nothing out of the ordinary.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Anisse Astier (2):
      ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions
      ehci: Add yet-another Lucid nohandoff pci quirk

Daniel Mack (1):
      usb: musb: dsps: fix res_name length

Dave Jones (1):
      USB: Add missing license tag to ezusb driver.

Greg Kroah-Hartman (3):
      Merge tag 'fixes-for-v3.7-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2012-10-23' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'for-usb-linus-2012-10-25' of git://git.kernel.org/.../sarah/xhci into usb-linus

Johan Hovold (30):
      USB: metro-usb: fix port-data memory leak
      USB: metro-usb: fix io after disconnect
      USB: whiteheat: fix memory leak in error path
      USB: whiteheat: fix port-data memory leak
      USB: ch341: fix port-data memory leak
      USB: digi_acceleport: fix port-data memory leak
      USB: mos7720: fix port-data memory leak
      USB: omninet: fix port-data memory leak
      USB: quatech2: fix memory leak in error path
      USB: quatech2: fix port-data memory leaks
      USB: quatech2: fix close and disconnect urb handling
      USB: quatech2: fix io after disconnect
      USB: opticon: fix DMA from stack
      USB: opticon: fix memory leak in error path
      USB: mct_u232: fix port-data memory leak
      USB: mct_u232: fix broken close
      USB: keyspan: fix NULL-pointer dereferences and memory leaks
      USB: usb-wwan: fix multiple memory leaks in error paths
      USB: sierra: fix memory leak in attach error path
      USB: sierra: fix memory leak in probe error path
      USB: sierra: fix port-data memory leak
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: ipw: fix interface-data memory leak in error path
      USB: option: fix interface-data memory leak in error path
      USB: qcserial: fix interface-data memory leak in error path
      USB: mos7840: remove NULL-urb submission
      USB: mos7840: remove invalid disconnect handling
      USB: mos7840: fix port-data memory leak
      USB: mos7840: fix port_probe flow

Kuninori Morimoto (2):
      usb: renesas_usbhs: fixup: avoid NULL access on error case pipe detach
      usb: renesas_usbhs: fixup dma transfer stall

Lan Tianyu (2):
      usb/xhci: release xhci->lock during turning on/off usb port's acpi power resource and checking the existence of port's power resource
      usb/xhci: Remove (__force__ __u16) before assigning DeviceRemovable and assign directly.

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Octavian Purdila (2):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear work
      usb hub: use flush_work instead of flush_work_sync

Oliver Neukum (2):
      xhci: endianness xhci_calculate_intel_u2_timeout
      xhci: fix integer overflow

Sarah Sharp (4):
      xhci: Fix potential NULL ptr deref in command cancellation.
      xhci: Fix missing break in xhci_evaluate_context_result.
      xhci: trivial: Remove assigned but unused slot_ctx.
      xhci: trivial: Remove assigned but unused ep_ctx.

Wei Yongjun (1):
      usb: gadget: net2272: fix missing unlock on error in net2272_irq()

 drivers/usb/core/hub.c               |   7 +-
 drivers/usb/gadget/net2272.c         |   4 +-
 drivers/usb/host/pci-quirks.c        |   9 +-
 drivers/usb/host/xhci-dbg.c          |   2 -
 drivers/usb/host/xhci-hub.c          |   9 +-
 drivers/usb/host/xhci-ring.c         |  11 +++
 drivers/usb/host/xhci.c              |   8 +-
 drivers/usb/misc/ezusb.c             |   1 +
 drivers/usb/musb/musb_dsps.c         |   8 +-
 drivers/usb/renesas_usbhs/fifo.c     |   1 +
 drivers/usb/renesas_usbhs/mod_host.c |   5 +
 drivers/usb/serial/ch341.c           |  23 +++--
 drivers/usb/serial/digi_acceleport.c | 117 ++++++++++++----------
 drivers/usb/serial/ipw.c             |   7 +-
 drivers/usb/serial/keyspan.c         | 181 +++++++++++++++++-----------------
 drivers/usb/serial/keyspan.h         |   8 ++
 drivers/usb/serial/mct_u232.c        |  59 ++++++-----
 drivers/usb/serial/metro-usb.c       |  65 ++++--------
 drivers/usb/serial/mos7720.c         |  62 ++++++------
 drivers/usb/serial/mos7840.c         | 495 +++++++++++++++++++++++++++++++++++++++-----------------------------------------------------
 drivers/usb/serial/omninet.c         |  36 +++----
 drivers/usb/serial/opticon.c         |  11 ++-
 drivers/usb/serial/option.c          |  23 ++++-
 drivers/usb/serial/qcserial.c        |  33 ++++---
 drivers/usb/serial/quatech2.c        | 135 ++++++++++++-------------
 drivers/usb/serial/sierra.c          | 133 +++++++++++++------------
 drivers/usb/serial/usb-wwan.h        |   2 +-
 drivers/usb/serial/usb_wwan.c        | 124 ++++++++++-------------
 drivers/usb/serial/whiteheat.c       |  60 +++++-------
 drivers/usb/storage/unusual_devs.h   |   6 ++
 30 files changed, 798 insertions(+), 847 deletions(-)
