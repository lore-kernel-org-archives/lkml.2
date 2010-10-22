Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0JVLQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:16:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58139 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab0JVLQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:16:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] BKL as a config option
Date: Fri, 22 Oct 2010 13:15:43 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221315.43118.arnd@arndb.de>
X-Provags-ID: V02:K0:eOpNiTtwp6A4fMrQhJU9ByOPg3q2YCGyQ/qojRgkJFL
 aXczfV8Syy+e2teIX0bu8Lc1ZkWJ88tls4ysmpgRf3TMnEL7xH
 lMAkWRzrPV8oSOTCn7LXraF5tH5jyAxN+QnOipfLykPA/uGP3N
 3z3nZLQGZKv/fz2xKWDR6uqdGoaSvyZESPC27cxUh7tkgzC7aa
 +FCi4KD/wHwQtazIflB7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a collection of BKL removal stuff that did not fit anywhere
else. Most patches are conversions that are simple but could not
be done with an automated script for some reason.

The final patch introduces CONFIG_BKL as we discussed a few weeks
back. It only marks drivers as depends on BKL that don't have
a patch in linux-next yet, so it misses the modules that get
converted in other trees.

CONFIG_FILE_LOCKING still selects CONFIG_BKL because a kernel
without file locking is rather useless and that would make it
easy for user to break. I will follow up with a patch to change
that once the dependencies for that are merged, hopefully
before -rc1.

Please pull from:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git config



---
Al Viro (1):
      fix rawctl compat ioctls breakage on amd64 and itanic

Arnd Bergmann (15):
      hpet: kill BKL, add compat_ioctl
      s390/block: kill the big kernel lock
      isapnp: BKL removal
      alpha: kill big kernel lock
      cris: autoconvert trivial BKL users
      parisc: remove big kernel lock
      uml: kill big kernel lock
      tlclk: remove big kernel lock
      dvb/bt8xx: kill the big kernel lock
      dvb-core: kill the big kernel lock
      rtmutex-tester: make it build without BKL
      blktrace: remove the big kernel lock
      sunrpc: remove the big kernel lock
      dabusb: remove the BKL
      BKL: introduce CONFIG_BKL.

Namhyung Kim (1):
      init/main.c: remove BKL notations

 arch/alpha/kernel/osf_sys.c                 |    5 -
 arch/alpha/kernel/traps.c                   |    3 -
 arch/cris/arch-v10/drivers/ds1302.c         |    7 +-
 arch/cris/arch-v10/drivers/pcf8563.c        |    6 +-
 arch/cris/arch-v10/drivers/sync_serial.c    |   11 +-
 arch/cris/arch-v32/drivers/cryptocop.c      |    4 +-
 arch/cris/arch-v32/drivers/mach-a3/gpio.c   |   11 +-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c   |   11 +-
 arch/cris/arch-v32/drivers/pcf8563.c        |    6 +-
 arch/cris/arch-v32/drivers/sync_serial.c    |   11 +-
 arch/parisc/kernel/perf.c                   |    4 -
 arch/um/drivers/harddog_kern.c              |   13 +-
 arch/um/drivers/hostaudio_kern.c            |   12 +-
 arch/um/drivers/ubd_kern.c                  |   11 +-
 arch/um/kernel/exec.c                       |    2 -
 drivers/char/hpet.c                         |   98 +++++++----
 drivers/char/raw.c                          |  243 +++++++++++++++-----------
 drivers/char/tlclk.c                        |    6 +-
 drivers/gpu/drm/Kconfig                     |    5 +-
 drivers/media/Kconfig                       |    1 +
 drivers/media/dvb/bt8xx/dst_ca.c            |    7 +-
 drivers/media/dvb/dvb-core/dmxdev.c         |   17 +--
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    8 +-
 drivers/media/dvb/dvb-core/dvb_net.c        |    9 +-
 drivers/media/dvb/dvb-core/dvbdev.c         |   17 +-
 drivers/media/video/dabusb.c                |   18 +--
 drivers/net/appletalk/Kconfig               |    1 +
 drivers/pnp/isapnp/proc.c                   |   15 +-
 drivers/s390/block/dasd.c                   |    6 -
 drivers/s390/block/dasd_ioctl.c             |   17 +--
 drivers/s390/block/dcssblk.c                |    5 -
 drivers/staging/cx25821/Kconfig             |    1 +
 drivers/staging/easycap/Kconfig             |    1 +
 drivers/staging/go7007/Kconfig              |    1 +
 drivers/staging/usbip/Kconfig               |    2 +-
 fs/Kconfig                                  |    1 +
 fs/adfs/Kconfig                             |    1 +
 fs/autofs/Kconfig                           |    1 +
 fs/compat_ioctl.c                           |   70 --------
 fs/hpfs/Kconfig                             |    1 +
 fs/nfs/Kconfig                              |    1 +
 fs/nfsd/Kconfig                             |    1 +
 fs/smbfs/Kconfig                            |    1 +
 fs/udf/Kconfig                              |    1 +
 fs/ufs/Kconfig                              |    1 +
 include/linux/smp_lock.h                    |    7 +-
 init/Kconfig                                |    2 +-
 init/main.c                                 |    2 -
 kernel/rtmutex-tester.c                     |    6 +
 kernel/trace/blktrace.c                     |   14 +--
 lib/Kconfig.debug                           |    9 +
 net/ipx/Kconfig                             |    1 +
 net/sunrpc/cache.c                          |   15 +--
 net/sunrpc/rpc_pipe.c                       |   26 +--
 net/x25/Kconfig                             |    1 +
 55 files changed, 347 insertions(+), 410 deletions(-)
