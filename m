Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab2HGXoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:44:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2HGW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roger Blofeld <blofeldus@yahoo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [ 005/122] powerpc/ftrace: Fix assembly trampoline register usage
Date: Tue,  7 Aug 2012 15:24:53 -0700
Message-Id: <20120807221948.713954066@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: roger blofeld <blofeldus@yahoo.com>

commit fd5a42980e1cf327b7240adf5e7b51ea41c23437 upstream.

Just like the module loader, ftrace needs to be updated to use r12
instead of r11 with newer gcc's.

Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/ftrace.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -245,9 +245,9 @@ __ftrace_make_nop(struct module *mod,
 
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
 
@@ -262,9 +262,9 @@ __ftrace_make_nop(struct module *mod,
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


