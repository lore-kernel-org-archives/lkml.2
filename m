Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1LFHCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:02:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1LFHCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:02:06 -0500
Date: Mon, 5 Dec 2011 23:01:26 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-a074335a370eca6d72f2ec890e4ae22923a2aea4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, richard@nod.at, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, richard@nod.at, tglx@linutronix.de
In-Reply-To: <tip-45db1c6176c8171d9ae6fa6d82e07d115a5950ca@git.kernel.org>
References: <tip-45db1c6176c8171d9ae6fa6d82e07d115a5950ca@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/syscall] x86, um: Mark system call tables readonly
Git-Commit-ID: a074335a370eca6d72f2ec890e4ae22923a2aea4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 23:01:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a074335a370eca6d72f2ec890e4ae22923a2aea4
Gitweb:     http://git.kernel.org/tip/a074335a370eca6d72f2ec890e4ae22923a2aea4
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 5 Dec 2011 22:48:49 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 5 Dec 2011 22:56:38 -0800

x86, um: Mark system call tables readonly

Mark the system call tables readonly, as they already are on native,
and the 32-bit UM version was in the previous assembly version.  The
32-bit version lost it due to copy and paste from the 64-bit version,
which was missing the const.

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/tip-45db1c6176c8171d9ae6fa6d82e07d115a5950ca@git.kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/um/sys_call_table_32.c |    2 +-
 arch/x86/um/sys_call_table_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
index b897fca..0606aa3 100644
--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -43,7 +43,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index 797a639..fe626c3 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -45,7 +45,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
