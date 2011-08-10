Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1HJBfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:35:02 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:42755 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab1HJBey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:34:54 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>
Subject: [PATCH 2/2] cpu: update cpu_hotpluggable_mask in register_cpu
Date: Tue,  9 Aug 2011 18:33:27 -0700
Message-Id: <1312940007-26069-3-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312940007-26069-1-git-send-email-mturquette@ti.com>
References: <1312940007-26069-1-git-send-email-mturquette@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the cpu_hotpluggable_mask for each registered CPU which supports
hotplug.  This makes it trivial for kernel code to know which CPUs
support hotplug operations.

Signed-off-by: Mike Turquette <mturquette@ti.com>
---
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

