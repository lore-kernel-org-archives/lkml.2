Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1KPHu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:50:56 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47746 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1KPHuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:50:55 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] lockdep: Don't disable lockdep for out of tree modules
Date: Wed, 16 Nov 2011 13:20:35 +0530
Message-Id: <1321429835-1466-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 11111521-5490-0000-0000-0000001F276F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

I guess it would be nice to get lockdep enabled for out of tree GPL modules

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 kernel/panic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b2659360..3bd7088 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -240,7 +240,8 @@ void add_taint(unsigned flag)
 	 * Also we want to keep up lockdep for staging development and
 	 * post-warning case.
 	 */
-	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
+	if (flag != TAINT_CRAP && flag != TAINT_WARN &&
+	    flag != TAINT_OOT_MODULE && __debug_locks_off())
 		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
-- 
1.7.5.4

