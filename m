Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0GCWDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:03:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0GCWCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:02:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Bob Picco <bob.picco@hp.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jaroslav Kysela <perex@perex.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Takashi Iwai <tiwai@suse.de>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/8] BKL removal, assorted patches
Date: Sun,  4 Jul 2010 00:02:24 +0200
Message-Id: <1278194552-24943-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:XhzQb+d9O8dxKMxirpfnNIrpPzCq2IziEMNyUMtxVMk
 XJRcQCqQZI5iKxBUEjSx7kDS8MNjgdUY5QMI1OY/uIv/LZGysO
 BJgat/bEacYJ10LgXDpll11kse8oQ4VHizvLkhBaCH0I/jwlBV
 sHW47ofmd6n7QyUQjbvcP4jNo6xsJ5Q//DGBFPnR+GdnkmClur
 6SIBZnMANbitO28j4lawA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are necessary for the removal of the
big kernel lock but don't fit in any other series.

The most important one is the addition of the
CONFIG_BKL Kconfig symbol, which can be used
to mark device drivers that are still using the
BKL so we can build a kernel that does not provide
or need it.

I'd like to add this series to linux-next and
submit it for linux-2.6.36 inclusion, but
would even more welcome the individual maintainers
to pick up the respective patches and put them
in their next trees.

	Arnd

Cc: Bob Picco <bob.picco@hp.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Tejun Heo <tj@kernel.org>


Arnd Bergmann (7):
  do_coredump: do not take BKL
  init: remove the BKL from startup code
  hpet: kill BKL, add compat_ioctl
  proc/pci: kill BKL
  dasd: no need for BKL in ioctl
  isapnp: BKL removal
  BKL: introduce CONFIG_BKL.

John Kacur (1):
  soundcore_open: Reduce the area BKL coverage

 drivers/char/Kconfig            |    2 +-
 drivers/char/hpet.c             |   98 +++++++++++++++++++++++++-------------
 drivers/gpu/drm/Kconfig         |    5 +-
 drivers/hid/usbhid/Kconfig      |    2 +-
 drivers/isdn/Kconfig            |    1 +
 drivers/isdn/capi/Kconfig       |    2 +-
 drivers/isdn/mISDN/Kconfig      |    1 +
 drivers/media/Kconfig           |    3 +-
 drivers/misc/Kconfig            |    2 +-
 drivers/net/appletalk/Kconfig   |    1 +
 drivers/pci/proc.c              |    4 +-
 drivers/pnp/isapnp/proc.c       |   13 +++--
 drivers/s390/block/dasd_ioctl.c |   17 +------
 drivers/sbus/char/Kconfig       |    2 +-
 drivers/staging/sep/Kconfig     |    2 +-
 drivers/staging/usbip/Kconfig   |    2 +-
 drivers/usb/gadget/Kconfig      |    2 +-
 fs/Kconfig                      |    1 +
 fs/adfs/Kconfig                 |    1 +
 fs/afs/Kconfig                  |    1 +
 fs/autofs/Kconfig               |    1 +
 fs/autofs4/Kconfig              |    1 +
 fs/coda/Kconfig                 |    1 +
 fs/ecryptfs/Kconfig             |    1 +
 fs/exec.c                       |    6 --
 fs/fat/Kconfig                  |    2 +
 fs/freevxfs/Kconfig             |    1 +
 fs/hpfs/Kconfig                 |    1 +
 fs/isofs/Kconfig                |    1 +
 fs/jffs2/Kconfig                |    1 +
 fs/ncpfs/Kconfig                |    1 +
 fs/nfs/Kconfig                  |    2 +-
 fs/nfsd/Kconfig                 |    1 +
 fs/ocfs2/Kconfig                |    1 +
 fs/qnx4/Kconfig                 |    1 +
 fs/reiserfs/Kconfig             |    1 +
 fs/smbfs/Kconfig                |    1 +
 fs/squashfs/Kconfig             |    2 +-
 fs/udf/Kconfig                  |    1 +
 fs/ufs/Kconfig                  |    2 +-
 include/linux/smp_lock.h        |    7 ++-
 init/Kconfig                    |    2 +-
 init/main.c                     |    5 --
 kernel/trace/trace.c            |    8 ---
 lib/Kconfig.debug               |   14 +++++-
 net/ipx/Kconfig                 |    1 +
 net/irda/Kconfig                |    2 +-
 net/irda/irnet/Kconfig          |    2 +-
 net/x25/Kconfig                 |    2 +-
 sound/oss/Kconfig               |    2 +-
 sound/sound_core.c              |   13 +++--
 51 files changed, 145 insertions(+), 104 deletions(-)

