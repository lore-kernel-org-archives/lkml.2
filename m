Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0EDMnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab0EDMna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:43:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix the x86_64 implementation of call_rwsem_wait()
To: torvalds@osdl.org, akpm@linux-foundation.org, hpa@zytor.com
Cc: dhowells@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 May 2010 13:42:53 +0100
Message-ID: <20100504124253.30994.79841.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 call_rwsem_wait() treats the active state counter part of the R/W
semaphore state as being 16-bit when it's actually 32-bit (it's half of the
64-bit state).  It should do "decl %edx" not "decw %dx".

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/lib/rwsem_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
index 15acecf..41fcf00 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem_64.S
@@ -60,7 +60,7 @@ ENTRY(call_rwsem_down_write_failed)
 	ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
-	decw %dx    /* do nothing if still outstanding active readers */
+	decl %edx	/* do nothing if still outstanding active readers */
 	jnz 1f
 	save_common_regs
 	movq %rax,%rdi

