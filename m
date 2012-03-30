Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab2C3KTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:19:33 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52238 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693Ab2C3KSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:45 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 59/76] cpuidle: power_usage should be declared signed integer
Date: Fri, 30 Mar 2012 06:14:02 -0400
Message-id: <02401c06b7f6bec65f314e3cec7894502c973501.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

power_usage is always assigned a negative value and should be declared
a signed integer

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/governors/menu.c |    2 +-
 include/linux/cpuidle.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 5c17ca1..0633575 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -236,7 +236,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
-	unsigned int power_usage = -1;
+	int power_usage = -1;
 	int i;
 	int multiplier;
 	struct timespec t;
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index d557bcd..6c26a3d 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -44,7 +44,7 @@ struct cpuidle_state {
 
 	unsigned int	flags;
 	unsigned int	exit_latency; /* in US */
-	unsigned int	power_usage; /* in mW */
+	int		power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
 	unsigned int    disable;
 
-- 
1.7.10.rc2.19.gfae9d

