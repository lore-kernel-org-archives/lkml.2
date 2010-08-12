Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab0HLPmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:42:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62256 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149Ab0HLPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:42:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 12 Aug 2010 17:43:43 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 00/13] Various USB improvements
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <cover.1281625724.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko has found a bug in one of my patch sent earlier so
resending everything rebased on next.  This also include Uwe's and
mine patches for section mismatches with my previous approach
reverted.  

This patchset contains all my patches sent earlier.

* The first two patches should be included as quickly as possible. *

Sorry for spamming but I might have less time to work on those in the
next few weeks so I just wanted to send everything I have ready for
submission.

Michal Nazarewicz (11):
  USB: gadget: g_multi: fixed vendor and product ID
  USB: gadget: g_ffs: fixed vendor and product ID
  USB: gadget: composite: Better string override handling
  USB: gadget: mass_storage: moved strings handling code to composite
  USB: gadget: functionfs: code cleanup
  USB: gadget: g_multi: moved strings handling code to composite
  usb: gadget: storage: remove nofua file when unbinding
  usb: gadget: mass_storage: optional SCSI WRITE FUA bit
  Revert "USB: gadget: section mismatch warning fixed"
  usb gadget: don't save bind callback in struct usb_composite_driver
  init.h: add some more documentation to __ref* tags

Uwe Kleine-König (2):
  usb gadget: don't save bind callback in struct usb_gadget_driver
  usb gadget: don't save bind callback in struct usb_configuration

 drivers/usb/gadget/amd5536udc.c     |    9 ++-
 drivers/usb/gadget/at91_udc.c       |   11 ++--
 drivers/usb/gadget/atmel_usba_udc.c |    7 +-
 drivers/usb/gadget/audio.c          |   10 +--
 drivers/usb/gadget/cdc2.c           |   10 +--
 drivers/usb/gadget/ci13xxx_udc.c    |   18 +++--
 drivers/usb/gadget/composite.c      |  128 +++++++++++++++++++++++------------
 drivers/usb/gadget/dbgp.c           |    3 +-
 drivers/usb/gadget/dummy_hcd.c      |   10 ++--
 drivers/usb/gadget/ether.c          |   16 ++---
 drivers/usb/gadget/f_loopback.c     |    7 +-
 drivers/usb/gadget/f_mass_storage.c |   16 ++++-
 drivers/usb/gadget/f_sourcesink.c   |    5 +-
 drivers/usb/gadget/file_storage.c   |    6 +-
 drivers/usb/gadget/fsl_qe_udc.c     |   12 ++--
 drivers/usb/gadget/fsl_udc_core.c   |   10 ++--
 drivers/usb/gadget/g_ffs.c          |   91 ++++++++-----------------
 drivers/usb/gadget/gmidi.c          |    5 +-
 drivers/usb/gadget/goku_udc.c       |    9 ++-
 drivers/usb/gadget/hid.c            |   10 +--
 drivers/usb/gadget/imx_udc.c        |    9 ++-
 drivers/usb/gadget/inode.c          |    6 +-
 drivers/usb/gadget/langwell_udc.c   |    9 ++-
 drivers/usb/gadget/lh7a40x_udc.c    |   10 ++--
 drivers/usb/gadget/m66592-udc.c     |    9 ++-
 drivers/usb/gadget/mass_storage.c   |   82 +++--------------------
 drivers/usb/gadget/multi.c          |   36 +++-------
 drivers/usb/gadget/net2280.c        |   10 ++--
 drivers/usb/gadget/nokia.c          |    8 +-
 drivers/usb/gadget/omap_udc.c       |   10 ++--
 drivers/usb/gadget/printer.c        |    7 +-
 drivers/usb/gadget/pxa25x_udc.c     |    9 ++-
 drivers/usb/gadget/pxa27x_udc.c     |   12 ++--
 drivers/usb/gadget/r8a66597-udc.c   |    9 ++-
 drivers/usb/gadget/s3c-hsotg.c      |    9 ++-
 drivers/usb/gadget/s3c2410_udc.c    |   17 ++---
 drivers/usb/gadget/serial.c         |   11 ++--
 drivers/usb/gadget/webcam.c         |   11 ++--
 drivers/usb/gadget/zero.c           |    5 +-
 drivers/usb/musb/musb_gadget.c      |    9 ++-
 include/linux/init.h                |   13 +++-
 include/linux/usb/composite.h       |   40 ++++++-----
 include/linux/usb/gadget.h          |   20 ++---
 43 files changed, 350 insertions(+), 404 deletions(-)

