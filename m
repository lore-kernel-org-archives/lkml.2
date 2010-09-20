Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0ITON0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab0ITONY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:13:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] frv: avoid infinite loop of SIGSEGV delivery
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Date: Mon, 20 Sep 2010 15:13:14 +0100
Message-ID: <20100920141314.11066.19947.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
References: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

Use force_sigsegv() rather than force_sig(SIGSEGV, ...) as the former resets
the SEGV handler pointer which will kill the process, rather than leaving it
open to an infinite loop if the SEGV handler itself caused a SEGV signal.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 5fb2d06..48203c6 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -329,7 +329,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 	return 0;
 
 give_sigsegv:
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 	return -EFAULT;
 
 } /* end setup_frame() */
@@ -431,7 +431,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	return 0;
 
 give_sigsegv:
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 	return -EFAULT;
 
 } /* end setup_rt_frame() */

