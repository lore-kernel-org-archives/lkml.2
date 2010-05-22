Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab0EVQ5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 12:57:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63682 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0EVQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 12:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=CySWw13d9RjgUfdpV2nCbPaf566oXsopc7L/zhDEBJARN08ib+ZTXJJcGVvrqIHBpE
         rODkbnM07vs1B4D5rtsYUJch/TiD/cSwJtk2LrM8Gzpxj4K46ayzq3IC/jCj+Jte34ez
         Cc9tbOTcu/hrjML32ow0wYDebg3t7adfLj2fA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Lassabe <frederic.lassabe@gmail.com>
Subject: [GIT PULL] Bkl ioctl pushdowns for 2.6.35-rc1
Date: Sat, 22 May 2010 18:57:05 +0200
Message-Id: <1274547426-25937-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the bkl/ioctl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/ioctl

There are still some pushdowns left, pending for tests or in discussion.
I guess ioctl will die for the next merge window.

Thanks,
	Frederic
---

Arnd Bergmann (9):
      hfsplus: Push down BKL into ioctl function
      sn_hwperf: Kill BKL usage
      um/mmapper: Remove BKL usage
      coda/psdev: Remove BKL from ioctl function
      smbfs: Push down BKL into ioctl function
      dvb: Push down BKL into ioctl functions
      scsi: Push down BKL into ioctl functions
      isdn: Push down BKL into ioctl functions
      drivers: Push down BKL into various drivers

Frederic Weisbecker (4):
      autofs4: Pushdown the bkl from ioctl
      sunrpc: Pushdown the bkl from ioctl
      sunrpc: Pushdown the bkl from sunrpc cache ioctl
      uml: Pushdown the bkl from harddog_kern ioctl

John Kacur (4):
      coda: BKL ioctl pushdown
      coda: Clean-up whitespace problems in pioctl.c
      ncpfs: BKL ioctl pushdown
      uml: Convert to unlocked_ioctls to remove implicit BKL


 arch/ia64/sn/kernel/sn2/sn_hwperf.c         |    9 +---
 arch/um/drivers/harddog_kern.c              |   18 +++++-
 arch/um/drivers/hostaudio_kern.c            |    8 ++--
 arch/um/drivers/mmapper_kern.c              |    5 +-
 drivers/char/apm-emulation.c                |    8 ++-
 drivers/char/applicom.c                     |   13 +++--
 drivers/char/ds1620.c                       |   16 +++++-
 drivers/char/dtlk.c                         |   15 +++---
 drivers/char/generic_nvram.c                |   17 +++++-
 drivers/char/genrtc.c                       |   16 +++++-
 drivers/char/hpet.c                         |   14 +++--
 drivers/char/ipmi/ipmi_devintf.c            |   26 +++++++--
 drivers/char/ipmi/ipmi_watchdog.c           |   17 +++++-
 drivers/char/nvram.c                        |   10 +++-
 drivers/char/nwflash.c                      |    7 ++-
 drivers/char/raw.c                          |   42 ++++++++------
 drivers/hwmon/fschmd.c                      |    9 ++--
 drivers/hwmon/w83793.c                      |   10 ++--
 drivers/input/misc/hp_sdc_rtc.c             |   34 ++++++++----
 drivers/isdn/capi/capi.c                    |   17 +++++-
 drivers/isdn/i4l/isdn_common.c              |   18 +++++-
 drivers/isdn/mISDN/timerdev.c               |   10 ++--
 drivers/macintosh/nvram.c                   |    2 +-
 drivers/macintosh/via-pmu.c                 |   17 +++++-
 drivers/media/dvb/dvb-core/dmxdev.c         |   31 ++++++++---
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   17 ++++--
 drivers/media/dvb/dvb-core/dvb_frontend.c   |   30 +++++-----
 drivers/media/dvb/dvb-core/dvb_net.c        |   15 ++++--
 drivers/media/dvb/dvb-core/dvbdev.c         |   17 ++++--
 drivers/media/dvb/dvb-core/dvbdev.h         |   11 ++---
 drivers/media/dvb/firewire/firedtv-ci.c     |    5 +-
 drivers/media/dvb/ttpci/av7110.c            |    4 +-
 drivers/media/dvb/ttpci/av7110_av.c         |    8 ++--
 drivers/media/dvb/ttpci/av7110_ca.c         |    5 +-
 drivers/mtd/mtdchar.c                       |   19 +++++--
 drivers/pcmcia/pcmcia_ioctl.c               |   17 +++++-
 drivers/rtc/rtc-m41t80.c                    |   16 +++++-
 drivers/sbus/char/openprom.c                |   44 +++++++++-------
 drivers/scsi/3w-9xxx.c                      |   10 +++-
 drivers/scsi/3w-sas.c                       |    8 ++-
 drivers/scsi/3w-xxxx.c                      |   11 +++-
 drivers/scsi/aacraid/linit.c                |   11 +++-
 drivers/scsi/dpt_i2o.c                      |   20 ++++++-
 drivers/scsi/gdth.c                         |   20 +++++--
 drivers/scsi/megaraid.c                     |   20 ++++++-
 drivers/scsi/megaraid.h                     |    3 +-
 drivers/scsi/megaraid/megaraid_mm.c         |   22 ++++++--
 drivers/scsi/osst.c                         |   14 ++++--
 drivers/scsi/sg.c                           |   17 +++++-
 drivers/usb/mon/mon_bin.c                   |   23 ++++++--
 drivers/usb/mon/mon_stat.c                  |    3 +-
 fs/autofs4/root.c                           |   22 ++++++--
 fs/coda/pioctl.c                            |   76 ++++++++++++++------------
 fs/coda/psdev.c                             |    5 +-
 fs/hfsplus/dir.c                            |    2 +-
 fs/hfsplus/hfsplus_fs.h                     |    3 +-
 fs/hfsplus/inode.c                          |    2 +-
 fs/hfsplus/ioctl.c                          |   12 +++-
 fs/ncpfs/dir.c                              |    2 +-
 fs/ncpfs/file.c                             |    2 +-
 fs/ncpfs/ioctl.c                            |   27 ++++++----
 fs/smbfs/dir.c                              |    2 +-
 fs/smbfs/file.c                             |    2 +-
 fs/smbfs/ioctl.c                            |   10 ++--
 fs/smbfs/proto.h                            |    2 +-
 include/linux/ncp_fs.h                      |    2 +-
 net/sunrpc/cache.c                          |   13 ++++-
 net/sunrpc/rpc_pipe.c                       |   18 +++++-
 68 files changed, 669 insertions(+), 312 deletions(-)
