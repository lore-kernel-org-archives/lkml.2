Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab2JZRSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:18:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:59964 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757804Ab2JZRSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:18:01 -0400
Date: Fri, 26 Oct 2012 10:16:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.7-rc3
Message-ID: <20121026171615.GA11384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.7-rc2

for you to fetch changes up to 4d3f120ae7473b96f114b187856e89e08571fc83:

  staging: tidspbridge: delete unused mmu functions (2012-10-24 16:31:32 -0700)

----------------------------------------------------------------
Staging driver fixes for 3.7-rc3

Here are some staging driver fixes for your 3.7-rc tree.

Nothing major here, a number of iio driver fixups that were causing problems,
some comedi driver bugfixes, and a bunch of tidspbridge warning squashing and
other regressions fixed from the 3.6 release.

All have been in the linux-next releases for a bit.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Andreas Larsson (1):
      iio: Remove duplicates for light/ in Kconfig and Makefile

Arve Hjønnevåg (2):
      Staging: android: binder: Fix memory leak on thread/process exit
      Staging: android: binder: Allow using highmem for binder buffers

Fred Brooks (1):
      staging: comedi: ni_daq_700: fix dio subdevice regression

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.7a' of git://git.kernel.org/.../jic23/iio into staging-linus

Ian Abbott (7):
      staging: comedi: 8255_pci: fix possible NULL deref during detach
      staging: comedi: amplc_dio200: fix possible NULL deref during detach
      staging: comedi: amplc_pc236: fix invalid register access during detach
      staging: comedi: amplc_pc236: fix possible NULL deref during detach
      staging: comedi: amplc_pc263: fix possible NULL deref during detach
      staging: comedi: das08: fix possible NULL deref during detach
      staging: comedi: ni_labpc: fix possible NULL deref during detach

Lars-Peter Clausen (11):
      iio: Add some helper macros for unit conversion
      staging:iio: Fix adis16201 channel offsets and scales
      staging:iio: Fix adis16203 channel offsets and scales
      staging:iio: Fix adis16204 channel offsets and scales
      staging:iio: Fix adis16209 channel offsets and scales
      staging:iio: Fix adis16220 channel offsets and scales
      staging:iio: Fix adis16240 channel offsets and scales
      staging:iio: Fix adis16260 channel offsets and scales
      staging:iio: Fix adis16400 channel offsets and scales
      staging:iio:adis16400: Report correct temperature scale and offset
      staging:iio:adis16400: Fixup adis16336 temp channel attributes

Nitin Gupta (1):
      staging: zram: Fix handling of incompressible pages

Omar Ramirez Luna (6):
      staging: tidspbridge: request the right irq for mmu
      staging: tidspbridge: drop const from custom mmu implementation
      staging: tidspbridge: change type to __iomem for per and core addresses
      staging: tidspbridge: ioremap dsp sync addr
      staging: tidspbridge: ioremap physical address of the stack segment in shm
      staging: tidspbridge: delete unused mmu functions

Randy Dunlap (1):
      staging: ramster: depends on NET

Sergei Trofimovich (1):
      staging: ipack: add missing include (implicit declaration of function 'kfree')

Vincent Penquerc'h (1):
      staging: omapdrm: fix allocation size for page addresses array

 drivers/iio/Kconfig                                     |   1 -
 drivers/iio/Makefile                                    |   1 -
 drivers/staging/android/binder.c                        |  30 +++++++++++++++++--
 drivers/staging/comedi/drivers/8255_pci.c               |   2 ++
 drivers/staging/comedi/drivers/amplc_dio200.c           |   2 ++
 drivers/staging/comedi/drivers/amplc_pc236.c            |   5 ++--
 drivers/staging/comedi/drivers/amplc_pc263.c            |   2 ++
 drivers/staging/comedi/drivers/das08.c                  |   2 ++
 drivers/staging/comedi/drivers/ni_daq_700.c             |   2 +-
 drivers/staging/comedi/drivers/ni_labpc.c               |   2 ++
 drivers/staging/iio/accel/adis16201_core.c              |  24 +++++++++-------
 drivers/staging/iio/accel/adis16203_core.c              |  20 +++++++------
 drivers/staging/iio/accel/adis16204_core.c              |  22 +++++++-------
 drivers/staging/iio/accel/adis16209_core.c              |  18 ++++++------
 drivers/staging/iio/accel/adis16220_core.c              |  19 ++++++------
 drivers/staging/iio/accel/adis16240_core.c              |  23 ++++++++-------
 drivers/staging/iio/gyro/adis16260_core.c               |  29 +++++++++++--------
 drivers/staging/iio/imu/adis16400.h                     |   2 ++
 drivers/staging/iio/imu/adis16400_core.c                |  70 +++++++++++++++++++++++++++-----------------
 drivers/staging/ipack/bridges/tpci200.c                 |   1 +
 drivers/staging/omapdrm/omap_gem.c                      |   4 +--
 drivers/staging/ramster/Kconfig                         |   1 +
 drivers/staging/tidspbridge/core/tiomap3430.c           |  37 +++++++++++++++++-------
 drivers/staging/tidspbridge/hw/hw_mmu.c                 | 115 +++++++++++++------------------------------------------------------------
 drivers/staging/tidspbridge/hw/hw_mmu.h                 |  31 +++++++++-----------
 drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h |   4 +--
 drivers/staging/tidspbridge/include/dspbridge/host_os.h |   4 +--
 drivers/staging/tidspbridge/rmgr/drv.c                  |   8 +++---
 drivers/staging/tidspbridge/rmgr/node.c                 |  21 ++++++++++----
 drivers/staging/zram/zram_drv.c                         |  12 ++++++--
 include/linux/iio/iio.h                                 |  16 +++++++++++
 31 files changed, 287 insertions(+), 243 deletions(-)
