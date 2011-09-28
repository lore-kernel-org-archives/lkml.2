Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1I1Xax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:30:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1I1Wi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220129.923820287@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kjetil Oftedal <oftedal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [044/244] sparc32,sun4d: Change IPI IRQ level to prevent collision between IPI and timer interrupt
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kjetil Oftedal <oftedal@gmail.com>

commit 38f7f8f05e8239e9871f7e1c4b0a842080e85315 upstream.

On Sun4d systems running in SMP mode, IRQ 14 is used for timer interrupts
and has a specialized interrupt handler. IPI is currently set to use IRQ 14
as well, which causes it to trigger the timer interrupt handler, and not the
IPI interrupt handler.

The IPI interrupt is therefore changed to IRQ 13, which is the highest
normally handled interrupt. This IRQ is also used for SBUS interrupts,
however there is nothing in the IPI/SBUS interrupt handlers that indicate
that they will not handle sharing the interrupt.
(IRQ 13 is indicated as audio interrupt, which is unlikely to be found in a
sun4d system)

Signed-off-by: Kjetil Oftedal <oftedal@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/irq.h
+++ b/arch/sparc/kernel/irq.h
@@ -88,7 +88,7 @@ BTFIXUPDEF_CALL(void, set_irq_udt, int)
 #define set_irq_udt(cpu) BTFIXUP_CALL(set_irq_udt)(cpu)
 
 /* All SUN4D IPIs are sent on this IRQ, may be shared with hard IRQs */
-#define SUN4D_IPI_IRQ 14
+#define SUN4D_IPI_IRQ 13
 
 extern void sun4d_ipi_interrupt(void);
 


