Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1EQWmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:42:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:7744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab1EQWmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050260"
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
Subject: [PATCH 3/9] x86/kernel/alternative.c: Add comment for applying alternatives order
Date: Tue, 17 May 2011 15:29:12 -0700
Message-Id: <1305671358-14478-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Some string operation functions may be patched twice, e.g. on enhanced REP MOVSB
/STOSB processors, memcpy is patched first by fast string alternative function,
then it is patched by enhanced REP MOVSB/STOSB alternative function.

Add comment for applying alternatives order to warn people who may change the
applying alternatives order for any reason.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/alternative.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c0501ea..a81f2d5 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -266,6 +266,15 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
+	/*
+	 * The scan order should be from start to end. A later scanned
+	 * alternative code can overwrite a previous scanned alternative code.
+	 * Some kernel functions (e.g. memcpy, memset, etc) use this order to
+	 * patch code.
+	 *
+	 * So be careful if you want to change the scan order to any other
+	 * order.
+	 */
 	for (a = start; a < end; a++) {
 		u8 *instr = a->instr;
 		BUG_ON(a->replacementlen > a->instrlen);
-- 
1.7.2

