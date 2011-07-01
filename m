Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab1GAVcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919Ab1GAVbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:31:09 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>,
        Eddie Dong <eddie.dong@intel.com>, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v4 6/9] add jump labels for ia64 paravirt
Date: Fri,  1 Jul 2011 17:22:46 -0400
Message-Id: <1309555369-16867-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1309555369-16867-1-git-send-email-glommer@redhat.com>
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since in a later patch I intend to call jump labels inside
CONFIG_PARAVIRT, IA64 would fail to compile if they are not
provided. This patch provides those jump labels for the IA64
architecture.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Isaku Yamahata <yamahata@valinux.co.jp>
CC: Eddie Dong <eddie.dong@intel.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 arch/ia64/include/asm/paravirt.h |    4 ++++
 arch/ia64/kernel/paravirt.c      |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/paravirt.h b/arch/ia64/include/asm/paravirt.h
index 2eb0a98..32551d3 100644
--- a/arch/ia64/include/asm/paravirt.h
+++ b/arch/ia64/include/asm/paravirt.h
@@ -281,6 +281,10 @@ paravirt_init_missing_ticks_accounting(int cpu)
 		pv_time_ops.init_missing_ticks_accounting(cpu);
 }
 
+struct jump_label_key;
+extern struct jump_label_key paravirt_steal_enabled;
+extern struct jump_label_key paravirt_steal_rq_enabled;
+
 static inline int
 paravirt_do_steal_accounting(unsigned long *new_itm)
 {
diff --git a/arch/ia64/kernel/paravirt.c b/arch/ia64/kernel/paravirt.c
index a21d7bb..1008682 100644
--- a/arch/ia64/kernel/paravirt.c
+++ b/arch/ia64/kernel/paravirt.c
@@ -634,6 +634,8 @@ struct pv_irq_ops pv_irq_ops = {
  * pv_time_ops
  * time operations
  */
+struct jump_label_key paravirt_steal_enabled;
+struct jump_label_key paravirt_steal_rq_enabled;
 
 static int
 ia64_native_do_steal_accounting(unsigned long *new_itm)
-- 
1.7.3.4

