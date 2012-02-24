Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2BXM6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:58:50 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:32780
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625Ab2BXM6t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:58:49 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzc89bhzz1202hzz8275bhz2dh668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZWEPS-02-7W5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] bitops: Add missing parentheses to new get_order macro
Date: Fri, 24 Feb 2012 13:58:15 +0100
Message-ID: <1330088295-28732-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new get_order macro introcuded in commit

	d66acc39c7cee323733c8503b9de1821a56dff7e

does not use parentheses around all uses of the parameter n.
This causes new compile warnings, for example in the
amd_iommu_init.c function:

drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]
drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]

Fix those warnings by adding the missing parentheses.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
-- 
1.7.5.4


