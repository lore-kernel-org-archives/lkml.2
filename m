Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1HKUBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:01:42 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:46338 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab1HKUBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:01:41 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, gregkh@suse.de, peterz@infradead.org,
        amit.kucheria@linaro.org, Mike Turquette <mturquette@ti.com>
Subject: [PATCH v3 2/2] cpu: update cpu_hotpluggable_mask in register_cpu
Date: Thu, 11 Aug 2011 12:54:47 -0700
Message-Id: <1313092487-15858-2-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313092487-15858-1-git-send-email-mturquette@ti.com>
References: <1313006614-28702-1-git-send-email-mturquette@ti.com>
 <1313092487-15858-1-git-send-email-mturquette@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the cpu_hotpluggable_mask for each registered CPU which supports
hotplug.  This makes it trivial for kernel code to know which CPUs
support hotplug operations.

Signed-off-by: Mike Turquette <mturquette@ti.com>
---
Change log:
v2: no change
v3: no change

 drivers/base/cpu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..91ddcf8 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -224,8 +224,10 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 
 	error = sysdev_register(&cpu->sysdev);
 
-	if (!error && cpu->hotpluggable)
+	if (!error && cpu->hotpluggable) {
 		register_cpu_control(cpu);
+		set_cpu_hotpluggable(num, true);
+	}
 	if (!error)
 		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
 	if (!error)
-- 
1.7.4.1

