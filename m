Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2FWKEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab2FWKEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:04:41 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>
Subject: [PATCH 00/12] kmap_atomic cleanup for 3.6
Date: Sat, 23 Jun 2012 18:04:11 +0800
Message-Id: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After few releases, it seems there are no more callers
using the deprecated form of kmap_atomic(), the one
with two parameters. So we can remove it now and remove
the KM_* definition except KM_TYPE_NR together.

All the patches are available at:

	git://github.com/congwang/linux.git #kmap_atomic

Signed-off-by: Cong Wang <amwang@redhat.com>

-------------------

Cong Wang (12):
  jbd2: remove the second argument of kmap_atomic
  arm: remove km_type definitions
  powerpc: remove km_type definitions
  frv: remove km_type definitions
  avr32: remove km_type definitions
  asm-generic: remove km_type definitions
  um: remove km_type definitions
  tile: remove km_type definitions
  highmem: remove the deprecated form of kmap_atomic
  feature-removal-schedule.txt: remove kmap_atomic(page, km_type)
  vmalloc: remove KM_USER0 from comments
  pipe: remove KM_USER0 from comments

 Documentation/feature-removal-schedule.txt |    8 -----
 arch/arm/include/asm/kmap_types.h          |   26 +-----------------
 arch/avr32/include/asm/kmap_types.h        |   24 +---------------
 arch/frv/include/asm/kmap_types.h          |   24 +---------------
 arch/powerpc/include/asm/kmap_types.h      |   31 +--------------------
 arch/tile/include/asm/kmap_types.h         |   26 -----------------
 arch/um/include/asm/kmap_types.h           |   18 +-----------
 fs/jbd2/commit.c                           |    4 +-
 fs/pipe.c                                  |    2 +-
 include/asm-generic/kmap_types.h           |   34 +---------------------
 include/linux/highmem.h                    |   41 +---------------------------
 include/linux/pipe_fs_i.h                  |    8 ++---
 mm/vmalloc.c                               |    8 +----
 13 files changed, 17 insertions(+), 237 deletions(-)

-- 
1.7.7.6

