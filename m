Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0JHK4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:56:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:53169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0JHK4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:56:07 -0400
Date: Fri, 8 Oct 2010 10:54:27 GMT
From: tip-bot for Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lm-sensors@lm-sensors.org, jin.dongming@np.css.fujitsu.com,
        seto.hidetoshi@jp.fujitsu.com, khali@linux-fr.org, tglx@linutronix.de,
        fenghua.yu@initel.com, guenter.roeck@ericsson.com, mingo@elte.hu,
        len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jin.dongming@np.css.fujitsu.com, lm-sensors@lm-sensors.org,
        seto.hidetoshi@jp.fujitsu.com, khali@linux-fr.org, tglx@linutronix.de,
        fenghua.yu@initel.com, guenter.roeck@ericsson.com, len.brown@intel.com,
        mingo@elte.hu
In-Reply-To: <4C7625D1.4060201@np.css.fujitsu.com>
References: <4C7625D1.4060201@np.css.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mce, therm_throt.c: Fix missing curly braces in error handling logic
Message-ID: <tip-b62be8ea9db4048112219ff6d6ce5f183179d4dc@git.kernel.org>
Git-Commit-ID: b62be8ea9db4048112219ff6d6ce5f183179d4dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Oct 2010 10:54:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b62be8ea9db4048112219ff6d6ce5f183179d4dc
Gitweb:     http://git.kernel.org/tip/b62be8ea9db4048112219ff6d6ce5f183179d4dc
Author:     Jin Dongming <jin.dongming@np.css.fujitsu.com>
AuthorDate: Thu, 26 Aug 2010 17:29:05 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 Oct 2010 10:29:20 +0200

x86, mce, therm_throt.c: Fix missing curly braces in error handling logic

When the feature PTS is not supported by CPU, the sysfile
package_power_limit_count for package should not be
generated.

This patch is used for fixing missing { and }.

The patch is not complete as there are other error handling
problems in this function - but that can wait until the
merge window.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Fenghua Yu <fenghua.yu@initel.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Brown Len <len.brown@intel.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: lm-sensors@lm-sensors.org <lm-sensors@lm-sensors.org>
LKML-Reference: <4C7625D1.4060201@np.css.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
