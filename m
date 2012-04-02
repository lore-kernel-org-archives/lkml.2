Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2DBOoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:44:44 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52369 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2DBOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:44:42 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] cpuidle: Avoid possible NULL pointer dereference in
 __cpuidle_register_device()
To: lenb@kernel.org
Cc: khilman@ti.com, deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com,
        arjan@infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        daniel.lezcano@linaro.org, amit.kucheria@linaro.org
Date: Mon, 02 Apr 2012 20:14:22 +0530
Message-ID: <20120402144422.11574.83174.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12040214-5564-0000-0000-0000020FAD57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __cpuidle_register_device(), "dev->cpu" is used before checking if dev is
non-NULL. Fix it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpuidle/cpuidle.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 87411ce..75b381e 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -372,7 +372,7 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
 	int ret;
-	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
+	struct device *cpu_dev;
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	if (!dev)
@@ -380,6 +380,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
 
+	cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	init_completion(&dev->kobj_unregister);
 
 	per_cpu(cpuidle_devices, dev->cpu) = dev;

