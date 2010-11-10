Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab0KJWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:16:56 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:42529 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610Ab0KJWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:16:55 -0500
X-AuditID: 12074423-b7bd0ae000000a00-45-4cdb19d6786e
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] Improve clocksource unstable warning
Date: Wed, 10 Nov 2010 17:16:46 -0500
Message-Id: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.3.2
X-Brightmail-Tracker: AAAAARagEl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system goes out to lunch for a long time, the clocksource
watchdog might get false positives.  Clarify the warning so that
people stop blaming their system freezes on the timing code.

This change was Thomas Gleixner's suggestion.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
I've only compile-tested on 2.6.36, but it applies cleanly to Linus' tree
and it's rather trivial.

 kernel/time/clocksource.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..5b30aa2 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -215,8 +215,10 @@ static void __clocksource_unstable(struct clocksource *cs)
 
 static void clocksource_unstable(struct clocksource *cs, int64_t delta)
 {
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
+	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)%s\n",
+	       cs->name, delta,
+	       delta < -5000000000LL ?
+		 " or your system lagged for other reasons" : "");
 	__clocksource_unstable(cs);
 }
 
-- 
1.7.3.2

