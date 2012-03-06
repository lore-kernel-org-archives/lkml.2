Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab2CFA4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:56:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab2CFA4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:56:50 -0500
Date: Mon, 5 Mar 2012 16:56:06 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-a628b684d27d22631d1819890f13047ae9075241@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Provide separate is_ia32_task() and is_x32_task
 () predicates
Git-Commit-ID: a628b684d27d22631d1819890f13047ae9075241
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 16:56:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a628b684d27d22631d1819890f13047ae9075241
Gitweb:     http://git.kernel.org/tip/a628b684d27d22631d1819890f13047ae9075241
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 5 Mar 2012 13:39:29 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 5 Mar 2012 15:35:18 -0800

x32: Provide separate is_ia32_task() and is_x32_task() predicates

The is_compat_task() test is composed of two predicates already, so
make each of them available separately.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
---
 arch/x86/include/asm/compat.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index e7f68b4..355edc0 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -235,12 +235,17 @@ static inline void __user *arch_compat_alloc_user_space(long len)
 	return (void __user *)round_down(sp - len, 16);
 }
 
-static inline bool is_compat_task(void)
+static inline bool is_ia32_task(void)
 {
 #ifdef CONFIG_IA32_EMULATION
 	if (current_thread_info()->status & TS_COMPAT)
 		return true;
 #endif
+	return false;
+}
+
+static inline bool is_x32_task(void)
+{
 #ifdef CONFIG_X86_X32_ABI
 	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
 		return true;
@@ -248,4 +253,9 @@ static inline bool is_compat_task(void)
 	return false;
 }
 
+static inline bool is_compat_task(void)
+{
+	return is_ia32_task() || is_x32_task();
+}
+
 #endif /* _ASM_X86_COMPAT_H */
