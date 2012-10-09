Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2JIGEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:04:04 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49201 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2JIGD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:56 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 28/30] cpuidle / ACPI: fix potential NULL pointer dereference
Date: Tue,  9 Oct 2012 01:54:18 -0400
Message-Id: <e8b1b59dc8e42a47c4ce541bd1767ffac206b29c.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 3655ab9..e8086c7 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1132,7 +1132,7 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
 int acpi_processor_hotplug(struct acpi_processor *pr)
 {
 	int ret = 0;
-	struct cpuidle_device *dev = per_cpu(acpi_cpuidle_device, pr->id);
+	struct cpuidle_device *dev;
 
 	if (disabled_by_idle_boot_param())
 		return 0;
@@ -1147,6 +1147,7 @@ int acpi_processor_hotplug(struct acpi_processor *pr)
 	if (!pr->flags.power_setup_done)
 		return -ENODEV;
 
+	dev = per_cpu(acpi_cpuidle_device, pr->id);
 	cpuidle_pause_and_lock();
 	cpuidle_disable_device(dev);
 	acpi_processor_get_power_info(pr);
-- 
1.8.0.rc1

