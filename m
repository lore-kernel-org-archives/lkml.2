Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1HWVBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:01:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:52911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1HWVBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:01:33 -0400
Date: Tue, 23 Aug 2011 21:01:20 GMT
From: tip-bot for Zhao Jin <cronozhj@gmail.com>
Message-ID: <tip-c812d8f7ad27bd5f1ed1c790eea8527b6f8ff1c7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        cronozhj@gmail.com, tglx@linutronix.de, hpa@linux.intel.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cronozhj@gmail.com, tglx@linutronix.de, hpa@linux.intel.com,
        mingo@elte.hu
In-Reply-To: <4E4FB5A9.700@gmail.com>
References: <4E4FB5A9.700@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, mm, trivial: Remove unnecessary get_order() in free_thread_info()
Git-Commit-ID: c812d8f7ad27bd5f1ed1c790eea8527b6f8ff1c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 23 Aug 2011 21:01:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c812d8f7ad27bd5f1ed1c790eea8527b6f8ff1c7
Gitweb:     http://git.kernel.org/tip/c812d8f7ad27bd5f1ed1c790eea8527b6f8ff1c7
Author:     Zhao Jin <cronozhj@gmail.com>
AuthorDate: Sat, 20 Aug 2011 21:24:57 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Aug 2011 21:49:35 +0200

x86, mm, trivial: Remove unnecessary get_order() in free_thread_info()

Because THREAD_SIZE is defined as PAGE_SIZE << THREAD_ORDER on x86, the
call of get_order(THREAD_SIZE) can be replaced with THREAD_ORDER.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
Link: http://lkml.kernel.org/r/4E4FB5A9.700@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
