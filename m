Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2ANUKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:10:49 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:43961 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2ANUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:10:48 -0500
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] cpuidle: fix an incorrect NULL pointer check
Date: Sat, 14 Jan 2012 07:42:47 +0900
Message-Id: <1326494567-579-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

"cpu_dev" should be checked instead of "dev".

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/cpuidle/cpuidle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..7771810 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -294,7 +294,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (!dev)
+	if (!cpu_dev)
 		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
-- 
1.7.1

