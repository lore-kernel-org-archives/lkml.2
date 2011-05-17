Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1EQWmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:42:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:7744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab1EQWmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050251"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 0/9] Optimize string operations by enhanced REP MOVSB/STOSB
Date: Tue, 17 May 2011 15:29:09 -0700
Message-Id: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Intel processors are adding enhancements to REP MOVSB/STOSB and the use of
REP MOVSB/STOSB for optimal memcpy/memset or similar functions is recommended.
Enhancement availability is indicated by CPUID.7.0.EBX[9] (Enhanced REP MOVSB/STOSB).

Intel 64 and IA-32 SDM and performance optimization guide may include more model
specific information and how the feature can be used. The documents will be
published soon.

Fenghua Yu (9):
  x86, cpu: Enable enhanced REP MOVSB/STOSB feature
  x86/kernel/cpu/intel.c: Initialize Enhanced REP MOVSB/STOSBenhanced
  x86/kernel/alternative.c: Add comment for applying alternatives order
  x86, alternative-asm.h: Add altinstruction_entry macro
  x86/lib/clear_page_64.S: Support clear_page() with enhanced REP
    MOVSB/STOSB
  x86/lib/copy_user_64.S: Support copy_to_user/copy_from_user by
    enhanced REP MOVSB/STOSB
  x86/lib/memcpy_64.S: Optimize memcpy by enhanced REP MOVSB/STOSB
  x86/lib/memmove_64.S: Optimize memmove by enhanced REP MOVSB/STOSB
  x86/lib/memset_64.S: Optimize memset by enhanced REP MOVSB/STOSB

 arch/x86/include/asm/alternative-asm.h |    9 ++++
 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/kernel/alternative.c          |    9 ++++
 arch/x86/kernel/cpu/intel.c            |   19 +++++++--
 arch/x86/lib/clear_page_64.S           |   33 ++++++++++++----
 arch/x86/lib/copy_user_64.S            |   65 +++++++++++++++++++++++++++-----
 arch/x86/lib/memcpy_64.S               |   45 ++++++++++++++++------
 arch/x86/lib/memmove_64.S              |   29 ++++++++++++++-
 arch/x86/lib/memset_64.S               |   54 ++++++++++++++++++++------
 9 files changed, 215 insertions(+), 49 deletions(-)

-- 
1.7.2

