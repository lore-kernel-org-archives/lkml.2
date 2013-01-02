Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3ABAJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 19:09:41 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58693 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3ABAJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 19:09:40 -0500
Date: Tue, 1 Jan 2013 16:09:35 -0800
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, Tom Herbert <therbert@google.com>
Subject: [PATCH 1/2] x86,smp: simplify __ticket_spin_lock
Message-ID: <20130102000935.GB13678@google.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20130102000653.GA13678@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102000653.GA13678@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just cosmetic - avoid an unnecessary goto construct

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 arch/x86/include/asm/spinlock.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 2a45eb0cdb2c..19e8a36b3b83 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -55,11 +55,8 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 
 	inc = xadd(&lock->tickets, inc);
 
-	if (inc.head == inc.tail)
-		goto out;
-
-	ticket_spin_lock_wait(lock, inc);
- out:
+	if (inc.head != inc.tail)
+		ticket_spin_lock_wait(lock, inc);
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
-- 
1.7.7.3
