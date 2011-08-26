Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1H0O7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1H0O7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:53 2011
Message-Id: <20110826215052.954390130@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [01/35] genirq: Fix wrong bit operation
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "jhbird.choi@samsung.com" <jhbird.choi@samsung.com>

commit 1dd75f91ae713049eb6baaa640078f3a6549e522 upstream.

(!msk & 0x01) should be !(msk & 0x01)

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Link: http://lkml.kernel.org/r/1311229754-6003-1-git-send-email-jhbird.choi@samsung.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/generic-chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -246,7 +246,7 @@ void irq_setup_generic_chip(struct irq_c
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -301,7 +301,7 @@ void irq_remove_generic_chip(struct irq_
 	raw_spin_unlock(&gc_lock);
 
 	for (; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		/* Remove handler first. That will mask the irq line */


