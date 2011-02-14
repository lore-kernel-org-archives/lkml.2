Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1BNQzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:55:16 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59831 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1BNQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:55:14 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC PATCH 0/6] Rework tty helpers to avoid need for file pointers
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Feb 2011 16:25:51 +0000
Message-ID: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(and then use this to fix the holes in hci_ath)

The cleanup wants doing anyway but we have a reason for needing to do it.

---

Alan Cox (6):
      hci_ath: Fix the mess in this driver
      tty: add a helper for setting termios data from kernel side
      tty: now phase out the ioctl file pointer for good
      tty: remove filp from the USB tty ioctls
      tiocmset: kill the file pointer argument
      tiocmget: kill off the passing of the struct file


 drivers/bluetooth/hci_ath.c                 |   26 +++++++++++++-------------
 drivers/char/amiserial.c                    |    8 ++++----
 drivers/char/cyclades.c                     |    6 +++---
 drivers/char/epca.c                         |   16 ++++++++--------
 drivers/char/ip2/ip2main.c                  |   12 ++++++------
 drivers/char/isicom.c                       |    8 ++++----
 drivers/char/istallion.c                    |    8 ++++----
 drivers/char/moxa.c                         |   12 ++++++------
 drivers/char/mxser.c                        |    8 ++++----
 drivers/char/nozomi.c                       |    8 ++++----
 drivers/char/pcmcia/ipwireless/tty.c        |    8 ++++----
 drivers/char/pcmcia/synclink_cs.c           |   10 +++++-----
 drivers/char/riscom8.c                      |    8 ++++----
 drivers/char/rocket.c                       |    8 ++++----
 drivers/char/ser_a2232.c                    |    6 +++---
 drivers/char/serial167.c                    |    7 +++----
 drivers/char/specialix.c                    |    8 ++++----
 drivers/char/stallion.c                     |    9 ++++-----
 drivers/char/sx.c                           |    8 ++++----
 drivers/char/synclink.c                     |   13 ++++++-------
 drivers/char/synclink_gt.c                  |   19 +++++++++----------
 drivers/char/synclinkmp.c                   |   17 ++++++++---------
 drivers/char/ttyprintk.c                    |    2 +-
 drivers/char/vme_scc.c                      |    4 ++--
 drivers/isdn/capi/capi.c                    |   10 ++--------
 drivers/isdn/gigaset/interface.c            |   12 ++++++------
 drivers/isdn/gigaset/ser-gigaset.c          |    2 +-
 drivers/isdn/i4l/isdn_tty.c                 |    7 +++----
 drivers/mmc/card/sdio_uart.c                |    4 ++--
 drivers/net/irda/irtty-sir.c                |    2 +-
 drivers/net/usb/hso.c                       |   10 +++++-----
 drivers/net/wan/pc300_tty.c                 |    9 ++++-----
 drivers/staging/quatech_usb2/quatech_usb2.c |    6 +++---
 drivers/staging/serqt_usb2/serqt_usb2.c     |   13 ++++++-------
 drivers/tty/hvc/hvsi.c                      |    6 +++---
 drivers/tty/n_gsm.c                         |    6 +++---
 drivers/tty/pty.c                           |    4 ++--
 drivers/tty/serial/68328serial.c            |    2 +-
 drivers/tty/serial/68360serial.c            |    6 +++---
 drivers/tty/serial/crisv10.c                |    7 +++----
 drivers/tty/serial/ifx6x60.c                |    5 ++---
 drivers/tty/serial/serial_core.c            |   16 ++++++----------
 drivers/tty/tty_io.c                        |   17 ++++++++---------
 drivers/tty/tty_ioctl.c                     |   14 +++++++++-----
 drivers/tty/vt/vt_ioctl.c                   |    6 +++---
 drivers/usb/class/cdc-acm.c                 |    6 +++---
 drivers/usb/serial/ark3116.c                |    6 +++---
 drivers/usb/serial/belkin_sa.c              |    8 ++++----
 drivers/usb/serial/ch341.c                  |    7 +++----
 drivers/usb/serial/cp210x.c                 |   19 +++++++++----------
 drivers/usb/serial/cypress_m8.c             |   12 ++++++------
 drivers/usb/serial/digi_acceleport.c        |   14 +++++++-------
 drivers/usb/serial/ftdi_sio.c               |   12 ++++++------
 drivers/usb/serial/io_edgeport.c            |   12 ++++++------
 drivers/usb/serial/io_ti.c                  |    6 +++---
 drivers/usb/serial/iuu_phoenix.c            |    4 ++--
 drivers/usb/serial/keyspan.c                |    4 ++--
 drivers/usb/serial/keyspan.h                |    5 ++---
 drivers/usb/serial/keyspan_pda.c            |    4 ++--
 drivers/usb/serial/kl5kusb105.c             |    8 ++++----
 drivers/usb/serial/kobil_sct.c              |   12 ++++++------
 drivers/usb/serial/mct_u232.c               |   12 ++++++------
 drivers/usb/serial/mos7720.c                |    8 ++++----
 drivers/usb/serial/mos7840.c                |    6 +++---
 drivers/usb/serial/opticon.c                |    4 ++--
 drivers/usb/serial/oti6858.c                |   12 ++++++------
 drivers/usb/serial/pl2303.c                 |    6 +++---
 drivers/usb/serial/sierra.c                 |    4 ++--
 drivers/usb/serial/spcp8x5.c                |    6 +++---
 drivers/usb/serial/ssu100.c                 |    6 +++---
 drivers/usb/serial/ti_usb_3410_5052.c       |   14 +++++++-------
 drivers/usb/serial/usb-serial.c             |   12 ++++++------
 drivers/usb/serial/usb-wwan.h               |    6 +++---
 drivers/usb/serial/usb_wwan.c               |    6 +++---
 drivers/usb/serial/whiteheat.c              |   12 ++++++------
 include/linux/tty.h                         |    3 ++-
 include/linux/tty_driver.h                  |   13 ++++++-------
 include/linux/usb/serial.h                  |    6 +++---
 include/net/irda/ircomm_tty.h               |    6 +++---
 net/bluetooth/rfcomm/tty.c                  |    6 +++---
 net/irda/ircomm/ircomm_tty_ioctl.c          |   12 ++++++------
 81 files changed, 341 insertions(+), 361 deletions(-)

-- 
Signature
