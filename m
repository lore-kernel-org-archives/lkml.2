Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0HZI2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:28:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53035 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0HZI2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:28:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C7625D1.4060201@np.css.fujitsu.com>
Date: Thu, 26 Aug 2010 17:29:05 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: mingo Redhat <mingo@redhat.com>, "Brown, Len" <len.brown@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [Patch-next] therm_throt.c: fix missing { and }.
References: <4C75D3C4.6040802@np.css.fujitsu.com> <20100826060822.GA15021@fenghua-desk.sc.intel.com>
In-Reply-To: <20100826060822.GA15021@fenghua-desk.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the feature PTS is not supported by CPU, the sysfile
package_power_limit_count for package should not be generated.

This patch is used for fixing missing { and }. But I have not confirmed
this patch because I don't have such machine.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index d9368ee..169d880 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -216,7 +216,7 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
 		err = sysfs_add_file_to_group(&sys_dev->kobj,
 					      &attr_core_power_limit_count.attr,
 					      thermal_attr_group.name);
-	if (cpu_has(c, X86_FEATURE_PTS))
+	if (cpu_has(c, X86_FEATURE_PTS)) {
 		err = sysfs_add_file_to_group(&sys_dev->kobj,
 					      &attr_package_throttle_count.attr,
 					      thermal_attr_group.name);
@@ -224,6 +224,7 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
 			err = sysfs_add_file_to_group(&sys_dev->kobj,
 					&attr_package_power_limit_count.attr,
 					thermal_attr_group.name);
+	}
 
 	return err;
 }
-- 
1.7.1.1

