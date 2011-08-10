Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1HJUGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:06:04 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:33095 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754891Ab1HJUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:05:57 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, gregkh@suse.de, Mike Turquette <mturquette@ti.com>
Subject: [PATCH v2 2/2] cpu: update cpu_hotpluggable_mask in register_cpu
Date: Wed, 10 Aug 2011 13:03:34 -0700
Message-Id: <1313006614-28702-3-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313006614-28702-1-git-send-email-mturquette@ti.com>
References: <1313006614-28702-1-git-send-email-mturquette@ti.com>
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

