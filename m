Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1AVAPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:15:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34691 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755148Ab1AVAPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:15:09 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18c6x1k268cU5oJjZlodeD5NdII5/rNKgRoAjiEZ5
	DrcDZ8MsCbGXuP
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 15/18] parisc: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:07:01 +0100
Message-Id: <1295651224-29823-16-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/parisc/kernel/time.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 05511cc..72ec318 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -163,9 +163,7 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 	}
 
 	if (cpu == 0) {
-		write_seqlock(&xtime_lock);
-		do_timer(ticks_elapsed);
-		write_sequnlock(&xtime_lock);
+		xtime_update(ticks_elapsed);
 	}
 
 	return IRQ_HANDLED;
-- 
1.7.2.3

