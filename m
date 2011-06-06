Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1FFIcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:32:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:34255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab1FFIcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:32:11 -0400
Date: Mon, 6 Jun 2011 08:31:08 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-6879eb2deed7171a81b2f904c9ad14b9648689a7@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
In-Reply-To: <5f3bc5542e9aaa9382d53f153f54373165cdef89.1307292171.git.luto@mit.edu>
References: <5f3bc5542e9aaa9382d53f153f54373165cdef89.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Fix alignment of jiffies variable
Git-Commit-ID: 6879eb2deed7171a81b2f904c9ad14b9648689a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 08:31:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6879eb2deed7171a81b2f904c9ad14b9648689a7
Gitweb:     http://git.kernel.org/tip/6879eb2deed7171a81b2f904c9ad14b9648689a7
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Sun, 5 Jun 2011 13:50:17 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jun 2011 21:30:31 +0200

x86-64: Fix alignment of jiffies variable

It's declared __attribute__((aligned(16)) but it's explicitly
not aligned.  This is probably harmless but it's a bit
embarrassing.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/5f3bc5542e9aaa9382d53f153f54373165cdef89.1307292171.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/vvar.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 341b355..a4eaca4 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -45,7 +45,7 @@
 /* DECLARE_VVAR(offset, type, name) */
 
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(8, int, vgetcpu_mode)
+DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
