Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab2JAXR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:17:59 -0400
Received: from 1wt.eu ([62.212.114.60]:35442 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020Ab2JAXBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:51 -0400
Message-Id: <20121001225201.807308843@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roger Blofeld <blofeldus@yahoo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 099/180] powerpc/ftrace: Fix assembly trampoline register usage
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: roger blofeld <blofeldus@yahoo.com>

commit fd5a42980e1cf327b7240adf5e7b51ea41c23437 upstream.

Just like the module loader, ftrace needs to be updated to use r12
instead of r11 with newer gcc's.

Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit a8ed5765b5a8bf44a86284d80afd24f37a23e369 upstream.
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/powerpc/kernel/ftrace.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index ce1f3e4..eda40d2 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -244,9 +244,9 @@ __ftrace_make_nop(struct module *mod,
 
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
 
@@ -261,9 +261,9 @@ __ftrace_make_nop(struct module *mod,
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
-- 
1.7.2.1.45.g54fbc



