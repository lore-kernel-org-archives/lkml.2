Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2HQRPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:15:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35434 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2HQRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:15:43 -0400
Date: Fri, 17 Aug 2012 10:15:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging fixes for 3.6-rc3
Message-ID: <20120817171534.GA14238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.6-rc3

for you to fetch changes up to 3a491aeae86577e0f23cd094f3e16351b6061209:

  Merge tag 'v3.6-rc1-iio-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2012-08-16 14:17:08 -0700)

----------------------------------------------------------------

Staging fixes for 3.6-rc3

Here are some staging driver fixes (and iio driver fixes, they get lumped in
with the staging stuff due to dependancies) for your 3.6-rc3 tree.

Nothing major, just a bunch of fixes that people have reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexey Khoroshilov (1):
      iio/adjd_s311: Fix potential memory leak in adjd_s311_update_scan_mode()

Axel Lin (1):
      iio: lm3533-als: Fix build warnings

Greg Kroah-Hartman (2):
      staging: csr: add INET dependancy
      Merge tag 'v3.6-rc1-iio-fixes' of git://git.kernel.org/.../jic23/iio into staging-linus

H Hartley Sweeten (5):
      staging: comedi: remove pci_is_enabled() tests
      staging: comedi: daqboard2000: add back subsystem_device check
      staging: comedi: daqboard2000: ioremap'ed addresses are resource_size_t
      staging: comedi: dt3000: ioremap'ed addresses are resource_size_t
      staging: comedi: rtd520: ioremap'ed addresses are resource_size_t

Ian Abbott (1):
      staging: comedi: Fix reversed test in comedi_device_attach()

Lars-Peter Clausen (12):
      staging:iio:ad7793: Add missing break in switch statement
      staging:iio:ad7793: Mark channels as unsigned
      staging:iio:ad7793: Report channel offset
      staging:iio:ad7793: Fix temperature scale and offset
      staging:iio:ad7793: Follow new IIO naming spec
      staging:iio:ad7793: Fix internal reference value
      staging:iio:ad7192: Add missing break in switch statement
      staging:iio:ad7192: Fix setting ACX
      staging:iio:ad7192: Mark channels as unsigned
      staging:iio:ad7192: Report channel offset
      staging:iio:ad7192: Report offset and scale for temperature channel
      staging:iio:ad7780: Mark channels as unsigned

Michael Hennerich (2):
      iio: staging: ad7298_ring: Fix maybe-uninitialized warning
      iio: frequency: ADF4350: Fix potential reference div factor overflow.

Tim Gardner (3):
      staging: comedi: usbduxsigma: Declare MODULE_FIRMWARE usage
      staging: comedi: usbdux: Declare MODULE_FIRMWARE usage
      staging: comedi: usbduxfast: Declare MODULE_FIRMWARE usage

 drivers/iio/frequency/adf4350.c               | 24 ++++---
 drivers/iio/light/adjd_s311.c                 |  7 +-
 drivers/iio/light/lm3533-als.c                |  4 +-
 drivers/staging/comedi/drivers.c              |  2 +-
 drivers/staging/comedi/drivers/adv_pci1710.c  |  3 -
 drivers/staging/comedi/drivers/adv_pci1723.c  |  2 -
 drivers/staging/comedi/drivers/adv_pci_dio.c  |  2 -
 drivers/staging/comedi/drivers/daqboard2000.c | 17 ++---
 drivers/staging/comedi/drivers/dt3000.c       |  6 +-
 drivers/staging/comedi/drivers/rtd520.c       | 26 +++----
 drivers/staging/comedi/drivers/usbdux.c       |  4 +-
 drivers/staging/comedi/drivers/usbduxfast.c   |  4 +-
 drivers/staging/comedi/drivers/usbduxsigma.c  |  4 +-
 drivers/staging/csr/Kconfig                   |  2 +-
 drivers/staging/iio/adc/ad7192.c              | 48 +++++++------
 drivers/staging/iio/adc/ad7298_ring.c         |  2 +-
 drivers/staging/iio/adc/ad7780.c              | 10 +--
 drivers/staging/iio/adc/ad7793.c              | 99 ++++++++++++++++-----------
 include/linux/iio/frequency/adf4350.h         |  2 +
 19 files changed, 150 insertions(+), 118 deletions(-)
