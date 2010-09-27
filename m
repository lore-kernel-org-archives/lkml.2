Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab0I0Kso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758576Ab0I0Ksn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:48:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] mn10300: ->restart_block.fn needs to be reset on sigreturn
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Date: Mon, 27 Sep 2010 11:47:59 +0100
Message-ID: <20100927104759.6377.41993.stgit@warthog.procyon.org.uk>
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

Reset restart_block.fn on executing a sigreturn such that any currently
pending system call restarts will be forced to return -EINTR.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 4ef9925..5a2c004 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -102,6 +102,9 @@ static int restore_sigcontext(struct pt_regs *regs,
 {
 	unsigned int err = 0;
 
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
 	if (is_using_fpu(current))
 		fpu_kill_state(current);
 

