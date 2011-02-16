Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab1BPAdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:33:19 -0500
Received: from kroah.org ([198.145.64.141]:49747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab1BPAYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.582498483@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [235/272] x86: Readd missing irq_to_desc() in fixup_irq()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5117348dea5e3ecbb785cfa1271386fb49332b41 upstream.

commit a3c08e5d(x86: Convert irq_chip access to new functions)
accidentally zapped desc = irq_to_desc(irq); in the vector loop.
So we lock some random irq descriptor.

Add it back.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/irq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -357,7 +357,8 @@ void fixup_irqs(void)
 		if (irr  & (1 << (vector % 32))) {
 			irq = __get_cpu_var(vector_irq)[vector];
 
-			data = irq_get_irq_data(irq);
+			desc = irq_to_desc(irq);
+			data = &desc->irq_data;
 			raw_spin_lock(&desc->lock);
 			if (data->chip->irq_retrigger)
 				data->chip->irq_retrigger(data);


