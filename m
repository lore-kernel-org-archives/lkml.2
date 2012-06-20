Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2FTUyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:54:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38133 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2FTUyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:54:52 -0400
Date: Wed, 20 Jun 2012 13:54:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging patches for 3.5-rc4
Message-ID: <20120620205448.GA19274@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.5-rc4

for you to fetch changes up to 3026b0e942c65c65c8fc80d391d004228b52b916:

  staging: r8712u: Add new USB IDs (2012-06-15 14:50:04 -0700)

----------------------------------------------------------------
staging tree fixes for 3.5-rc4

Here are a number of small fixes for the drivers/staging tree, as well as iio
and pstore drivers (which came from the staging tree in the 3.5-rc1 merge).
All of these are tiny, but resolve issues that people have been reporting.

There's also a documentation update to reflect what the iio drivers really are
doing, which is good to get straightened out.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Andy Gross (1):
      staging: omapdrm: fix crash when freeing bad fb

Anton Vorontsov (5):
      pstore/ram: Should update old dmesg buffer before reading
      pstore/ram_core: Do not reset restored zone's position and size
      pstore/ram_core: Factor persistent_ram_zap() out of post_init()
      pstore/ram: Should zap persistent zone on unlink
      pstore/inode: Make pstore_fill_super() static

Bart Westgeest (1):
      staging: usbip: bugfix for stack corruption on 64-bit architectures

Ben Chan (1):
      staging: gdm72xx: Release netlink socket properly

Greg Kroah-Hartman (1):
      Revert "staging: usbip: bugfix for stack corruption on 64-bit architectures"

Jiri Kosina (1):
      iio: drop wrong reference from Kconfig

Johan Hovold (1):
      staging:iio: remove num_interrupt_lines from documentation

Lars-Peter Clausen (3):
      iio: Fix potential use after free
      staging:iio:ad7606: Re-add missing scale attribute
      staging:iio:ad7298: Fix linker error due to missing IIO kfifo buffer

Lubomir Schmidt (1):
      staging: r8712u: Add new USB IDs

Michael Hennerich (1):
      iio: documentation: Add out_altvoltage and friends

Randy Dunlap (1):
      staging/comedi: fix build for USB not enabled

 Documentation/ABI/testing/sysfs-bus-iio      |   31 ++++++++++++++++++++++++++
 drivers/iio/Kconfig                          |    3 +--
 drivers/iio/industrialio-core.c              |   16 +++++++------
 drivers/staging/comedi/drivers.c             |    5 +++++
 drivers/staging/gdm72xx/netlink_k.c          |    2 +-
 drivers/staging/iio/Documentation/device.txt |    2 --
 drivers/staging/iio/adc/Kconfig              |    1 +
 drivers/staging/iio/adc/ad7606_core.c        |    3 ++-
 drivers/staging/omapdrm/omap_fbdev.c         |   10 ++++++---
 drivers/staging/rtl8712/usb_intf.c           |    2 ++
 fs/pstore/inode.c                            |    2 +-
 fs/pstore/ram.c                              |    3 +++
 fs/pstore/ram_core.c                         |   27 +++++++++++++---------
 include/linux/pstore_ram.h                   |    2 ++
 14 files changed, 82 insertions(+), 27 deletions(-)
