Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1EYVfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:35:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab1EYVfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:35:14 -0400
Date: Wed, 25 May 2011 21:34:26 GMT
From: tip-bot for Richard Kennedy <richard@rsk.demon.co.uk>
Message-ID: <tip-af6a25f0e1ec0265c267e6ee4513925eaba6d0ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, penberg@kernel.org,
        richard@rsk.demon.co.uk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, penberg@kernel.org,
        richard@rsk.demon.co.uk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306244999.1999.5.camel@castor.rsk>
References: <1306244999.1999.5.camel@castor.rsk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Reorder mm_context_t to remove x86_64 alignment padding and thus shrink mm_struct
Git-Commit-ID: af6a25f0e1ec0265c267e6ee4513925eaba6d0ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 May 2011 21:34:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af6a25f0e1ec0265c267e6ee4513925eaba6d0ed
Gitweb:     http://git.kernel.org/tip/af6a25f0e1ec0265c267e6ee4513925eaba6d0ed
Author:     Richard Kennedy <richard@rsk.demon.co.uk>
AuthorDate: Tue, 24 May 2011 14:49:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 May 2011 16:16:41 +0200

x86: Reorder mm_context_t to remove x86_64 alignment padding and thus shrink mm_struct

Reorder mm_context_t to remove alignment padding on 64 bit
builds shrinking its size from 64 to 56 bytes.

This allows mm_struct to shrink from 840 to 832 bytes, so using
one fewer cache lines, and getting more objects per slab when
using slub.

slabinfo mm_struct reports
before :-

    Sizes (bytes)     Slabs
    -----------------------------------
    Object :     840  Total  :       7
    SlabObj:     896  Full   :       1
    SlabSiz:   16384  Partial:       4
    Loss   :      56  CpuSlab:       2
    Align  :      64  Objects:      18

after :-

    Sizes (bytes)     Slabs
    ----------------------------------
    Object :     832  Total  :       7
    SlabObj:     832  Full   :       1
    SlabSiz:   16384  Partial:       4
    Loss   :       0  CpuSlab:       2
    Align  :      64  Objects:      19

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: wilsons@start.ca
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1306244999.1999.5.camel@castor.rsk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mmu.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index aeff3e8..5f55e69 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -11,14 +11,14 @@
 typedef struct {
 	void *ldt;
 	int size;
-	struct mutex lock;
-	void *vdso;
 
 #ifdef CONFIG_X86_64
 	/* True if mm supports a task running in 32 bit compatibility mode. */
 	unsigned short ia32_compat;
 #endif
 
+	struct mutex lock;
+	void *vdso;
 } mm_context_t;
 
 #ifdef CONFIG_SMP
