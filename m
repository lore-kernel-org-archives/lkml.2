Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2AZVhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:37:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2AZVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:37:39 -0500
Date: Thu, 26 Jan 2012 13:37:17 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-fc395b9291925b1880e0afc61274fe2f6ddc1269@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F2183A9020000780006F3E6@nat28.tlf.novell.com>
References: <4F2183A9020000780006F3E6@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Properly parenthesize cmpxchg()
  macro arguments
Git-Commit-ID: fc395b9291925b1880e0afc61274fe2f6ddc1269
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 13:37:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc395b9291925b1880e0afc61274fe2f6ddc1269
Gitweb:     http://git.kernel.org/tip/fc395b9291925b1880e0afc61274fe2f6ddc1269
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 26 Jan 2012 15:47:37 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 21:18:29 +0100

x86: Properly parenthesize cmpxchg() macro arguments

Quite oddly, all of the arguments passed through from the top
level macros to the second level which didn't need parentheses
had them, while the only expression (involving a parameter)
needing them didn't.

Very recently I got bitten by the lack thereof when using
something like "array + index" for the first operand, with
"array" being an array more narrow than int.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F2183A9020000780006F3E6@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cmpxchg.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 0c9fa27..b3b7332 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -145,13 +145,13 @@ extern void __add_wrong_size(void)
 
 #ifdef __HAVE_ARCH_CMPXCHG
 #define cmpxchg(ptr, old, new)						\
-	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
+	__cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
 #define sync_cmpxchg(ptr, old, new)					\
-	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
+	__sync_cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
 #define cmpxchg_local(ptr, old, new)					\
-	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
+	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
 #endif
 
 /*
