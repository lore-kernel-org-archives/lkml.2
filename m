Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0JVLQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:16:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0JVLQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:16:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] automatic BKL conversion to mutexes
Date: Fri, 22 Oct 2010 13:15:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221315.46143.arnd@arndb.de>
X-Provags-ID: V02:K0:isaWzSC+5Bb0+HuVLLsOeJYmWQ5H4LaO9OED67pzK1S
 5wqN1E+4uZyYXHUDT1DZP4DCBW2aLIoleU1lWpaTZB8qDN/KOD
 zTNjKXPiQMQCTcGQtpb1kF1cOo+n6rtfKSKwkbM7FOsfUiAiin
 RAV7OV4YoHqGI84XmMzkezpBlqqdjI7w9Z32FpUhndI3xWEipt
 B++GIiJ75GtxnzdO7f97w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are all trivial conversions where we can replace the BKL
in one driver with a mutex, done with a script to avoid typos.

A number of the patches that were originally in this series have
been replaced by the maintainers with other patches to remove
the BKL without a replacement, where that is safe to do. The same
can still be done in the future for many of them, but the
replacement is the fast and safe option in order to remove most
of the trivial usage introduced over the years during BKL pushdown.

There is one known conflict in the pcmcia drivers that should
be trivial to resolve (one line added versus another line removed).

Please pull from:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git trivial

Arnd Bergmann (6):
      scsi: autoconvert trivial BKL users to private mutex
      mtd: autoconvert trivial BKL users to private mutex
      mac: autoconvert trivial BKL users to private mutex
      ipmi: autoconvert trivial BKL users to private mutex
      drivers: autoconvert trivial BKL users to private mutex
      block: autoconvert trivial BKL users to private mutex

 block/bsg.c                                |    3 --
 drivers/block/DAC960.c                     |   11 ++++---
 drivers/block/amiflop.c                    |   19 ++++++------
 drivers/block/aoe/aoeblk.c                 |    9 +++--
 drivers/block/aoe/aoechr.c                 |    9 +++--
 drivers/block/ataflop.c                    |   15 +++++----
 drivers/block/brd.c                        |    7 ++--
 drivers/block/cciss.c                      |   14 ++++----
 drivers/block/cpqarray.c                   |   15 +++++----
 drivers/block/drbd/drbd_main.c             |   11 ++++---
 drivers/block/floppy.c                     |   16 +++++-----
 drivers/block/loop.c                       |   11 ++++---
 drivers/block/nbd.c                        |    7 ++--
 drivers/block/paride/pcd.c                 |   15 +++++----
 drivers/block/paride/pd.c                  |   15 +++++----
 drivers/block/paride/pf.c                  |   17 ++++++-----
 drivers/block/paride/pg.c                  |    7 ++--
 drivers/block/paride/pt.c                  |   19 ++++++------
 drivers/block/pktcdvd.c                    |   16 +++++-----
 drivers/block/swim.c                       |   15 +++++----
 drivers/block/swim3.c                      |   15 +++++----
 drivers/block/ub.c                         |   15 +++++----
 drivers/block/viodasd.c                    |   11 ++++---
 drivers/block/xd.c                         |    7 ++--
 drivers/block/xen-blkfront.c               |   11 ++++---
 drivers/block/xsysace.c                    |   11 ++++---
 drivers/block/z2ram.c                      |   15 +++++----
 drivers/cdrom/gdrom.c                      |   15 +++++----
 drivers/cdrom/viocd.c                      |   15 +++++----
 drivers/char/apm-emulation.c               |   11 ++++---
 drivers/char/applicom.c                    |    9 +++--
 drivers/char/ds1302.c                      |   15 +++++----
 drivers/char/ds1620.c                      |    8 ++--
 drivers/char/dsp56k.c                      |   27 +++++++++--------
 drivers/char/dtlk.c                        |    8 ++--
 drivers/char/generic_nvram.c               |    7 ++--
 drivers/char/genrtc.c                      |   13 ++++----
 drivers/char/i8k.c                         |    7 ++--
 drivers/char/ip2/ip2main.c                 |    8 ++--
 drivers/char/ipmi/ipmi_devintf.c           |   14 ++++----
 drivers/char/ipmi/ipmi_watchdog.c          |    8 ++--
 drivers/char/lp.c                          |   15 +++++----
 drivers/char/mbcs.c                        |    8 ++--
 drivers/char/mmtimer.c                     |    7 ++--
 drivers/char/mwave/mwavedd.c               |   44 ++++++++++++++--------------
 drivers/char/nvram.c                       |   11 ++++---
 drivers/char/nwflash.c                     |   12 ++++----
 drivers/char/pcmcia/cm4000_cs.c            |   11 ++++---
 drivers/char/pcmcia/cm4040_cs.c            |    7 ++--
 drivers/char/ppdev.c                       |    8 ++--
 drivers/char/rio/rio_linux.c               |    7 ++--
 drivers/char/snsc.c                        |    9 +++--
 drivers/char/toshiba.c                     |    9 +++--
 drivers/char/viotape.c                     |   11 ++++---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    6 ++--
 drivers/hwmon/fschmd.c                     |    6 ++--
 drivers/hwmon/w83793.c                     |    6 ++--
 drivers/ide/ide-cd.c                       |   14 ++++----
 drivers/ide/ide-disk_ioctl.c               |    7 ++--
 drivers/ide/ide-floppy_ioctl.c             |    7 ++--
 drivers/ide/ide-gd.c                       |   10 +++---
 drivers/ide/ide-tape.c                     |   19 ++++++------
 drivers/input/misc/hp_sdc_rtc.c            |    7 ++--
 drivers/macintosh/adb.c                    |   10 +++---
 drivers/macintosh/smu.c                    |    6 ++--
 drivers/macintosh/via-pmu.c                |   11 ++++---
 drivers/md/dm.c                            |   10 +++---
 drivers/md/md.c                            |   13 ++++----
 drivers/memstick/core/mspro_block.c        |   11 ++++---
 drivers/message/fusion/mptctl.c            |   15 +++++----
 drivers/message/i2o/i2o_block.c            |   15 +++++----
 drivers/message/i2o/i2o_config.c           |   23 +++++++-------
 drivers/misc/phantom.c                     |   11 ++++---
 drivers/mmc/card/block.c                   |   10 +++---
 drivers/mtd/mtd_blkdevs.c                  |   14 ++++----
 drivers/mtd/mtdchar.c                      |   15 +++++----
 drivers/pci/hotplug/cpqphp_sysfs.c         |   13 ++++----
 drivers/rtc/rtc-m41t80.c                   |   13 ++++----
 drivers/s390/char/tape_block.c             |   13 ++++----
 drivers/sbus/char/jsflash.c                |   24 ++++++++-------
 drivers/scsi/3w-9xxx.c                     |    7 ++--
 drivers/scsi/3w-sas.c                      |    7 ++--
 drivers/scsi/3w-xxxx.c                     |    9 ++---
 drivers/scsi/aacraid/linit.c               |   15 +++++----
 drivers/scsi/ch.c                          |    8 ++--
 drivers/scsi/dpt_i2o.c                     |   18 ++++++------
 drivers/scsi/gdth.c                        |   11 ++++---
 drivers/scsi/megaraid.c                    |    8 ++--
 drivers/scsi/megaraid/megaraid_mm.c        |    8 ++--
 drivers/scsi/megaraid/megaraid_sas.c       |    2 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   11 ++++---
 drivers/scsi/osst.c                        |   15 +++++----
 drivers/scsi/scsi_tgt_if.c                 |    2 -
 drivers/scsi/sg.c                          |   12 ++++---
 drivers/scsi/sr.c                          |   14 ++++----
 drivers/scsi/st.c                          |   12 ++++----
 drivers/staging/hv/blkvsc_drv.c            |   11 ++++---
 drivers/staging/spectra/ffsport.c          |    7 ++--
 drivers/telephony/ixj.c                    |    7 ++--
 drivers/watchdog/cpwd.c                    |   15 +++++----
 100 files changed, 612 insertions(+), 556 deletions(-)
