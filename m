Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2IUUDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:03:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50888 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2IUUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:03:32 -0400
Date: Fri, 21 Sep 2012 13:03:21 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-a052858fabb376b695f2c125633daa6728e0f284@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-8-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-8-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, uaccess: Merge prototypes for clear_user/
 __clear_user
Git-Commit-ID: a052858fabb376b695f2c125633daa6728e0f284
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 13:03:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a052858fabb376b695f2c125633daa6728e0f284
Gitweb:     http://git.kernel.org/tip/a052858fabb376b695f2c125633daa6728e0f284
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:11 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:26 -0700

x86, uaccess: Merge prototypes for clear_user/__clear_user

The prototypes for clear_user() and __clear_user() are identical in
the 32- and 64-bit headers.  No functionality change.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-8-git-send-email-hpa@linux.intel.com
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
