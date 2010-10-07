Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0JGXw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:52:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:58197 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0JGXwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:52:25 -0400
Date: Thu, 7 Oct 2010 23:52:02 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, namhyung@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@gmail.com, hpa@linux.intel.com
In-Reply-To: <1285770588-14065-1-git-send-email-namhyung@gmail.com>
References: <1285770588-14065-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-32: Fix sparse warning for the __PHYSICAL_MASK calculation
Message-ID: <tip-a416e9e1dde0fbcf20cda59df284cc0dcf2aadc4@git.kernel.org>
Git-Commit-ID: a416e9e1dde0fbcf20cda59df284cc0dcf2aadc4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Oct 2010 23:52:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a416e9e1dde0fbcf20cda59df284cc0dcf2aadc4
Gitweb:     http://git.kernel.org/tip/a416e9e1dde0fbcf20cda59df284cc0dcf2aadc4
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 29 Sep 2010 23:29:48 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 7 Oct 2010 16:36:17 -0700

x86-32: Fix sparse warning for the __PHYSICAL_MASK calculation

On 32-bit non-PAE system, cast to 'phys_addr_t' truncates value
before subtraction. Subtracting before cast produce same result
but remove following warnings from sparse:

 arch/x86/include/asm/pgtable_types.h:255:38: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable_types.h:270:38: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable.h:127:32: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable.h:132:32: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable.h:344:31: warning: cast truncates bits from constant value (100000000 becomes 0)

64-bit or PAE machines will not be affected by this change.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
LKML-Reference: <1285770588-14065-1-git-send-email-namhyung@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index a667f24..1df6621 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -8,7 +8,7 @@
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)
+#define __PHYSICAL_MASK		((phys_addr_t)((1ULL << __PHYSICAL_MASK_SHIFT) - 1))
 #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
 /* Cast PAGE_MASK to a signed type so that it is sign-extended if
