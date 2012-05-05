Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2EESxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:53:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2EESxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:53:51 -0400
Date: Sat, 5 May 2012 11:53:38 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-0c4f6d6bd17bbcf165a2439b59b9e8212c19f645@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, msalter@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, msalter@redhat.com
In-Reply-To: <20120503085034.412398724@linutronix.de>
References: <20120503085034.412398724@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] c6x: Use generic init_task
Git-Commit-ID: 0c4f6d6bd17bbcf165a2439b59b9e8212c19f645
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:53:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c4f6d6bd17bbcf165a2439b59b9e8212c19f645
Gitweb:     http://git.kernel.org/tip/0c4f6d6bd17bbcf165a2439b59b9e8212c19f645
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:52 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:22 +0200

c6x: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-and-tested-by: Mark Salter <msalter@redhat.com>
Link: http://lkml.kernel.org/r/20120503085034.412398724@linutronix.de
---
 arch/c6x/Kconfig          |    1 +
 arch/c6x/kernel/process.c |   16 ----------------
 2 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 1c3ccd4..4189fb5 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -10,6 +10,7 @@ config TMS320C6X
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_GENERIC_INIT_TASK
 	select HAVE_MEMBLOCK
 	select SPARSE_IRQ
 	select IRQ_DOMAIN
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 7ca8c41..45e924a 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -26,22 +26,6 @@ void	(*c6x_halt)(void);
 
 extern asmlinkage void ret_from_fork(void);
 
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-
-/*
- * Initial thread structure.
- */
-union thread_union init_thread_union __init_task_data =	{
-	INIT_THREAD_INFO(init_task)
-};
-
-/*
- * Initial task structure.
- */
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
-
 /*
  * power off function, if any
  */
