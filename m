Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1A0PBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:01:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47628 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752059Ab1A0PAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:32 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/3+2YFRfz3E/hF3opuYExV4NtQGoJK+5couec5So
	b5YmT4XrbxzVi/
Subject: [PATCH v2 17/20] parisc: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Kyle McMartin <kyle@mcmartin.ca>, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 16:00:17 +0100
Message-ID: <20110127150017.23248.22559.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
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

