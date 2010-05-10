Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab0EJWzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:55:01 -0400
Received: from kroah.org ([198.145.64.141]:33362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531Ab0EJWwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:53 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:26 2010
Message-Id: <20100510223326.053630207@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [096/117] sparc64: Use correct pt_regs in decode_access_size() error paths.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit baa06775e224e9f74e5c2de894c95cd49678beff ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/unaligned_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -49,7 +49,7 @@ static inline enum direction decode_dire
 }
 
 /* 16 = double-word, 8 = extra-word, 4 = word, 2 = half-word */
-static inline int decode_access_size(unsigned int insn)
+static inline int decode_access_size(struct pt_regs *regs, unsigned int insn)
 {
 	unsigned int tmp;
 
@@ -65,7 +65,7 @@ static inline int decode_access_size(uns
 		return 2;
 	else {
 		printk("Impossible unaligned trap. insn=%08x\n", insn);
-		die_if_kernel("Byte sized unaligned access?!?!", current_thread_info()->kregs);
+		die_if_kernel("Byte sized unaligned access?!?!", regs);
 
 		/* GCC should never warn that control reaches the end
 		 * of this function without returning a value because
@@ -289,7 +289,7 @@ static void log_unaligned(struct pt_regs
 asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 {
 	enum direction dir = decode_direction(insn);
-	int size = decode_access_size(insn);
+	int size = decode_access_size(regs, insn);
 	int orig_asi, asi;
 
 	current_thread_info()->kern_una_regs = regs;


