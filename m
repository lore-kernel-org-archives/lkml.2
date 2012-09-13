Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2IMRqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:46:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58202 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2IMRqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:46:03 -0400
Date: Thu, 13 Sep 2012 10:45:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.6-rc6
Message-ID: <20120913174558.GA21974@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.6-rc6

for you to fetch changes up to 38bb2ca69d5b6db712688a538daa5142abf6d590:

  Merge branch 'chipidea-stable' into usb-linus (2012-09-12 11:12:31 -0700)

----------------------------------------------------------------

USB patches for 3.6-rc6

Here are a number of USB patches, a bit more than I normally like this
late in the -rc series, but given people's vacations (myself included),
and the kernel summit, it seems to have happened this way.

All are tiny, but they add up.  A number of gadget and xhci fixes, and a
few new device ids.  All have been tested in linux-next.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: add device quirk for Joss Optical touchboard

Alexis R. Cortes (1):
      usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP Hardware

Andrzej Pietrasiewicz (1):
      usb: gadget: add multiple definition guards

Bjørn Mork (3):
      USB: ftdi_sio: do not claim CDC ACM function
      USB: cdc-wdm: fix wdm_find_device* return value
      USB: option: replace ZTE K5006-Z entry with vendor class rule

Dan Carpenter (1):
      xhci: Fix a logical vs bitwise AND bug

Greg Kroah-Hartman (3):
      Merge tag 'for-usb-linus-2012-09-05' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'fixes-for-v3.6-rc4' of git://git.kernel.org/.../balbi/usb into work-linus
      Merge branch 'chipidea-stable' into usb-linus

Horst Schirmeier (1):
      USB: ftdi_sio: PID for NZR SEM 16+ USB

Julia Lawall (1):
      usb: gadget: s3c-hsotg.c: fix error return code

Keng-Yu Lin (1):
      Intel xhci: Only switch the switchable ports

Kishon Vijay Abraham I (1):
      usb: dwc3: core: fix incorrect usage of resource pointer

Kuninori Morimoto (1):
      usb: renesas_usbhs: fixup DMA transport data alignment

Manoj Iyer (1):
      xhci: Recognize USB 3.0 devices as superspeed at powerup

Marc Kleine-Budde (2):
      usb: chipidea: udc: fix error path in udc_start()
      usb: chipidea: cleanup dma_pool if udc_start() fails

Matthew Garrett (1):
      xhci: Make handover code more robust

Michael Grzeschik (3):
      usb: chipidea: udc: fix setup of endpoint maxpacket size
      usb: chipidea: udc: add pullup fuction, needed by the uvc gadget
      usb: chipidea: udc: don't stall endpoint if request list is empty in isr_tr_complete_low

Moiz Sonasath (1):
      usb: host: xhci: fix compilation error for non-PCI based stacks

Nicolas Ferre (1):
      USB: ohci-at91: fix PIO handling in relation with number of ports

Pavankumar Kondeti (1):
      EHCI: Update qTD next pointer in QH overlay region during unlink

Pratyush Anand (2):
      usb: dwc3: ep0: correct cache sync issue in case of ep0_bounced
      usb: dwc3: gadget: fix pending isoc handling

Ruchika Kharwar (1):
      usb: host: xhci-plat: use ioremap_nocache

Sebastian Andrzej Siewior (4):
      usb: gadget: dummy_hcd: fixup error probe path
      usb: gadget: dummy_hcd: add support for USB_DT_BOS on rh
      usb: gadget: at91udc: don't overwrite driver data
      usb: gadget: at91udc: Don't check for ep->ep.desc

Sergei Shtylyov (2):
      usb: musb: tusb6010: fix error path in tusb_probe()
      usb: musb: musbhsdma: fix IRQ check

yuzheng ma (1):
      usb: musb: host: fix for musb_start_urb Oops

Éric Piel (1):
      USB: ftdi-sio: add support for more Physik Instrumente devices

 drivers/usb/chipidea/udc.c        |   59 ++++++++++++++++++---------
 drivers/usb/class/cdc-wdm.c       |   12 ++++--
 drivers/usb/core/quirks.c         |    4 ++
 drivers/usb/dwc3/core.c           |    9 ++++-
 drivers/usb/dwc3/ep0.c            |    1 -
 drivers/usb/dwc3/gadget.c         |   19 ++++++++-
 drivers/usb/gadget/at91_udc.c     |    6 +--
 drivers/usb/gadget/dummy_hcd.c    |   41 +++++++++++++++++--
 drivers/usb/gadget/f_fs.c         |    4 ++
 drivers/usb/gadget/s3c-hsotg.c    |    3 ++
 drivers/usb/gadget/u_serial.c     |    4 ++
 drivers/usb/host/ehci-q.c         |   12 +++++-
 drivers/usb/host/ohci-at91.c      |   10 +++++
 drivers/usb/host/pci-quirks.c     |   42 +++++++++++++++----
 drivers/usb/host/pci-quirks.h     |    1 +
 drivers/usb/host/xhci-hub.c       |   42 +++++++++++++++++++
 drivers/usb/host/xhci-plat.c      |    2 +-
 drivers/usb/host/xhci.c           |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h           |    6 +++
 drivers/usb/musb/musb_host.c      |    2 +-
 drivers/usb/musb/musbhsdma.c      |    2 +-
 drivers/usb/musb/tusb6010.c       |    2 +-
 drivers/usb/renesas_usbhs/fifo.c  |    4 +-
 drivers/usb/serial/ftdi_sio.c     |   22 +++++++++-
 drivers/usb/serial/ftdi_sio_ids.h |   29 ++++++++++++-
 drivers/usb/serial/option.c       |    6 ++-
 26 files changed, 410 insertions(+), 57 deletions(-)
