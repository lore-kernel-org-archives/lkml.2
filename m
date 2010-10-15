Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0JOJot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:44:49 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37652 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755447Ab0JOJor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:47 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 00/22] Introduce little endian bitops
Date: Fri, 15 Oct 2010 18:45:59 +0900
Message-Id: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces little endian bit operations in asm/bitops.h
for all architectures and converts ext2 non-atomic and minix bit operation
to them. it enables to remove ext2 non-atomic and minix bit operations
from asm/bitops.h. The reason they should be removed from asm/bitops.h
is as follows:

For ext2 non-atomic bit operations, they are used for little endian byte order
bitmap access by some filesystems and modules. But using ext2_*() functions on
a module other than ext2 filesystem makes someone feel strange.

For minix bit operations, they are only used by minix filesystem and useless
by other modules. Because byte order of inode and block bitmap is defferent
on each architectures.

Akinobu Mita (22):
  bitops: merge little and big endian definisions in
    asm-generic/bitops/le.h
  bitops: rename generic le bitops functions
  s390: introduce little endian bitops
  arm: introduce little endian bitops
  m68k: introduce le bitops
  m68knommu: introduce little endian bitops
  bitops: introduce little endian bitops for most architectures
  rds: stop including asm-generic/bitops/le.h
  kvm: stop including asm-generic/bitops/le.h
  asm-generic: use little endian bitops
  ext3: use little endian bitops
  ext4: use little endian bitops
  ocfs2: use little endian bitops
  nilfs2: use little endian bitops
  reiserfs: use little endian bitops
  udf: use little endian bitops
  ufs: use little endian bitops
  md: use little endian bit operations
  dm: use little endian bit operations
  bitops: remove ext2 non-atomic bitops from asm/bitops.h
  m68k: convert minix bitops to use little endian bitops
  bitops: remove minix bitops from asm/bitops.h

 arch/Kconfig                                 |    6 ++
 arch/alpha/Kconfig                           |    1 +
 arch/alpha/include/asm/bitops.h              |    4 +-
 arch/arm/Kconfig                             |    1 +
 arch/arm/include/asm/bitops.h                |   50 ++++++--------
 arch/avr32/Kconfig                           |    1 +
 arch/avr32/include/asm/bitops.h              |    3 +-
 arch/avr32/kernel/avr32_ksyms.c              |    4 +-
 arch/avr32/lib/findbit.S                     |    4 +-
 arch/blackfin/Kconfig                        |    1 +
 arch/blackfin/include/asm/bitops.h           |    3 +-
 arch/cris/Kconfig                            |    1 +
 arch/cris/include/asm/bitops.h               |    3 +-
 arch/frv/Kconfig                             |    1 +
 arch/frv/include/asm/bitops.h                |    4 +-
 arch/h8300/Kconfig                           |    1 +
 arch/h8300/include/asm/bitops.h              |    3 +-
 arch/ia64/Kconfig                            |    1 +
 arch/ia64/include/asm/bitops.h               |    3 +-
 arch/m32r/Kconfig                            |    1 +
 arch/m32r/include/asm/bitops.h               |    3 +-
 arch/m68k/Kconfig                            |    1 +
 arch/m68k/include/asm/bitops_mm.h            |   89 ++++++++++----------------
 arch/m68k/include/asm/bitops_no.h            |   28 +++++----
 arch/m68knommu/Kconfig                       |    1 +
 arch/microblaze/Kconfig                      |    1 +
 arch/mips/Kconfig                            |    1 +
 arch/mips/include/asm/bitops.h               |    3 +-
 arch/mn10300/Kconfig                         |    1 +
 arch/mn10300/include/asm/bitops.h            |    3 +-
 arch/parisc/Kconfig                          |    1 +
 arch/parisc/include/asm/bitops.h             |    4 +-
 arch/powerpc/Kconfig                         |    1 +
 arch/powerpc/include/asm/bitops.h            |   35 +---------
 arch/s390/Kconfig                            |    1 +
 arch/s390/include/asm/bitops.h               |   45 ++++++++------
 arch/score/Kconfig                           |    3 +
 arch/sh/Kconfig                              |    1 +
 arch/sh/include/asm/bitops.h                 |    3 +-
 arch/sparc/Kconfig                           |    1 +
 arch/sparc/include/asm/bitops_32.h           |    3 +-
 arch/sparc/include/asm/bitops_64.h           |    4 +-
 arch/tile/Kconfig                            |    1 +
 arch/tile/include/asm/bitops.h               |    3 +-
 arch/x86/Kconfig                             |    1 +
 arch/x86/include/asm/bitops.h                |    4 +-
 arch/xtensa/Kconfig                          |    1 +
 arch/xtensa/include/asm/bitops.h             |    3 +-
 drivers/md/bitmap.c                          |    6 +-
 drivers/md/dm-log.c                          |    8 +-
 fs/ext4/ext4.h                               |   18 ++++--
 fs/minix/minix.h                             |   37 +++++++++++
 fs/nilfs2/alloc.h                            |    3 +-
 fs/ocfs2/ocfs2.h                             |   13 ++--
 fs/udf/balloc.c                              |   11 ++-
 fs/ufs/util.h                                |    2 +-
 include/asm-generic/bitops.h                 |    3 +-
 include/asm-generic/bitops/ext2-atomic.h     |    4 +-
 include/asm-generic/bitops/ext2-non-atomic.h |   20 ------
 include/asm-generic/bitops/le.h              |   56 +++++++---------
 include/asm-generic/bitops/minix-le.h        |   17 -----
 include/asm-generic/bitops/minix.h           |   15 ----
 include/linux/ext2_fs.h                      |   12 ++++
 include/linux/ext3_fs.h                      |   15 +++--
 include/linux/reiserfs_fs.h                  |   34 ++++++----
 lib/find_next_bit.c                          |    9 +--
 net/rds/cong.c                               |    8 +--
 virt/kvm/kvm_main.c                          |    3 +-
 68 files changed, 304 insertions(+), 332 deletions(-)
 delete mode 100644 include/asm-generic/bitops/ext2-non-atomic.h
 delete mode 100644 include/asm-generic/bitops/minix-le.h
 delete mode 100644 include/asm-generic/bitops/minix.h

