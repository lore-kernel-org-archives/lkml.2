Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2FJRoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:44:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2FJRoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:44:09 -0400
Date: Sun, 10 Jun 2012 10:43:38 -0700
From: tip-bot for Martin Pelikan <pelikan@storkhole.cz>
Message-ID: <tip-9271b0b4b2044c6db06051fe60bc58cdd4f17c7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pelikan@storkhole.cz, richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pelikan@storkhole.cz, richard@nod.at, tglx@linutronix.de
In-Reply-To: <1339269731-10772-1-git-send-email-pelikan@storkhole.cz>
References: <1339269731-10772-1-git-send-email-pelikan@storkhole.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, um:
  Correct syscall table type attributes breaking gcc 4.8
Git-Commit-ID: 9271b0b4b2044c6db06051fe60bc58cdd4f17c7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 10 Jun 2012 10:43:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9271b0b4b2044c6db06051fe60bc58cdd4f17c7c
Gitweb:     http://git.kernel.org/tip/9271b0b4b2044c6db06051fe60bc58cdd4f17c7c
Author:     Martin Pelikan <pelikan@storkhole.cz>
AuthorDate: Sat, 9 Jun 2012 21:22:11 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 9 Jun 2012 12:51:09 -0700

x86, um: Correct syscall table type attributes breaking gcc 4.8

The latest GCC 4.8 does some more checking on type attributes that
break the build for ARCH=um -> fill them in.  Specifically, the
"asmlinkage" attributes is now tested for consistency.

Signed-off-by: Martin Pelikan <pelikan@storkhole.cz>
Link: http://lkml.kernel.org/r/1339269731-10772-1-git-send-email-pelikan@storkhole.cz
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/um/sys_call_table_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
index 416bd40..68d1dc9 100644
--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -39,9 +39,9 @@
 #undef __SYSCALL_I386
 #define __SYSCALL_I386(nr, sym, compat) [ nr ] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
+typedef asmlinkage void (*sys_call_ptr_t)(void);
 
-extern void sys_ni_syscall(void);
+extern asmlinkage void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 	/*
