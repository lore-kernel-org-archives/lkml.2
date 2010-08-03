Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0HCOKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:10:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:48692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab0HCOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:10:17 -0400
Date: Tue, 3 Aug 2010 14:09:42 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <tip-69309a05907546fb686b251d4ab041c26afe1e1d@git.kernel.org>
References: <tip-69309a05907546fb686b251d4ab041c26afe1e1d@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] um, x86: Cast to (u64 *) inside set_64bit()
Message-ID: <tip-bf676945cb5bfe455321f57968967c18976f4995@git.kernel.org>
Git-Commit-ID: bf676945cb5bfe455321f57968967c18976f4995
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 14:09:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf676945cb5bfe455321f57968967c18976f4995
Gitweb:     http://git.kernel.org/tip/bf676945cb5bfe455321f57968967c18976f4995
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 3 Aug 2010 07:00:16 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 3 Aug 2010 07:00:16 -0700

um, x86: Cast to (u64 *) inside set_64bit()

After tightening up the types passed to set_64bit(), the cast to
(phys_t *) triggers a warning apparently because phys_t is defined as
"unsigned long" when building on 64 bits; however, u64 is defined as
"unsigned long long".  This is, however, a explicit cast inside a
size-specific call, so just make the cast explicitly (u64 *).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Jeff Dike <jdike@addtoit.com>
LKML-Reference: <tip-69309a05907546fb686b251d4ab041c26afe1e1d@git.kernel.org>
---
 arch/um/include/asm/pgtable-3level.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index 084de4a..0032f92 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -60,7 +60,7 @@
 	set_pud(pud, __pud(_PAGE_TABLE + __pa(pmd)))
 
 #ifdef CONFIG_64BIT
-#define set_pud(pudptr, pudval) set_64bit((phys_t *) (pudptr), pud_val(pudval))
+#define set_pud(pudptr, pudval) set_64bit((u64 *) (pudptr), pud_val(pudval))
 #else
 #define set_pud(pudptr, pudval) (*(pudptr) = (pudval))
 #endif
@@ -73,7 +73,7 @@ static inline int pgd_newpage(pgd_t pgd)
 static inline void pgd_mkuptodate(pgd_t pgd) { pgd_val(pgd) &= ~_PAGE_NEWPAGE; }
 
 #ifdef CONFIG_64BIT
-#define set_pmd(pmdptr, pmdval) set_64bit((phys_t *) (pmdptr), pmd_val(pmdval))
+#define set_pmd(pmdptr, pmdval) set_64bit((u64 *) (pmdptr), pmd_val(pmdval))
 #else
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
 #endif
