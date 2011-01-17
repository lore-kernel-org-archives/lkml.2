Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1AQGRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:17:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:27035 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1AQGRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:17:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,332,1291622400"; 
   d="scan'208";a="697502777"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
Subject: [PATCH -v10 0/4] Lock-less list
Date: Mon, 17 Jan 2011 14:16:55 +0800
Message-Id: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v10:

- Rebased on latest Linus' tree.
- Revise ARCH_HAVE_NMI_SAFE_CMPXCHG definition for SPARC32 per arch
  maintainer's comments.

v9:

- Split out lock-less allocator, will repost allocator with its user
  in another patchset.
- Use lock-less list in irq_work and replace net/rds/xlist.h

v8:

- Rebased on mmotm 2010-12-02

v7:

- Revise ARCH_HAVE_NMI_SAFE_CMPXCHG definition for some architectures
  according to architecture maitainers' comments.
- Remove spin_trylock_irqsave based fallback for lockless memory allocator,
  because it does not work for !CONFIG_SMP and is not likely to be used.
- Make lockless memory allocator and list does not depend on
  ARCH_HAVE_NMI_SAFE_CMPXCHG.  Instead, require the user to depend on it
  when needed. And BUG_ON(in_nmi()) is added in necessary place to prevent
  silent race.

v6:

- Revise ARCH_HAVE_NMI_SAFE_CMPXCHG definition for some architectures
  according to architecture maitainers' comments.

v5:

- Add ARCH_HAVE_NMI_SAFE_CMPXCHG
- Add spin_trylock_irqsave based fallback in lockless memory allocator
  if ARCH_HAVE_NMI_SAFE_CMPXCHG=n
- Make lockless list depends on ARCH_HAVE_NMI_SAFE_CMPXCHG

v4:

- Split from APEI patchset
- Update patch description and comments according to ML comments

v3:

- Rework lockless memory allocator and list according to ML comments


[PATCH -v10 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH -v10 2/4] lib, Add lock-less NULL terminated single list
[PATCH -v10 3/4] irq_work, Use llist in irq_work
[PATCH -v10 4/4] net, rds, Replace xlist in net/rds/xlist.h with llist
