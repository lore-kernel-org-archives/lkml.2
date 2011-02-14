Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1BNSH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:45651 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1BNSHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:52 -0500
Date: Mon, 14 Feb 2011 13:54:43 GMT
From: tip-bot for Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, kamal@canonical.com, stable@kernel.org,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, kamal@canonical.com, stable@kernel.org,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu, len.brown@intel.com
In-Reply-To: <1296783486-23033-2-git-send-email-kamal@canonical.com>
References: <1296783486-23033-2-git-send-email-kamal@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Emit "mem=nopentium ignored" warning when not supported
Message-ID: <tip-9a6d44b9adb777ca9549e88cd55bd8f2673c52a2@git.kernel.org>
Git-Commit-ID: 9a6d44b9adb777ca9549e88cd55bd8f2673c52a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:07:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a6d44b9adb777ca9549e88cd55bd8f2673c52a2
Gitweb:     http://git.kernel.org/tip/9a6d44b9adb777ca9549e88cd55bd8f2673c52a2
Author:     Kamal Mostafa <kamal@canonical.com>
AuthorDate: Thu, 3 Feb 2011 17:38:05 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:15:43 +0100

x86: Emit "mem=nopentium ignored" warning when not supported

Emit warning when "mem=nopentium" is specified on any arch other
than x86_32 (the only that arch supports it).

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
BugLink: http://bugs.launchpad.net/bugs/553464
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1296783486-23033-2-git-send-email-kamal@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/e820.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 55a59d8..0b5e2b5 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -847,12 +847,15 @@ static int __init parse_memopt(char *p)
 	if (!p)
 		return -EINVAL;
 
-#ifdef CONFIG_X86_32
 	if (!strcmp(p, "nopentium")) {
+#ifdef CONFIG_X86_32
 		setup_clear_cpu_cap(X86_FEATURE_PSE);
 		return 0;
-	}
+#else
+		printk(KERN_WARNING "mem=nopentium ignored! (only supported on x86_32)\n");
+		return -EINVAL;
 #endif
+	}
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
