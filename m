Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0CXRqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:46:42 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58680 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab0CXRp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:45:57 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com, trenn@suse.de,
       linux@dominikbrodowski.net
Cc: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>,
       cpufreq@vger.kernel.org, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] powernow-k8: Fix frequency reporting
Date: Wed, 24 Mar 2010 18:46:22 +0100
Message-Id: <1269452783-966-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269452783-966-1-git-send-email-bp@amd64.org>
References: <1269452783-966-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@amd.com>

With F10, model 10, all valid frequencies are in the ACPI _PST table.

Cc: <stable@kernel.org> # 33.x 32.x
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 1dd292c..317db7b 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -935,7 +935,8 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data,
 		powernow_table[i].index = index;
 
 		/* Frequency may be rounded for these */
-		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+				 || boot_cpu_data.x86 == 0x11) {
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
-- 
1.7.0

