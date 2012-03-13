Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab2CMXWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:22:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43974 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2CMXWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:22:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        JBeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/cpufreq: Disable the cpu frequency scaling drivers from loading.
Date: Tue, 13 Mar 2012 19:18:40 -0400
Message-Id: <1331680720-18268-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
References: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020201.4F5FD6C2.00B7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using the functionality provided by "[CPUFREQ]: provide
disable_cpuidle() function to disable the API."

Under the Xen hypervisor we do not want the initial domain to exercise
the cpufreq scaling drivers. This is b/c the Xen hypervisor is
in charge of doing this as well and we can end up with both the
Linux kernel and the hypervisor trying to change the P-states
leading to weird performance issues.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index e03c636..4461e0a 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -420,6 +420,7 @@ void __init xen_arch_setup(void)
 	boot_cpu_data.hlt_works_ok = 1;
 #endif
 	disable_cpuidle();
+	disable_cpufreq();
 	boot_option_idle_override = IDLE_HALT;
 	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
-- 
1.7.9.48.g85da4d

