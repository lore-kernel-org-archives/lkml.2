Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1DSURW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:22 -0400
Received: from kroah.org ([198.145.64.141]:35532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1DSURO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201046.449606659@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [31/70] sparc32: Fix might-be-used-uninitialized warning in do_sparc_fault().
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit c816be7b5f24585baa9eba1f2413935f771d6ad6 ]

When we try to handle vmalloc faults, we can take a code
path which uses "code" before we actually set it.

Amusingly gcc-3.3 notices this yet gcc-4.x does not.

Reported-by: Bob Breuer <breuerr@mc.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/mm/fault_32.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -240,11 +240,10 @@ asmlinkage void do_sparc_fault(struct pt
 	 * only copy the information from the master page table,
 	 * nothing more.
 	 */
+	code = SEGV_MAPERR;
 	if (!ARCH_SUN4C && address >= TASK_SIZE)
 		goto vmalloc_fault;
 
-	code = SEGV_MAPERR;
-
 	/*
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..


