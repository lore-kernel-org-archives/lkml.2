Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2HBOsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:48:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22816 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2HBOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:48:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.
Date: Thu,  2 Aug 2012 10:39:01 -0400
Message-Id: <1343918341-25985-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the machine is booted without any cpu_idle driver set
(b/c disable_cpuidle() has been called) we should follow
other users of cpu_idle API and check the return value
for NULL before using it.

Reported-by: Mark van Dijk <mark@internecto.net>
Tested-by: Mark van Dijk <mark@internecto.net>
Suggested-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f559088..7383aa0 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -607,7 +607,7 @@ static int __init intel_idle_init(void)
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
-			cpuidle_get_driver()->name);
+			cpuidle_get_driver() ? cpuidle_get_driver()->name : "none");
 		return retval;
 	}
 
-- 
1.7.7.6

