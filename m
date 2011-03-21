Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1CUX4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:56:06 -0400
Received: from kroah.org ([198.145.64.141]:49131 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab1CUXOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:14:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:54 2011
Message-Id: <20110321231054.493495216@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [37/44] [PARISC] fix per-cpu flag problem in the cpu affinity checkers
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 9804c9eaeacfe78651052c5ddff31099f60ef78c upstream.

The CHECK_IRQ_PER_CPU is wrong, it should be checking
irq_to_desc(irq)->status not just irq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -117,7 +117,7 @@ int cpu_check_affinity(unsigned int irq,
 	int cpu_dest;
 
 	/* timer and ipi have to always be received on all CPUs */
-	if (CHECK_IRQ_PER_CPU(irq)) {
+	if (CHECK_IRQ_PER_CPU(irq_to_desc(irq)->status)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
 		cpumask_setall(irq_desc[irq].affinity);


