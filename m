Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1AaQ31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:29:27 -0500
Received: from kroah.org ([198.145.64.141]:46352 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab1AaQ3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:29:14 -0500
Date: Mon, 31 Jan 2011 08:29:09 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for .38
Message-ID: <20110131162909.GB22875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of bug fixes for the staging tree for .38

Nothing major here, removal of an empty Modules.symvers file that has
been bugging a lot of people, as well as lots of fixes and some new
device ids added to some drivers.  There's also a well-known broadcom
suspend/resume driver fix in here that has been hitting a lot of people.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

All of these patches have been in the -next trees for a while.

These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------

 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |    4 +-
 drivers/staging/brcm80211/sys/wl_mac80211.c        |   45 +++---
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |    1 -
 drivers/staging/comedi/drivers/ni_labpc.c          |    3 +-
 drivers/staging/hv/blkvsc_drv.c                    |    1 +
 drivers/staging/hv/netvsc.c                        |    2 +-
 drivers/staging/hv/netvsc_drv.c                    |    1 -
 drivers/staging/iio/adc/ad7476_core.c              |    2 +-
 drivers/staging/iio/adc/ad7887_core.c              |    2 +-
 drivers/staging/iio/adc/ad799x_core.c              |    2 +-
 drivers/staging/iio/dac/ad5446.c                   |    2 +-
 drivers/staging/rt2860/rt_main_dev.c               |    2 -
 drivers/staging/rt2860/usb_main_dev.c              |    1 +
 drivers/staging/rtl8712/hal_init.c                 |   11 +-
 drivers/staging/rtl8712/usb_intf.c                 |  145 +++++++++++++++-----
 drivers/staging/speakup/kobjects.c                 |    2 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |   19 ++--
 drivers/staging/tidspbridge/core/io_sm.c           |    8 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   15 +-
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |   21 +--
 drivers/staging/usbip/stub.h                       |    1 +
 drivers/staging/usbip/stub_dev.c                   |   18 ++-
 drivers/staging/usbip/stub_rx.c                    |    4 +-
 drivers/staging/usbip/vhci.h                       |    6 +-
 drivers/staging/usbip/vhci_hcd.c                   |   54 ++++++-
 drivers/staging/usbip/vhci_rx.c                    |   50 ++++++-
 drivers/staging/xgifb/vb_setmode.c                 |    6 +-
 27 files changed, 294 insertions(+), 134 deletions(-)

---------------

Arend van Spriel (2):
      staging: brcm80211: remove assert to avoid panic since 2.6.37 kernel
      staging: brcm80211: fix suspend/resume issue in brcmsmac

Axel Köllhofer (1):
      staging: r8712u: Add new device IDs

Dan Carpenter (2):
      Staging: ste_rmi4: use after input_unregister_device()
      Staging: xgfib: put parenthesis in the right place

Denis Kirjanov (1):
      staging: rt2860: Fix incorrect netif_stop_queue usage warning

Greg Kroah-Hartman (1):
      Staging: remove unintended Module.symvers file

Guzman Lugo, Fernando (1):
      staging: tidspbridge: configure full L1 MMU range

Hank Janssen (1):
      staging: hv: Removed unneeded call to netif_stop_queue() in hv_netvsc

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Larry Finger (2):
      staging: rt2870sta: Add ID for Linksys WUSB100v2
      staging: r8712u: Fix memory leak in firmware loading

Max Vozeler (7):
      staging: usbip: stub: update refcounts for devices and interfaces
      staging: usbip: vhci: update reference count for usb_device
      staging: usbip: vhci: give back URBs from in-flight unlink requests
      staging: usbip: vhci: refuse to enqueue for dead connections
      staging: usbip: vhci: friendly log messages for connection errors
      staging: usbip: vhci: handle EAGAIN from SO_RCVTIMEO
      staging: usbip: vhci: use urb->dev->portnum to find port

Omar Ramirez Luna (1):
      staging: tidspbridge: replace mbox callback with notifier_call

Phillip Simbwa (1):
      Staging: ath6kl: fix potential buffer overflow

Roland Stigge (2):
      iio: Fixpoint formatted output bugfix
      Staging: iio: Aditional fixpoint formatted output bugfix

Timo Teräs (1):
      staging: hv: fix netvsc sleeping while atomic

roel kluin (1):
      Staging: speakup: &&/|| confusion in silent_store()

