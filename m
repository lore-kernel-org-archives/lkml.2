Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1A0Ly5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:54:57 -0500
Received: from [114.251.86.0] ([114.251.86.0]:25971 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754233Ab1A0LyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:54:05 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, David Daney <ddaney@caviumnetworks.com>,
        Wang Cong <xiyou.wangcong@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 1/7] MIPS: add unlikely() to BUG_ON()
Date: Thu, 27 Jan 2011 20:12:30 +0800
Message-Id: <1296130356-29896-2-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
References: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current BUG_ON() in arch/mips/include/asm/bug.h does not use unlikely(),
in order to get better branch predict result, source code should call
BUG_ON() with unlikely() explicitly. This is not a suggested method to
use BUG_ON().

This patch adds unlikely() inside BUG_ON implementation on MIPS code,
callers can use BUG_ON without explicit unlikely() now.

I have no usable MIPS hardware to build and test the fix, any test result
of this patch is welcome.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Wang Cong <xiyou.wangcong@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>
---
 arch/mips/include/asm/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/bug.h b/arch/mips/include/asm/bug.h
index 540c98a..6771c07 100644
--- a/arch/mips/include/asm/bug.h
+++ b/arch/mips/include/asm/bug.h
@@ -30,7 +30,7 @@ static inline void  __BUG_ON(unsigned long condition)
 			     : : "r" (condition), "i" (BRK_BUG));
 }
 
-#define BUG_ON(C) __BUG_ON((unsigned long)(C))
+#define BUG_ON(C) __BUG_ON((unsigned long)unlikely(C))
 
 #define HAVE_ARCH_BUG_ON
 
-- 
1.7.3.2

