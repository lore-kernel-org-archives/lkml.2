Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375Ab2FECeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 22:34:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:9081 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761354Ab2FECdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 22:33:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161028494"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, tglx@linutronix.de
Cc: bp@amd64.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH] fix the MCE poll timer logic
Date: Tue,  5 Jun 2012 10:35:02 +0800
Message-Id: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 82f7af09 (x86/mce: Cleanup timer mess), Thomas just forgot
the "/ 2" there while cleaning up.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0a687fd..a97f3c4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1274,7 +1274,7 @@ static void mce_timer_fn(unsigned long data)
 	 */
 	iv = __this_cpu_read(mce_next_interval);
 	if (mce_notify_irq())
-		iv = max(iv, (unsigned long) HZ/100);
+		iv = max(iv / 2, (unsigned long) HZ/100);
 	else
 		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
 	__this_cpu_write(mce_next_interval, iv);
-- 
1.7.10

