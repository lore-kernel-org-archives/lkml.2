Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2DFKEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:04:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2DFKEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:04:02 -0400
Date: Fri, 6 Apr 2012 03:03:49 -0700
From: tip-bot for Emil Goode <emilgoode@gmail.com>
Message-ID: <tip-46ed99d1b7c92920ce9e313152522847647aae4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, emilgoode@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, emilgoode@gmail.com, tglx@linutronix.de
In-Reply-To: <1333306084-3776-1-git-send-email-emilgoode@gmail.com>
References: <1333306084-3776-1-git-send-email-emilgoode@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: vsyscall:
  Use NULL instead 0 for a pointer argument
Git-Commit-ID: 46ed99d1b7c92920ce9e313152522847647aae4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Apr 2012 03:03:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46ed99d1b7c92920ce9e313152522847647aae4f
Gitweb:     http://git.kernel.org/tip/46ed99d1b7c92920ce9e313152522847647aae4f
Author:     Emil Goode <emilgoode@gmail.com>
AuthorDate: Sun, 1 Apr 2012 20:48:04 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 6 Apr 2012 11:49:59 +0200

x86: vsyscall: Use NULL instead 0 for a pointer argument

This patch silences the following sparse warning:
arch/x86/kernel/vsyscall_64.c:250:34:
       warning: Using plain integer as NULL pointer

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Cc: john.stultz@linaro.org
Link: http://lkml.kernel.org/r/1333306084-3776-1-git-send-email-emilgoode@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/vsyscall_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index f386dc4..7515cf0 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -216,9 +216,9 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	current_thread_info()->sig_on_uaccess_error = 1;
 
 	/*
-	 * 0 is a valid user pointer (in the access_ok sense) on 32-bit and
+	 * NULL is a valid user pointer (in the access_ok sense) on 32-bit and
 	 * 64-bit, so we don't need to special-case it here.  For all the
-	 * vsyscalls, 0 means "don't write anything" not "write it at
+	 * vsyscalls, NULL means "don't write anything" not "write it at
 	 * address 0".
 	 */
 	ret = -EFAULT;
@@ -247,7 +247,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 
 		ret = sys_getcpu((unsigned __user *)regs->di,
 				 (unsigned __user *)regs->si,
-				 0);
+				 NULL);
 		break;
 	}
 
