Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1ERUlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:41:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1ERUlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:41:04 -0400
Date: Wed, 18 May 2011 20:40:58 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-509731336313b3799cf03071d72c64fa6383895e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-4-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-4-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, alternative, doc: Add comment for applying alternatives order
Git-Commit-ID: 509731336313b3799cf03071d72c64fa6383895e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:40:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  509731336313b3799cf03071d72c64fa6383895e
Gitweb:     http://git.kernel.org/tip/509731336313b3799cf03071d72c64fa6383895e
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:12 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:25 -0700

x86, alternative, doc: Add comment for applying alternatives order

Some string operation functions may be patched twice, e.g. on enhanced REP MOVSB
/STOSB processors, memcpy is patched first by fast string alternative function,
then it is patched by enhanced REP MOVSB/STOSB alternative function.

Add comment for applying alternatives order to warn people who may change the
applying alternatives order for any reason.

[ Documentation-only patch ]

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-4-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/alternative.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..f4fe15d 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -210,6 +210,15 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
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
