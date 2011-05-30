Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab1E3LFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:05:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:37568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab1E3LE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:04:57 -0400
Date: Mon, 30 May 2011 11:04:35 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-598e887d8b01655780c81cc86a9e7820ed091580@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, bp@alien8.de, tglx@linutronix.de,
        len.brown@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, bp@alien8.de, tglx@linutronix.de,
        len.brown@intel.com, mingo@elte.hu
In-Reply-To: <1306748286-24701-1-git-send-email-bp@alien8.de>
References: <1306748286-24701-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86 idle: Fix mwait deprecation warning message
Git-Commit-ID: 598e887d8b01655780c81cc86a9e7820ed091580
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 May 2011 11:04:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  598e887d8b01655780c81cc86a9e7820ed091580
Gitweb:     http://git.kernel.org/tip/598e887d8b01655780c81cc86a9e7820ed091580
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 30 May 2011 11:38:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 May 2011 13:02:04 +0200

x86 idle: Fix mwait deprecation warning message

Fix:

  arch/x86/kernel/process.c:645:1: warning: unknown escape sequence '\i'

due to missing escape backslash, introduced by this commit:

  5d4c47e0195b: x86 idle: deprecate mwait_idle() and "idle=mwait" cmdline param

Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1306748286-24701-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 426a5b6..3d83a71 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
+		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\"\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
