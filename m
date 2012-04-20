Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2DTRU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:20:58 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2DTRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:20:56 -0400
Date: Fri, 20 Apr 2012 10:20:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.4-rc4
Message-ID: <20120420172052.GA21573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.4-rc4

for you to fetch changes up to 2d5733fcd33dd451022d197cb6b476e970519ca7:

  USB: serial: cp210x: Fixed usb_control_msg timeout values (2012-04-20 08:44:24 -0700)

----------------------------------------------------------------
USB fixes for 3.4-rc4

Here are a number of tiny USB fixes for 3.4-rc4.

Most of them are in the USB gadget area, but a few other minor USB driver and
core fixes are here as well.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ajay Kumar Gupta (1):
      usb: musb: fix bug in musb_cleanup_urb

Alan Stern (3):
      USB: fix deadlock in bConfigurationValue attribute method
      EHCI: fix criterion for resuming the root hub
      EHCI: always clear the STS_FLR status bit

Anatolij Gustschin (1):
      USB: ehci-fsl: Fix kernel crash on mpc5121e

Andrzej Pietrasiewicz (3):
      usb: gadget: FunctionFS: clear FFS_FL_BOUND flag on unbind (bugfix)
      usb: gadget: FunctionFS: make module init & exit __init & __exit
      usb: gadget: eliminate NULL pointer dereference (bugfix)

Anton Tikhomirov (5):
      usb: s3c-hsotg: Fix TX FIFOs allocation
      usb: s3c-hsotg: Fix maximum patcket size setting for EP0
      usb: s3c-hsotg: Avoid TxFIFO corruption in DMA mode
      usb: s3c-hsotg: Fix big buffers transfer in DMA mode
      usb: dwc3: Free event buffers array

Bhupesh Sharma (1):
      usb: gadget: uvc: Remove non-required locking from 'uvc_queue_next_buffer' routine

Bjørn Mork (1):
      USB: sierra: avoid QMI/wwan interface on MC77xx

Felipe Balbi (2):
      usb: gadget: udc-core: stop UDC on device-initiated disconnect
      usb: dwc3: ep0: increment "actual" on bounced ep0 case

Gerard Cauvy (1):
      usb: dwc3: ep0: add a default case for SetFeature command

Grazvydas Ignotas (2):
      usb: musb: fix some runtime_pm issues
      usb: musb: wake the device before ulpi transfers

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.4-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus

Julia Lawall (1):
      drivers/usb/misc/usbtest.c: add kfrees

Kishon Vijay Abraham I (2):
      usb: musb: omap: fix crash when musb glue (omap) gets initialized
      usb: gadget: udc-core: fix asymmetric calls in remove_driver

Lukasz Majewski (1):
      usb: gadget: rndis: fix Missing req->context assignment

Moiz Sonasath (1):
      usb: dwc3: ep0: Handle requests greater than wMaxPacketSize

Oliver Neukum (2):
      uwb: fix use of del_timer_sync() in interrupt
      uwb: fix error handling

Peter Chen (1):
      usb: fsl_udc_core: prime status stage once data stage has primed

Shubhrajyoti D (1):
      usb: musb: omap: fix the error check for pm_runtime_get_sync

Stephen Warren (1):
      USB: ehci-tegra: don't call set_irq_flags(IRQF_VALID)

Tomoki Sekiyama (2):
      USB: yurex: Remove allocation of coherent buffer for setup-packet buffer
      USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag in urb

Vladimir Zapolskiy (1):
      usb: musb: fix oops on omap2430 module unload

Xi Wang (2):
      usb: usbtest: avoid integer overflow in test_ctrl_queue()
      usb: usbtest: avoid integer overflow in alloc_sglist()

Yuri Matylitski (1):
      USB: serial: cp210x: Fixed usb_control_msg timeout values

 drivers/usb/core/hub.c            |    3 ---
 drivers/usb/core/message.c        |    6 +++---
 drivers/usb/dwc3/core.c           |    6 +++---
 drivers/usb/dwc3/ep0.c            |   12 +++++++++--
 drivers/usb/gadget/f_fs.c         |    3 ++-
 drivers/usb/gadget/f_rndis.c      |    1 +
 drivers/usb/gadget/fsl_udc_core.c |   25 ++++++++++++++---------
 drivers/usb/gadget/g_ffs.c        |    4 ++--
 drivers/usb/gadget/s3c-hsotg.c    |   17 +++++++++-------
 drivers/usb/gadget/udc-core.c     |    6 +++++-
 drivers/usb/gadget/uvc_queue.c    |    4 +---
 drivers/usb/host/ehci-fsl.c       |    7 ++++++-
 drivers/usb/host/ehci-hcd.c       |    9 +++++++--
 drivers/usb/host/ehci-tegra.c     |    1 -
 drivers/usb/misc/usbtest.c        |    9 ++++++---
 drivers/usb/misc/yurex.c          |   10 +++-------
 drivers/usb/musb/musb_core.c      |   40 ++++++++++++++++++++++++++++++-------
 drivers/usb/musb/musb_host.c      |    2 +-
 drivers/usb/musb/omap2430.c       |   31 ++++++++++++++++------------
 drivers/usb/serial/cp210x.c       |    9 ++++++---
 drivers/usb/serial/sierra.c       |    6 ++++--
 drivers/uwb/hwa-rc.c              |    3 ++-
 drivers/uwb/neh.c                 |   12 ++++++++++-
 include/linux/usb/otg.h           |    1 +
 24 files changed, 151 insertions(+), 76 deletions(-)
