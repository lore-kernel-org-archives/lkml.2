Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025Ab1J0TAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:00:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60283 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1J0TAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:00:06 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix typo in 32-bit cmpxchg_double_local implementation
Date: Thu, 27 Oct 2011 14:00:02 -0500
Message-Id: <1319742002-19470-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32-bit has no cmpxchg16b_local; only 8b. This looks like it was copied
from the 64-bit code without adjustment and should resemble
cmpxchg_double as defined in this same file.

Introduced in commit 3824abd1279ef7.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 arch/x86/include/asm/cmpxchg_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 3deb725..14b74b5 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -323,7 +323,7 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 ({									\
        BUILD_BUG_ON(sizeof(*(ptr)) != 4);				\
        VM_BUG_ON((unsigned long)(ptr) % 8);				\
-       cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));			\
+       cmpxchg8b_local((ptr), (o1), (o2), (n1), (n2));			\
 })
 
 #define system_has_cmpxchg_double() cpu_has_cx8
-- 
1.7.7

