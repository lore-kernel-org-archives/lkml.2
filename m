Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2BXURq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:17:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab2BXURo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:17:44 -0500
Date: Fri, 24 Feb 2012 12:16:51 -0800
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-b893485db994b17402524d3d700b950294cb6c97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, arnd@arndb.de, dhowells@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: arnd@arndb.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        joerg.roedel@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        mingo@elte.hu
In-Reply-To: <1330088295-28732-1-git-send-email-joerg.roedel@amd.com>
References: <1330088295-28732-1-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] bitops:
  Add missing parentheses to new get_order macro
Git-Commit-ID: b893485db994b17402524d3d700b950294cb6c97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 24 Feb 2012 12:17:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b893485db994b17402524d3d700b950294cb6c97
Gitweb:     http://git.kernel.org/tip/b893485db994b17402524d3d700b950294cb6c97
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Fri, 24 Feb 2012 13:58:15 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 24 Feb 2012 10:39:27 -0800

bitops: Add missing parentheses to new get_order macro

The new get_order macro introcuded in commit

	d66acc39c7cee323733c8503b9de1821a56dff7e

does not use parentheses around all uses of the parameter n.
This causes new compile warnings, for example in the
amd_iommu_init.c function:

drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]
drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]

Fix those warnings by adding the missing parentheses.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1330088295-28732-1-git-send-email-joerg.roedel@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/asm-generic/getorder.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index e0fb4bf..65e4468 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -49,8 +49,8 @@ int __get_order(unsigned long size)
 #define get_order(n)						\
 (								\
 	__builtin_constant_p(n) ? (				\
-		(n == 0UL) ? BITS_PER_LONG - PAGE_SHIFT :	\
-		((n < (1UL << PAGE_SHIFT)) ? 0 :		\
+		((n) == 0UL) ? BITS_PER_LONG - PAGE_SHIFT :	\
+		(((n) < (1UL << PAGE_SHIFT)) ? 0 :		\
 		 ilog2((n) - 1) - PAGE_SHIFT + 1)		\
 	) :							\
 	__get_order(n)						\
