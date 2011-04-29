Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777Ab1D2SCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:02:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51288 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760726Ab1D2SCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MCHs7CzzhgT/Lu2BvI3rqOwJAO4ITyAtZDT18JERIA0NKurCNe+bkrHWrPx4Ix0RZa
         4EhhcgvdG3TdsHxaItrwR8plbeZjHPjXf8bLUQoyPDOnCUpbfG1tKjRn6l83RKx/zAgN
         XCWs2BSD16aL1xVwbSgnD93BceuxcP4Rfipt0=
Subject: [PATCH] sched: Use proper type for runqueue's idle_at_tick.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 00:01:02 +0600
Message-ID: <1304100062.19359.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Searching over scheduler code for uses of idle_at_tick, tells that its been used for making TRUE/FALSE decision. But, its been declared as 'unsigned char', using 'bool' is more rational here. So, for consistency use 'bool' as idle_at_tick type instead of 'unsigned char'.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 8cb0a57..d9f7f98 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -505,7 +505,7 @@ struct rq {
 
 	unsigned long cpu_power;
 
-	unsigned char idle_at_tick;
+	bool idle_at_tick;
 	/* For active balancing */
 	int post_schedule;
 	int active_balance;


