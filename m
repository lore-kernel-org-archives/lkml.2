Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1ERB6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:58:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:10398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab1ERB5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,228,1304319600"; 
   d="scan'208";a="437959948"
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
Subject: [PATCH v3 0/4] Enable SMEP CPU Feature
Date: Tue, 17 May 2011 18:44:25 -0700
Message-Id: <1305683069-25394-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Intel new CPU supports SMEP (Supervisor Mode Execution Protection). SMEP
prevents kernel from executing code in application. Updated Intel SDM describes
this CPU feature. The document will be published soon.

Note: This patch set doesn't enable the SMEP feature in KVM. A seperate patch
will be pushed for enabling the feature in KVM.

Fenghua Yu (4):
  x86, cpu: Add CPU flags for SMEP
  x86, cpu: Add SMEP CPU feature in CR4
  x86, head_32/64.S: Enable SMEP
  x86/kernel/cpu/common.c: Disable SMEP by kernel option nosmep

 Documentation/kernel-parameters.txt    |    4 ++++
 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/include/asm/processor-flags.h |    1 +
 arch/x86/kernel/cpu/common.c           |   22 ++++++++++++++++++++++
 arch/x86/kernel/head_32.S              |   17 +++++++++++++----
 arch/x86/kernel/head_64.S              |   13 +++++++++++--
 6 files changed, 52 insertions(+), 6 deletions(-)

-- 
1.7.2

