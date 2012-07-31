Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2GaEv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48897 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755747Ab2GaEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:12 -0400
Message-Id: <20120731044314.488505407@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, roger blofeld <blofeldus@yahoo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 20/73] powerpc/ftrace: Fix assembly trampoline register usage
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: roger blofeld <blofeldus@yahoo.com>

commit fd5a42980e1cf327b7240adf5e7b51ea41c23437 upstream.

Just like the module loader, ftrace needs to be updated to use r12
instead of r11 with newer gcc's.

Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/ftrace.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 6f33296..91b46b7 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -240,9 +240,9 @@ __ftrace_make_nop(struct module *mod,
 
 	/*
 	 * On PPC32 the trampoline looks like:
-	 *  0x3d, 0x60, 0x00, 0x00  lis r11,sym@ha
-	 *  0x39, 0x6b, 0x00, 0x00  addi r11,r11,sym@l
-	 *  0x7d, 0x69, 0x03, 0xa6  mtctr r11
+	 *  0x3d, 0x80, 0x00, 0x00  lis r12,sym@ha
+	 *  0x39, 0x8c, 0x00, 0x00  addi r12,r12,sym@l
+	 *  0x7d, 0x89, 0x03, 0xa6  mtctr r12
 	 *  0x4e, 0x80, 0x04, 0x20  bctr
 	 */
 
@@ -257,9 +257,9 @@ __ftrace_make_nop(struct module *mod,
 	pr_devel(" %08x %08x ", jmp[0], jmp[1]);
 
 	/* verify that this is what we expect it to be */
-	if (((jmp[0] & 0xffff0000) != 0x3d600000) ||
-	    ((jmp[1] & 0xffff0000) != 0x396b0000) ||
-	    (jmp[2] != 0x7d6903a6) ||
+	if (((jmp[0] & 0xffff0000) != 0x3d800000) ||
+	    ((jmp[1] & 0xffff0000) != 0x398c0000) ||
+	    (jmp[2] != 0x7d8903a6) ||
 	    (jmp[3] != 0x4e800420)) {
 		printk(KERN_ERR "Not a trampoline\n");
 		return -EINVAL;


