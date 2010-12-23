Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0LWFoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 00:44:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:61580 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0LWFoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 00:44:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="639642739"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [RFC -v9 0/4] Lock-less list
Date: Thu, 23 Dec 2010 13:43:19 +0800
Message-Id: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a lock-less NULL-terminated linked list implementation.  And use
that in irq_work and replace net/rds/xlist.h.

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

[RFC -v9 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[RFC -v9 2/4] lib, Add lock-less NULL terminated single list
[RFC -v9 3/4] irq_work, Use llist in irq_work
[RFC -v9 4/4] net, rds, Replace xlist in net/rds/xlist.h with llist
