Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2JaAb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:31:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2JaAbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:31:23 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9Sh0tkKHrLsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NDWzv-LtIjcA:10 a=VwQbUJbxAAAA:8 a=ikMIzOjJKqLRoHuP5kEA:9 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121031003122.969515377@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Oct 2012 20:31:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 2/4] rcu: Disable RCU_FAST_NO_HZ on RT
References: <20121031003107.834398757@goodmis.org>
Content-Disposition: inline; filename=0002-rcu-Disable-RCU_FAST_NO_HZ-on-RT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This uses a timer_list timer from the irq disabled guts of the idle
code. Disable it for now to prevent wreckage.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
---
 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 720c182..aa6545f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -469,7 +469,7 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on TREE_RCU && NO_HZ && SMP
+	depends on TREE_RCU && NO_HZ && SMP && !PREEMPT_RT_FULL
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods
-- 
1.7.10.4


