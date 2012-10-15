Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2JOLny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2JOLnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:43:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] FRV: Fix incorrect symbol in copy_thread()
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 15 Oct 2012 12:43:50 +0100
Message-ID: <20121015114350.1042.3356.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121015114343.1042.81528.stgit@warthog.procyon.org.uk>
References: <20121015114343.1042.81528.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an incorrect symbol in copy_thread():

	arch/frv/kernel/process.c: In function 'copy_thread':
	arch/frv/kernel/process.c:197: error: 'chilregs' undeclared (first use in this function)
	arch/frv/kernel/process.c:197: error: (Each undeclared identifier is reported only once
	arch/frv/kernel/process.c:197: error: for each function it appears in.)
m

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>
---

 arch/frv/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 655d90d..e1e3aa1 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -194,7 +194,7 @@ int copy_thread(unsigned long clone_flags,
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->gr9 = usp; /* function */
 		childregs->gr8 = arg;
-		chilregs->psr = PSR_S;
+		childregs->psr = PSR_S;
 		p->thread.pc = (unsigned long) ret_from_kernel_thread;
 		save_user_regs(p->thread.user);
 		return 0;

