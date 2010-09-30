Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0I3XZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:25:19 -0400
Received: from www.tglx.de ([62.245.132.106]:34740 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab0I3XZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:25:15 -0400
Message-Id: <20100930221738.674120334@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:14:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Venkatesh Pallipadi <venki@google.com>, stable@kernel.org
Subject: [patch 02/47] x86: Hpet: Fix bogus error check in hpet_assign_irq()
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline;
	filename=x86-hpet-fix-bogus-error-check-in-hpet_assign_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_irq() returns -1 if the interrupt allocation failed, but the
code checks for irq == 0.

Use create_irq_nr() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <alpine.LFD.2.00.1009282310360.2416@localhost6.localdomain6>
Cc: stable@kernel.org
---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/hpet.c
+++ linux-2.6-tip/arch/x86/kernel/hpet.c
@@ -506,7 +506,7 @@ static int hpet_assign_irq(struct hpet_d
 {
 	unsigned int irq;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, -1);
 	if (!irq)
 		return -EINVAL;
 


