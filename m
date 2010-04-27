Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0D0JSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:18:32 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab0D0JSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=hGOIP6u+chrG9qL5TDzeM7hyqpQsDmEhWMpyovJ5+6bCVfM9zg0a7/A7zXWRaRXgq8
         5ZWyRB+EE0mitttzk59YxE96TFbUoOi9mZEfvW1gVs7xeSiHVJc2fxCTCyELD6VB0cNy
         J9ivZeGByzgJ2y6X3n5mEUTYUHq+fmsVdLXkY=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/10] bkl: pushdowns from Arnd, and compile fixes
Date: Tue, 27 Apr 2010 11:18:08 +0200
Message-Id: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are bkl pushdowns from Arnd that conflicted with
Linus's "Preparation for BKL'ed ioctl removal patch". I fixed-up the merge
conflicts. In addition - during allyesconfig compile testing on x86_64 I found
a number of issues that I fixed-up

I pushed these to my own new linus-bkl tree.
git://www.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git linux-bkl

Frederic, if you want to grab those, pls do so. also, we might want to combine
my compile fixes with Arnd's push-down patches, for better git bisectability.

Presented separately here for everyone's easy perusal.

Arnd Bergmann (6):
  dvb: push down BKL into ioctl functions
  scsi: push down BKL into ioctl functions
  isdn: push down BKL into ioctl functions
  staging: push down BKL into ioctl functions
  v4l: always use unlocked_ioctl
  drivers: push down BKL into various drivers

John Kacur (4):
  bkl: Fix up compile problems in megaraid from bkl push-down
  bkl: Fix missing inode tw_chrdev_ioctl due to bkl pushdown
  bkl: Fix missing inode in twl_chrdev_ioctl resulting from bkl
    pushdown
  bkl: Fix-up compile problems as a result of the bkl-pushdown.

 drivers/block/pktcdvd.c                     |   13 ++++++--
 drivers/char/apm-emulation.c                |    8 +++--
 drivers/char/applicom.c                     |   13 +++++---
 drivers/char/ds1620.c                       |   16 ++++++++-
 drivers/char/dtlk.c                         |   15 +++++----
 drivers/char/generic_nvram.c                |   17 ++++++++--
 drivers/char/genrtc.c                       |   16 ++++++++-
 drivers/char/hpet.c                         |   14 +++++---
 drivers/char/i8k.c                          |   21 ++++++++++--
 drivers/char/ipmi/ipmi_devintf.c            |   26 +++++++++++++---
 drivers/char/ipmi/ipmi_watchdog.c           |   17 +++++++++-
 drivers/char/nvram.c                        |   10 ++++--
 drivers/char/nwflash.c                      |    7 +++-
 drivers/char/raw.c                          |   42 ++++++++++++++-----------
 drivers/hwmon/fschmd.c                      |    9 +++--
 drivers/hwmon/w83793.c                      |   10 ++++--
 drivers/input/misc/hp_sdc_rtc.c             |   34 ++++++++++++++------
 drivers/isdn/capi/capi.c                    |   17 ++++++++--
 drivers/isdn/divert/divert_procfs.c         |   19 ++++++++++--
 drivers/isdn/i4l/isdn_common.c              |   18 +++++++++--
 drivers/isdn/mISDN/timerdev.c               |   10 ++++--
 drivers/macintosh/nvram.c                   |    2 +-
 drivers/macintosh/via-pmu.c                 |   17 ++++++++--
 drivers/media/dvb/dvb-core/dmxdev.c         |   31 +++++++++++++-----
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   17 +++++++---
 drivers/media/dvb/dvb-core/dvb_frontend.c   |   30 +++++++++---------
 drivers/media/dvb/dvb-core/dvb_net.c        |   15 +++++++--
 drivers/media/dvb/dvb-core/dvbdev.c         |   17 +++++++----
 drivers/media/dvb/dvb-core/dvbdev.h         |   11 ++----
 drivers/media/dvb/firewire/firedtv-ci.c     |    5 +--
 drivers/media/dvb/ttpci/av7110.c            |    4 +-
 drivers/media/dvb/ttpci/av7110_av.c         |    8 ++--
 drivers/media/dvb/ttpci/av7110_ca.c         |    5 +--
 drivers/media/video/v4l2-dev.c              |   19 +++++++++--
 drivers/mtd/mtdchar.c                       |   19 ++++++++---
 drivers/pcmcia/pcmcia_ioctl.c               |   17 ++++++++--
 drivers/rtc/rtc-m41t80.c                    |   16 ++++++++-
 drivers/sbus/char/openprom.c                |   44 +++++++++++++++-----------
 drivers/scsi/3w-9xxx.c                      |   10 ++++--
 drivers/scsi/3w-sas.c                       |    8 ++++-
 drivers/scsi/3w-xxxx.c                      |   11 +++++--
 drivers/scsi/aacraid/linit.c                |   11 +++++--
 drivers/scsi/dpt_i2o.c                      |   20 ++++++++++--
 drivers/scsi/gdth.c                         |   20 +++++++++---
 drivers/scsi/megaraid.c                     |   20 ++++++++++--
 drivers/scsi/megaraid.h                     |    4 +-
 drivers/scsi/megaraid/megaraid_mm.c         |   22 ++++++++++---
 drivers/scsi/osst.c                         |   14 ++++++--
 drivers/scsi/sg.c                           |   17 ++++++++--
 drivers/staging/crystalhd/crystalhd_lnx.c   |   13 +++++--
 drivers/staging/dt3155/dt3155_drv.c         |   24 +++++++++++----
 drivers/staging/poch/poch.c                 |   17 +++++++++-
 drivers/staging/vme/devices/vme_user.c      |   18 +++++++++--
 drivers/usb/mon/mon_bin.c                   |   23 ++++++++++----
 drivers/usb/mon/mon_stat.c                  |    3 +-
 55 files changed, 636 insertions(+), 248 deletions(-)

