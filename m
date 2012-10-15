Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2JOXKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab2JOXKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:10:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] FRV: Fix incorrect symbol in copy_thread()
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 16 Oct 2012 00:10:21 +0100
Message-ID: <20121015231021.23936.12585.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121015231012.23936.58430.stgit@warthog.procyon.org.uk>
References: <20121015231012.23936.58430.stgit@warthog.procyon.org.uk>
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

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
cc: Geert Uytterhoeven <geert@linux-m68k.org>
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

