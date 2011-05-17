Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1EQRD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:03:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529Ab1EQRD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:03:57 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
        cpufreq@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/5] cpufreq: Add compatibility hack to powernow-k8
Date: Tue, 17 May 2011 13:03:38 -0400
Message-Id: <1305651819-25660-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1305651819-25660-1-git-send-email-mjg@redhat.com>
References: <1305651819-25660-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq modules are often loaded from init scripts that assume that all
recent AMD systems will use powernow-k8, so we should ensure that loading
it triggers a load of acpi-cpufreq if the latter is built as a module.
This avoids the problem of users ending up without any cpufreq support
after the transition.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 2368e38..619733e 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1538,6 +1538,8 @@ static int __cpuinit powernowk8_init(void)
 	unsigned int i, supported_cpus = 0, cpu;
 	int rv;
 
+	request_module("acpi_cpufreq");
+
 	for_each_online_cpu(i) {
 		int rc;
 		smp_call_function_single(i, check_supported_cpu, &rc, 1);
-- 
1.7.5

