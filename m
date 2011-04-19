Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1DSURT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:19 -0400
Received: from kroah.org ([198.145.64.141]:35537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab1DSURP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201046.561934944@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tkhai Kirill <tkhai@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [32/70] sparc32: Pass task_struct to schedule_tail() in ret_from_fork
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Tkhai Kirill <tkhai@yandex.ru>

[ Upstream commit 47c7c97a93a5b8f719093dbf83555090b3b8228b ]

We have to pass task_struct of previous process to function
schedule_tail(). Currently in ret_from_fork previous thread_info
is passed:

switch_to: mov %g6, %g3 /* previous thread_info in g6 */

ret_from_fork: call    schedule_tail
                mov    %g3, %o0 /* previous thread_info is passed */

void schedule_tail(struct task_struct *prev);

Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -1283,7 +1283,7 @@ linux_syscall_trace:
 	.globl	ret_from_fork
 ret_from_fork:
 	call	schedule_tail
-	 mov	%g3, %o0
+	 ld	[%g3 + TI_TASK], %o0
 	b	ret_sys_call
 	 ld	[%sp + STACKFRAME_SZ + PT_I0], %o0
 


