Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2G0QBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab2G0QBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:01:15 -0400
From: Cong Wang <amwang@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>
Subject: [GIT PULL] kmap_atomic final cleanups for 3.6
Date: Sat, 28 Jul 2012 00:00:58 +0800
Message-Id: <1343404858-31316-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Please pull my kmap_atomic cleanup's for 3.6,

	git://github.com/congwang/linux.git kmap_atomic

this should be the final round of cleanup, as the definitions
of enum km_type finally get removed from the whole tree.
The patches stay in linux-next for a long time.

Thanks!



Cong Wang (14):
  jbd2: remove the second argument of kmap_atomic
  frv: remove the second parameter of kmap_atomic_primary()
  tile: remove usage of enum km_type
  highmem: remove the deprecated form of kmap_atomic
  arm: remove km_type definitions
  powerpc: remove km_type definitions
  frv: remove km_type definitions
  avr32: remove km_type definitions
  asm-generic: remove km_type definitions
  um: remove km_type definitions
  tile: remove km_type definitions
  feature-removal-schedule.txt: remove kmap_atomic(page, km_type)
  vmalloc: remove KM_USER0 from comments
  pipe: remove KM_USER0 from comments

 Documentation/feature-removal-schedule.txt |    8 -----
 arch/arm/include/asm/kmap_types.h          |   26 +-----------------
 arch/avr32/include/asm/kmap_types.h        |   24 +---------------
 arch/frv/include/asm/highmem.h             |   34 ++++++-----------------
 arch/frv/include/asm/kmap_types.h          |   24 +---------------
 arch/frv/mb93090-mb00/pci-dma.c            |    4 +-
 arch/frv/mm/cache-page.c                   |    8 +++---
 arch/frv/mm/highmem.c                      |   20 +++++++-------
 arch/powerpc/include/asm/kmap_types.h      |   31 +--------------------
 arch/tile/include/asm/kmap_types.h         |   31 +--------------------
 arch/tile/mm/highmem.c                     |    2 +-
 arch/um/include/asm/kmap_types.h           |   18 +-----------
 fs/jbd2/commit.c                           |    4 +-
 fs/pipe.c                                  |    2 +-
 include/asm-generic/kmap_types.h           |   34 +---------------------
 include/linux/highmem.h                    |   41 +---------------------------
 include/linux/pipe_fs_i.h                  |    8 ++---
 mm/vmalloc.c                               |    8 +----
 18 files changed, 44 insertions(+), 283 deletions(-)

-- 
1.7.7.6

