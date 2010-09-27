Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab0I0Kss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773Ab0I0Ksr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:48:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5] mn10300: Get rid of set_fs(USER_DS) in sigframe setup
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Date: Mon, 27 Sep 2010 11:48:04 +0100
Message-ID: <20100927104804.6377.15062.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100927104749.6377.46813.stgit@warthog.procyon.org.uk>
References: <20100927104749.6377.46813.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

The set_fs(USER_DS) in the signal frame setup code really has no business
being there; short of a serious kernel bug we should already have USER_DS at
that point.  It shouldn't have been done on x86 either...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/signal.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)


diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 5a2c004..ae36480 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -333,8 +333,6 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	regs->d0 = sig;
 	regs->d1 = (unsigned long) &frame->sc;
 
-	set_fs(USER_DS);
-
 	/* the tracer may want to single-step inside the handler */
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
@@ -416,8 +414,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->d0 = sig;
 	regs->d1 = (long) &frame->info;
 
-	set_fs(USER_DS);
-
 	/* the tracer may want to single-step inside the handler */
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);

