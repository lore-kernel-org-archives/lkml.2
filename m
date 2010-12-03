Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0LCCrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:47:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:40652 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab0LCCrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:47:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,291,1288594800"; 
   d="scan'208";a="632630250"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v7 0/3] Lockless memory allocator and list
Date: Fri,  3 Dec 2010 10:46:55 +0800
Message-Id: <1291344418-25206-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a lockless memory allocator and a lock-less
list.

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

[PATCH -v7 1/3] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH -v7 2/3] lib, Make gen_pool memory allocator lockless
[PATCH -v7 3/3] lib, Add lock-less NULL terminated single list
