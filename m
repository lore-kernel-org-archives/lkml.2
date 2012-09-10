Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2IJSMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:12:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:29484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab2IJSMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:12:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="191253080"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v2 0/5] eagerfpu patches for tip/x86/fpu
Date: Mon, 10 Sep 2012 11:11:00 -0700
Message-Id: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 version of the previous patchset https://lkml.org/lkml/2012/9/7/548
that decouples eagerfpu into a synthetic cpuid feature.

changes from v1:
* Made "eagerfpu=" boot parameter tri-state
* removed the cpu_has_xmm check in the fx_finit (not related to eagerfpu
  per-say, but this patchset touches that area of code).

Suresh Siddha (5):
  x86, fpu: decouple non-lazy/eager fpu restore from xsave
  x86, fpu: enable eagerfpu by default for xsaveopt
  x86, fpu: move check_fpu() after alternative_instructions()
  x86, fpu: make eagerfpu= boot param tri-state
  x86, fpu: remove cpu_has_xmm check in the fx_finit()

 Documentation/kernel-parameters.txt |    6 ++
 arch/x86/include/asm/cpufeature.h   |    3 +
 arch/x86/include/asm/fpu-internal.h |   53 ++++++++++++++------
 arch/x86/kernel/cpu/bugs.c          |    7 ++-
 arch/x86/kernel/cpu/common.c        |    2 -
 arch/x86/kernel/i387.c              |   25 +++------
 arch/x86/kernel/process.c           |    2 +-
 arch/x86/kernel/traps.c             |    2 +-
 arch/x86/kernel/xsave.c             |   95 ++++++++++++++++++++++++-----------
 9 files changed, 129 insertions(+), 66 deletions(-)

-- 
1.7.6.5

