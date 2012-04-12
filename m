Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909Ab2DLW0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:26:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57100 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab2DLW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:26:17 -0400
Date: Thu, 12 Apr 2012 15:26:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging patches for 3.4-rc2
Message-ID: <20120412222614.GB11612@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git tags/staging-3.4-rc2

for you to fetch changes up to 474a89885f77953b12bce9f23660c31ef5c2630e:

  staging: android: fix mem leaks in __persistent_ram_init() (2012-04-12 14:34:32 -0700)

----------------------------------------------------------------
Staging tree fixes for 3.4-rc2

Here are a number of bugfixes for the drivers/staging/ portion of the kernel
that have been reported recently.
Nothing major here, with maybe the exception of the ramster code can now be
built so it is enabled in the build again, and lots of memory leaks that people
like to have fixed on their systems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      staging: sep: Fix sign of error

Axel Lin (1):
      Staging: android: timed_gpio: Fix resource leak in timed_gpio_probe error paths

Chris Kelly (1):
      staging: ozwpan: Added new maintainer for ozwpan

Colin Cross (1):
      android: make persistent_ram based drivers depend on HAVE_MEMBLOCK

Dan Carpenter (2):
      Staging: vt6655-6: check keysize before memcpy()
      Staging: rts_pstor: off by one in for loop

Dan Magenheimer (1):
      staging: ramster: unbreak my heart

Dmitry Eremin-Solenikov (1):
      staging/xgifb: fix display on XGI Volari Z11m cards

Gerard Snitselaar (1):
      staging/vme: Fix module parameters

Jesper Juhl (3):
      staging/media/as102: Don't call release_firmware() on uninitialized variable
      staging: vt6656: Don't leak memory in drivers/staging/vt6656/ioctl.c::private_ioctl()
      staging: android: fix mem leaks in __persistent_ram_init()

Lothar Waﬂmann (1):
      staging:iio:core add missing increment of loop index in iio_map_array_unregister()

Marek Belisko (1):
      staging: iio: hmc5843: Fix crash in probe function.

Nitin Gupta (1):
      staging: zsmalloc: fix memory leak

Preetham Chandru (1):
      staging: iio: ak8975: Remove i2c client data corruption

Rob Clark (1):
      staging: drm/omap: move where DMM driver is registered

wwang (2):
      staging:rts_pstor:Fix possible panic by NULL pointer dereference
      staging:rts_pstor:Avoid "Bad target number" message when probing driver

 MAINTAINERS                                 |    1 +
 drivers/staging/android/Kconfig             |    3 ++-
 drivers/staging/android/persistent_ram.c    |   11 ++++++----
 drivers/staging/android/timed_gpio.c        |   27 +++++++++++++-----------
 drivers/staging/iio/inkern.c                |    1 +
 drivers/staging/iio/magnetometer/ak8975.c   |    8 ++++---
 drivers/staging/iio/magnetometer/hmc5843.c  |    4 +++-
 drivers/staging/media/as102/as102_fw.c      |    2 +-
 drivers/staging/omapdrm/omap_drv.c          |    7 ++++---
 drivers/staging/ozwpan/TODO                 |    4 +++-
 drivers/staging/ramster/Kconfig             |    6 +-----
 drivers/staging/rts_pstor/ms.c              |    3 ++-
 drivers/staging/rts_pstor/rtsx.c            |    5 +++++
 drivers/staging/rts_pstor/rtsx_transport.c  |   11 +++++-----
 drivers/staging/sep/sep_main.c              |    6 +++---
 drivers/staging/vme/devices/vme_pio2_core.c |    4 ++--
 drivers/staging/vt6655/key.c                |    3 +++
 drivers/staging/vt6656/ioctl.c              |    3 ++-
 drivers/staging/vt6656/key.c                |    3 +++
 drivers/staging/xgifb/vb_init.c             |    2 +-
 drivers/staging/xgifb/vb_setmode.c          |    7 +++++++
 drivers/staging/xgifb/vb_table.h            |   11 +++++++++-
 drivers/staging/zsmalloc/zsmalloc-main.c    |   30 ++++++++++++++++-----------
 23 files changed, 105 insertions(+), 57 deletions(-)
