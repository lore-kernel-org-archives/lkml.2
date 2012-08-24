Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2HXVPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:15:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:7595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab2HXVP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="190967372"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 0/6] x86, fpu: cleanups, introduce non-lazy FPU restore for xsave
Date: Fri, 24 Aug 2012 14:12:56 -0700
Message-Id: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are against tip/x86/fpu. Few cleanups and more improtantly
this series introduces the non-lazy FPU restore mechanism for processors
supporting xsave feature. More details in the individual patch changelogs.

Thanks.

Suresh Siddha (6):
  x86, fpu: drop_fpu() before restoring new state from sigframe
  x86, fpu: remove unnecessary user_fpu_end() in save_xstate_sig()
  x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
  x86, fpu: always use kernel_fpu_begin/end() for in-kernel FPU usage
  lguest, x86: handle guest TS bit for lazy/non-lazy fpu host models
  x86, fpu: use non-lazy fpu restore for processors supporting xsave

 arch/x86/include/asm/fpu-internal.h |  118 +++++++++++++++++++---------------
 arch/x86/include/asm/i387.h         |    1 +
 arch/x86/include/asm/xor_32.h       |   56 +++--------------
 arch/x86/include/asm/xor_64.h       |   61 +++---------------
 arch/x86/include/asm/xor_avx.h      |   54 ++++------------
 arch/x86/include/asm/xsave.h        |    1 +
 arch/x86/kernel/i387.c              |   20 +++++-
 arch/x86/kernel/process.c           |   12 +++-
 arch/x86/kernel/process_32.c        |    4 -
 arch/x86/kernel/process_64.c        |    4 -
 arch/x86/kernel/traps.c             |    5 +-
 arch/x86/kernel/xsave.c             |   58 +++++++++++++----
 arch/x86/kvm/x86.c                  |    3 +-
 drivers/lguest/x86/core.c           |   10 ++-
 14 files changed, 180 insertions(+), 227 deletions(-)

-- 
1.7.6.5

