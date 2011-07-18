Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1GRQjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1GRQiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:38:23 -0400
From: Matthew Garrett <mjg@redhat.com>
To: cpufreq@vger.kernel.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        mark.langsdorf@amd.com, andreas.herrmann3@amd.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH v4 7/7] cpufreq: Add boost alias to cpb
Date: Mon, 18 Jul 2011 12:37:42 -0400
Message-Id: <1311007062-2050-8-git-send-email-mjg@redhat.com>
In-Reply-To: <1311007062-2050-1-git-send-email-mjg@redhat.com>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpb is AMD's name for the dynamic overclocking present in their chips.
Intel provide similar functionality, so add "boost" as an alias. In the
long run we can then transition to using that rather than cpb.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/cpu-freq/user-guide.txt |    5 +++++
 drivers/cpufreq/acpi-cpufreq.c        |    8 +++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/cpu-freq/user-guide.txt b/Documentation/cpu-freq/user-guide.txt
index 04f6b32..a692d3f 100644
--- a/Documentation/cpu-freq/user-guide.txt
+++ b/Documentation/cpu-freq/user-guide.txt
@@ -214,6 +214,11 @@ bios_limit :			If the BIOS tells the OS to limit a CPU to
 				which can be detected through the generic
 				thermal driver.
 
+boost:				Some CPUs support clocking themselves to above
+				their rated frequency depending on temperature
+				and power constraints. This file allows this
+				to be enabled or disabled.
+
 If you have selected the "userspace" governor which allows you to
 set the CPU operating frequency to a specific value, you can read out
 the current frequency in
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 0a92277..30c66cc 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -172,11 +172,8 @@ static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
 	return sprintf(buf, "%u\n", cpb_state(cpu));
 }
 
-#define define_one_rw(_name) \
-static struct freq_attr _name = \
-	__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(cpb);
+static struct freq_attr cpb = __ATTR(cpb, 0644, show_cpb, store_cpb);
+static struct freq_attr boost = __ATTR(boost, 0644, show_cpb, store_cpb);
 
 static int check_est_cpu(unsigned int cpuid)
 {
@@ -933,6 +930,7 @@ static int acpi_cpufreq_resume(struct cpufreq_policy *policy)
 static struct freq_attr *acpi_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
 	&cpb,
+	&boost,
 	NULL,
 };
 
-- 
1.7.6

