Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab0KSCDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 21:03:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:63005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab0KSCDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 21:03:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,220,1288594800"; 
   d="scan'208";a="678964248"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v5 0/3] Lockless memory allocator and list
Date: Fri, 19 Nov 2010 10:02:11 +0800
Message-Id: <1290132134-21217-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a lockless memory allocator and a lock-less
list.

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

[PATCH -v5 1/3] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH -v5 2/3] lib, Make gen_pool memory allocator lockless
[PATCH -v5 3/3] lib, Add lock-less NULL terminated single list
