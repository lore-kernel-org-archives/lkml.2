Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0E0Cm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:42:57 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:60658 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab0E0Cmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:42:52 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 2/8] cpuidle: add cpuidle_unregister_driver() error check
Date: Wed, 26 May 2010 22:42:25 -0400
Message-id: <56b9c89c17c1a85886f6d1928349e35bbb48c856.1274926772.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1274928151-30919-1-git-send-email-lenb@kernel.org>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
In-reply-to: <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
References: <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

When cpuidle_unregister_driver() is called with a driver
other than the one that was successfully registered, do nothing.

Previously we'd NULL-out the one that was registered.
But that required the callers to remember what this
routine already remembers.  With this check, the callers
can be simplified.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/driver.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 2257004..30bcd44 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -49,7 +49,8 @@ void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 		return;
 
 	spin_lock(&cpuidle_driver_lock);
-	cpuidle_curr_driver = NULL;
+	if (drv == cpuidle_curr_driver)
+		cpuidle_curr_driver = NULL;
 	spin_unlock(&cpuidle_driver_lock);
 }
 
-- 
1.6.0.6

