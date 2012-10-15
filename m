Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab2JOMVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab2JOMVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:21:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] FRV: Fix VLIW packing constraint violation in entry.S
 [ver #2]
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 15 Oct 2012 13:21:37 +0100
Message-ID: <20121015122137.25532.4257.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix VLIW packing constraint violation in entry.S:

	arch/frv/kernel/entry.S: Assembler messages:
	arch/frv/kernel/entry.S:871: Error: VLIW packing constraint violation

When packing CALLL with OR, CALLL must go in the first slot.  The instructions
are executed simultaneously, so it doesn't matter which way round they're
packed from that point of view.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>
---

 arch/frv/kernel/entry.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 0027329..ee0beb3 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -867,8 +867,8 @@ ret_from_fork:
 ret_from_kernel_thread:
 	lddi.p		@(gr28,#REG_GR(8)),gr20
 	call		schedule_tail
-	or.p		gr20,gr20,gr8
-	calll		@(gr21,gr0)
+	calll.p		@(gr21,gr0)
+	or		gr20,gr20,gr8
 	bra		sys_exit
 
 	.globl		ret_from_kernel_execve

