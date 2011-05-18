Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1ERUlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:41:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:56220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab1ERUl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:41:29 -0400
Date: Wed, 18 May 2011 20:41:24 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-9072d11da15a71e086eab3b5085184f2c1d06913@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-5-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-5-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, alternative: Add altinstruction_entry macro
Git-Commit-ID: 9072d11da15a71e086eab3b5085184f2c1d06913
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:41:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9072d11da15a71e086eab3b5085184f2c1d06913
Gitweb:     http://git.kernel.org/tip/9072d11da15a71e086eab3b5085184f2c1d06913
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:13 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:25 -0700

x86, alternative: Add altinstruction_entry macro

Add altinstruction_entry macro to generate .altinstructions section
entries from assembly code.  This should be less failure-prone than
open-coding.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-5-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/alternative-asm.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index a63a68b..94d420b 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -15,4 +15,13 @@
 	.endm
 #endif
 
+.macro altinstruction_entry orig alt feature orig_len alt_len
+	.align 8
+	.quad \orig
+	.quad \alt
+	.word \feature
+	.byte \orig_len
+	.byte \alt_len
+.endm
+
 #endif  /*  __ASSEMBLY__  */
