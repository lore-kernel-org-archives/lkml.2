Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0E0FLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:11:09 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:53076 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab0E0FLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:11:07 -0400
Date: Thu, 27 May 2010 01:11:03 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH-v2 2/8] cpuidle: add cpuidle_unregister_driver() error check
In-reply-to: <20100526201437.51f5c7f7.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.1005270107360.4039@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <56b9c89c17c1a85886f6d1928349e35bbb48c856.1274926772.git.len.brown@intel.com>
 <20100526201437.51f5c7f7.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

BUG_ON() cpuidle_unregister_driver() being called with
a driver not matching the onee that successfully registered.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/driver.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 2257004..5b6fd0f 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -45,8 +45,7 @@ EXPORT_SYMBOL_GPL(cpuidle_register_driver);
  */
 void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 {
-	if (!drv)
-		return;
+	BUG_ON(drv != cpuidle_curr_driver)
 
 	spin_lock(&cpuidle_driver_lock);
 	cpuidle_curr_driver = NULL;
-- 
1.6.0.6

