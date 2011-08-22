Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1HVWtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:49:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:50676 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1HVWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:49:52 -0400
Date: Mon, 22 Aug 2011 22:49:43 GMT
From: tip-bot for Zhao Jin <cronozhj@gmail.com>
Message-ID: <tip-54f6de81be44e889d66c144fc449fefe586aa3b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        cronozhj@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cronozhj@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4E4FB5A9.700@gmail.com>
References: <4E4FB5A9.700@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, mm, trivial: Rmove unnecessary get_order in free_thread_info
Git-Commit-ID: 54f6de81be44e889d66c144fc449fefe586aa3b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 22 Aug 2011 22:49:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54f6de81be44e889d66c144fc449fefe586aa3b8
Gitweb:     http://git.kernel.org/tip/54f6de81be44e889d66c144fc449fefe586aa3b8
Author:     Zhao Jin <cronozhj@gmail.com>
AuthorDate: Sat, 20 Aug 2011 21:24:57 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 22 Aug 2011 15:37:31 -0700

x86, mm, trivial: Rmove unnecessary get_order in free_thread_info

Because THREAD_SIZE is defined as PAGE_SIZE << THREAD_ORDER on x86, the
call of get_order(THREAD_SIZE) can be replaced with THREAD_ORDER.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
Link: http://lkml.kernel.org/r/4E4FB5A9.700@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3b01..b9b3b1a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -49,7 +49,7 @@ void free_thread_xstate(struct task_struct *tsk)
 void free_thread_info(struct thread_info *ti)
 {
 	free_thread_xstate(ti->task);
-	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
+	free_pages((unsigned long)ti, THREAD_ORDER);
 }
 
 void arch_task_cache_init(void)
