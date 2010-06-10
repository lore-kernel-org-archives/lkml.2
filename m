Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0FJLKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:10:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39156 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FJLKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:41 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: x86@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/23] x86: Avoid unused by set variables in rdmsr
Message-Id: <20100610111038.E6B53B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoids quite a lot of warnings with a gcc 4.6 -Wall build
because this happens in a commonly used header file (apic.h)

Cc: x86@kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/msr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35-rc2-gcc/arch/x86/include/asm/msr.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/include/asm/msr.h
+++ linux-2.6.35-rc2-gcc/arch/x86/include/asm/msr.h
@@ -148,8 +148,8 @@ static inline unsigned long long native_
 #define rdmsr(msr, val1, val2)					\
 do {								\
 	u64 __val = native_read_msr((msr));			\
-	(val1) = (u32)__val;					\
-	(val2) = (u32)(__val >> 32);				\
+	(void)((val1) = (u32)__val);				\
+	(void)((val2) = (u32)(__val >> 32));			\
 } while (0)
 
 static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
