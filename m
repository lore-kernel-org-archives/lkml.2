Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2CMS4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:56:39 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:56994
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159Ab2CMS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:56:14 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0U79F-02-2HV-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <x86@kernel.org>, <len.brown@intel.com>, <linux-acpi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH 2/2] cpuidle: power_usage should be declared signed integer
Date: Tue, 13 Mar 2012 19:55:10 +0100
Message-ID: <1331664910-20095-3-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331664910-20095-1-git-send-email-boris.ostrovsky@amd.com>
References: <1331664910-20095-1-git-send-email-boris.ostrovsky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power_usage is always assigned a negative value and should be declared
a signed integer

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 drivers/cpuidle/governors/menu.c |    2 +-
 include/linux/cpuidle.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index ad09526..9ae658b 100644
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
index 2662493..1ae4461 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -43,7 +43,7 @@ struct cpuidle_state {
 
 	unsigned int	flags;
 	unsigned int	exit_latency; /* in US */
-	unsigned int	power_usage; /* in mW */
+	int		power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
 
 	int (*enter)	(struct cpuidle_device *dev,
-- 
1.7.7


