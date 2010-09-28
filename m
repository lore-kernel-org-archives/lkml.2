Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0I1VUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:20:38 -0400
Received: from www.tglx.de ([62.245.132.106]:49695 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab0I1VUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:20:36 -0400
Date: Tue, 28 Sep 2010 23:20:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: x86@kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] x86: hpet: Fix bogus error check in hpet_assign_irq()
Message-ID: <alpine.LFD.2.00.1009282310360.2416@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_irq() returns -1 if the interrupt allocation failed, but the
code checks for irq == 0.

Use create_irq_nr() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -506,7 +506,7 @@ static int hpet_assign_irq(struct hpet_d
 {
 	unsigned int irq;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, -1);
 	if (!irq)
 		return -EINVAL;
 
