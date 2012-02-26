Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020Ab2BZFvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 00:51:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39885 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2BZFvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 00:51:14 -0500
Date: Sat, 25 Feb 2012 21:50:35 -0800
From: tip-bot for Bobby Powers <bobbypowers@gmail.com>
Message-ID: <tip-ce5f7a99df87918b5be4618a9386213a8e9a7146@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bobbypowers@gmail.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, bobbypowers@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1330230338-25077-1-git-send-email-bobbypowers@gmail.com>
References: <1330230338-25077-1-git-send-email-bobbypowers@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Make sure TS_COMPAT is cleared for x32 tasks
Git-Commit-ID: ce5f7a99df87918b5be4618a9386213a8e9a7146
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 25 Feb 2012 21:50:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce5f7a99df87918b5be4618a9386213a8e9a7146
Gitweb:     http://git.kernel.org/tip/ce5f7a99df87918b5be4618a9386213a8e9a7146
Author:     Bobby Powers <bobbypowers@gmail.com>
AuthorDate: Sat, 25 Feb 2012 23:25:38 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 25 Feb 2012 20:42:18 -0800

x32: Make sure TS_COMPAT is cleared for x32 tasks

If a process has a non-x32 ia32 personality and changes to x32, the
process would keep its TS_COMPAT flag. x32 uses the presence of the
x32 flag on a syscall to determine compat status, so make sure
TS_COMPAT is cleared.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
Link: http://lkml.kernel.org/r/1330230338-25077-1-git-send-email-bobbypowers@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index a0701da..32e0412 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -540,6 +540,9 @@ void set_personality_ia32(bool x32)
 		clear_thread_flag(TIF_IA32);
 		set_thread_flag(TIF_X32);
 		current->personality &= ~READ_IMPLIES_EXEC;
+		/* is_compat_task() uses the presence of the x32
+		   syscall bit flag to determine compat status */
+		current_thread_info()->status &= ~TS_COMPAT;
 	} else {
 		set_thread_flag(TIF_IA32);
 		clear_thread_flag(TIF_X32);
