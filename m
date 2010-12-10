Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0LJHRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:17:00 -0500
Received: from mail.perches.com ([173.55.12.10]:2485 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0LJHQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:16:58 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 1/2] ia64: Remove unlikely from cpu_is_offline
Date: Thu,  9 Dec 2010 23:16:55 -0800
Message-Id: <c9efab4f338b1c630072c4b8aa5715dfdbb13533.1291965374.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_is_offline already uses unlikely internally.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index ed6f22e..9702fa9 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -168,7 +168,7 @@ timer_interrupt (int irq, void *dev_id)
 {
 	unsigned long new_itm;
 
-	if (unlikely(cpu_is_offline(smp_processor_id()))) {
+	if (cpu_is_offline(smp_processor_id())) {
 		return IRQ_HANDLED;
 	}
 
-- 
1.7.3.3.398.g0b0cd.dirty

