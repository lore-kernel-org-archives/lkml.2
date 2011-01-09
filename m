Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1AIVNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:13:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:53834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1AIVNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:13:21 -0500
Date: Sun, 9 Jan 2011 21:12:58 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <20110108195914.95d366ea.randy.dunlap@oracle.com>
References: <20110108195914.95d366ea.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix sparse non-ANSI function warnings in smpboot.c
Message-ID: <tip-91d88ce22bca3dcf269661b54d4ea75576dc4e29@git.kernel.org>
Git-Commit-ID: 91d88ce22bca3dcf269661b54d4ea75576dc4e29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 Jan 2011 21:12:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91d88ce22bca3dcf269661b54d4ea75576dc4e29
Gitweb:     http://git.kernel.org/tip/91d88ce22bca3dcf269661b54d4ea75576dc4e29
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Sat, 8 Jan 2011 19:59:14 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Jan 2011 10:15:19 +0100

x86: Fix sparse non-ANSI function warnings in smpboot.c

Fix sparse warning for non-ANSI function declaration:

  arch/x86/kernel/smpboot.c:100:30: warning: non-ANSI function declaration of function 'cpu_hotplug_driver_lock'
  arch/x86/kernel/smpboot.c:105:32: warning: non-ANSI function declaration of function 'cpu_hotplug_driver_unlock'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <20110108195914.95d366ea.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ee886fe..5fdc095 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -97,12 +97,12 @@ static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
  */
 static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
 
-void cpu_hotplug_driver_lock()
+void cpu_hotplug_driver_lock(void)
 {
         mutex_lock(&x86_cpu_hotplug_driver_mutex);
 }
 
-void cpu_hotplug_driver_unlock()
+void cpu_hotplug_driver_unlock(void)
 {
         mutex_unlock(&x86_cpu_hotplug_driver_mutex);
 }
