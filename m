Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1CVPh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:37:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:48238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab1CVPh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:37:27 -0400
Date: Tue, 22 Mar 2011 15:36:55 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <AANLkTinsUfGc=NG_GeH_B+zFVu+DXJzZbJKdQLscqfuH@mail.gmail.com>
References: <AANLkTinsUfGc=NG_GeH_B+zFVu+DXJzZbJKdQLscqfuH@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mpparse: Move check_slot into CONFIG_X86_IO_APIC context
Message-ID: <tip-cbb84c4cc1ad0ab8faaffd899ccc9b14a88c91be@git.kernel.org>
Git-Commit-ID: cbb84c4cc1ad0ab8faaffd899ccc9b14a88c91be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 22 Mar 2011 15:37:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbb84c4cc1ad0ab8faaffd899ccc9b14a88c91be
Gitweb:     http://git.kernel.org/tip/cbb84c4cc1ad0ab8faaffd899ccc9b14a88c91be
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Tue, 22 Mar 2011 15:24:54 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Mar 2011 13:00:22 +0100

x86, mpparse: Move check_slot into CONFIG_X86_IO_APIC context

When CONFIG_X86_MPPARSE=y and CONFIG_X86_IO_APIC=n, then we get
the following warning:

  arch/x86/kernel/mpparse.c:723: warning: 'check_slot' defined but not used

So, put check_slot into CONFIG_X86_IO_APIC context. Its only
called from CONFIG_X86_IO_APIC=y context.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
LKML-Reference: <AANLkTinsUfGc=NG_GeH_B+zFVu+DXJzZbJKdQLscqfuH@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/mpparse.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6f789a8..5a532ce 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -714,10 +714,6 @@ static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 		*nr_m_spare += 1;
 	}
 }
-#else /* CONFIG_X86_IO_APIC */
-static
-inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
-#endif /* CONFIG_X86_IO_APIC */
 
 static int
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
@@ -731,6 +727,10 @@ check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 
 	return ret;
 }
+#else /* CONFIG_X86_IO_APIC */
+static
+inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+#endif /* CONFIG_X86_IO_APIC */
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
