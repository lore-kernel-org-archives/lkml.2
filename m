Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222Ab2C3RRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:17:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47551 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab2C3RQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:16:58 -0400
Date: Fri, 30 Mar 2012 10:16:44 -0700
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-c0e9afc0da6cb0f11497e5ea83377b3c451450e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, stable@vger.kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, stable@vger.kernel.org
In-Reply-To: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Use -mno-avx when available
Git-Commit-ID: c0e9afc0da6cb0f11497e5ea83377b3c451450e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Mar 2012 10:16:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0e9afc0da6cb0f11497e5ea83377b3c451450e0
Gitweb:     http://git.kernel.org/tip/c0e9afc0da6cb0f11497e5ea83377b3c451450e0
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 28 Mar 2012 11:51:17 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 30 Mar 2012 10:06:39 -0700

x86: Use -mno-avx when available

On gccs that support AVX it's a good idea to disable that too, similar to
how SSE2, SSE1 etc. are already disabled. This prevents the compiler
from generating AVX ever implicitely.

No failure observed, just from review.

[ hpa: Marking this for urgent and stable, simply because the patch
  will either have absolutely no effect *or* it will avoid potentially
  very hard to debug failures. ]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1332960678-11879-1-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 968dbe2..41a7237 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -129,6 +129,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
 KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
