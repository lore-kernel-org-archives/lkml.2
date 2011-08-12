Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1HNQFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:05:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1HNQFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:05:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.482349876@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [04/90] cris: add missing declaration of kgdb_init() and breakpoint()
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

commit 1646ec9db75e151b0479dbfaf972f741d0476ec7 upstream.

Fix:

  arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration of function 'kgdb_init'
  arch/cris/arch-v10/kernel/irq.c:240: error: implicit declaration of function 'breakpoint'

Declare these two functions.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/cris/arch-v10/kernel/irq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/cris/arch-v10/kernel/irq.c
+++ b/arch/cris/arch-v10/kernel/irq.c
@@ -20,6 +20,9 @@
 #define crisv10_mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
 #define crisv10_unmask_irq(irq_nr) (*R_VECT_MASK_SET = 1 << (irq_nr));
 
+extern void kgdb_init(void);
+extern void breakpoint(void);
+
 /* don't use set_int_vector, it bypasses the linux interrupt handlers. it is
  * global just so that the kernel gdb can use it.
  */


