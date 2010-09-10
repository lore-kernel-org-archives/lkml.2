Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0IJBrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:47:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:54039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0IJBr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:47:29 -0400
Date: Fri, 10 Sep 2010 01:46:10 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-2-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-2-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Use correct type for %cr4
Message-ID: <tip-2df7a6e9e8e67c19e5fe2eac3f2d2223b7bb4a7b@git.kernel.org>
Git-Commit-ID: 2df7a6e9e8e67c19e5fe2eac3f2d2223b7bb4a7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:46:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2df7a6e9e8e67c19e5fe2eac3f2d2223b7bb4a7b
Gitweb:     http://git.kernel.org/tip/2df7a6e9e8e67c19e5fe2eac3f2d2223b7bb4a7b
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:08 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:16:13 -0700

x86: Use correct type for %cr4

%cr4 is 64-bit in 64-bit mode (although the upper 32-bits are currently reserved).
Use unsigned long for the temporary variable to get the right size.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-2-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 325b7bd..396b80f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -602,7 +602,7 @@ extern unsigned long		mmu_cr4_features;
 
 static inline void set_in_cr4(unsigned long mask)
 {
-	unsigned cr4;
+	unsigned long cr4;
 
 	mmu_cr4_features |= mask;
 	cr4 = read_cr4();
@@ -612,7 +612,7 @@ static inline void set_in_cr4(unsigned long mask)
 
 static inline void clear_in_cr4(unsigned long mask)
 {
-	unsigned cr4;
+	unsigned long cr4;
 
 	mmu_cr4_features &= ~mask;
 	cr4 = read_cr4();
