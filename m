Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0H0JoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab0H0JoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wXf/2pcEt22p+Xp1AeMcFzVFOV4Prg+UJGdNdH5yi9W28BksC4p43VMhFF4KcUmGoa
         ao0OcjR6QzaeazNh21BCTo8Yj/rVnMxZ6G+/kwRLgcGpjPDGPvA8HuuoDR5tvAmf787h
         Er8tG41arsvTffjoAS6shQB/ccZlJBHHhjb94=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [RFC PATCH 28/43] ptrace, mn10300: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:14 +0900
Message-Id: <1282902149-12991-29-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/kernel/ptrace.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index cf847da..4261810 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -295,7 +295,8 @@ void ptrace_disable(struct task_struct *child)
 /*
  * handle the arch-specific side of process tracing
  */
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int ret;
@@ -304,8 +305,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		tmp = 0;  /* Default return condition */
@@ -318,8 +318,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR:
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		ret = 0;
-- 
1.7.2.2

