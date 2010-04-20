Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0DTLRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 07:17:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:43456 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0DTLRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 07:17:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: davej@redhat.com
Cc: Thomas Renninger <trenn@suse.de>, venki@google.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] acpi-cpufreq: Fix CPU_ANY CPUFREQ_{PRE,POST}CHANGE notification
Date: Tue, 20 Apr 2010 13:17:35 +0200
Message-Id: <1271762256-1799-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: venki@google.com
CC: davej@redhat.com
CC: arjan@infradead.org
CC: davej@redhat.com
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4591680..c6de3a9 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -391,7 +391,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu(i, cmd.mask) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -407,7 +407,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	for_each_cpu(i, cmd.mask) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
-- 
1.6.3

