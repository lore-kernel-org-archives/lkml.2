Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab2IUToT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:44:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:26130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab2IUTnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225202005"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 07/11] x86, uaccess: Merge prototypes for clear_user/__clear_user
Date: Fri, 21 Sep 2012 12:43:11 -0700
Message-Id: <1348256595-29119-8-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

The prototypes for clear_user() and __clear_user() are identical in
the 32- and 64-bit headers.  No functionality change.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h    |    3 +++
 arch/x86/include/asm/uaccess_32.h |    3 ---
 arch/x86/include/asm/uaccess_64.h |    3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e1f3a17..2c7df3d 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -569,6 +569,9 @@ strncpy_from_user(char *dst, const char __user *src, long count);
 extern __must_check long strlen_user(const char __user *str);
 extern __must_check long strnlen_user(const char __user *str, long n);
 
+unsigned long __must_check clear_user(void __user *mem, unsigned long len);
+unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 576e39b..7f760a9 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -213,7 +213,4 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	return n;
 }
 
-unsigned long __must_check clear_user(void __user *mem, unsigned long len);
-unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
-
 #endif /* _ASM_X86_UACCESS_32_H */
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index d8def8b..142810c 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -217,9 +217,6 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 	}
 }
 
-__must_check unsigned long clear_user(void __user *mem, unsigned long len);
-__must_check unsigned long __clear_user(void __user *mem, unsigned long len);
-
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
-- 
1.7.6.5

