Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1FPHBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:00 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41783 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab1FPHAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:44 -0400
X-Sasl-enc: XrVHBsgwhUeL7WW4RBUyeVSwoPDHtZ9JQz3q67gfY3Bp 1308207643
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000231.935366188@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [30/89] powerpc: Fix 32-bit SMP build
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Boyer <jwboyer@linux.vnet.ibm.com>

commit 6de06f313a65d0ecabf055e708d082002b568866 upstream.

Commit 69e3cea8d5fd526 ("powerpc/smp: Make start_secondary_resume
available to all CPU variants") introduced start_secondary_resume to
misc_32.S, however it uses a 64-bit instruction which is not valid on
32-bit platforms.  Use 'stw' instead.

Reported-by: Richard Cochran <richardcochran@gmail.com>
Tested-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/head_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -896,7 +896,7 @@ _GLOBAL(start_secondary_resume)
 	rlwinm	r1,r1,0,0,(31-THREAD_SHIFT)	/* current_thread_info() */
 	addi	r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
 	li	r3,0
-	std	r3,0(r1)		/* Zero the stack frame pointer	*/
+	stw	r3,0(r1)		/* Zero the stack frame pointer	*/
 	bl	start_secondary
 	b	.
 #endif /* CONFIG_SMP */


