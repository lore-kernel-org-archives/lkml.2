Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1ABHhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:37:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:36896 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab1ABHZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 214/260] x86: detect scattered cpuid features earlier
Date: Sun,  2 Jan 2011 02:18:30 -0500
Message-Id: <1293952756-15010-215-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:03.0854 (UTC) FILETIME=[0897FAE0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

commit 1dedefd1a066a795a87afca9c0236e1a94de9bf6 upstream.

Some extra CPU features such as ARAT is needed in early boot so
that x86_init function pointers can be set up properly.
http://lkml.org/lkml/2010/5/18/519
At start_kernel() level, this patch moves init_scattered_cpuid_features()
from check_bugs() to setup_arch() -> early_cpu_init() which is earlier than
platform specific x86_init layer setup. Suggested by HPA.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1274295685-6774-2-git-send-email-jacob.jun.pan@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c4329af..497c3b2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -576,6 +576,7 @@ void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
+	init_scattered_cpuid_features(c);
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
@@ -731,7 +732,6 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	init_scattered_cpuid_features(c);
 	detect_nopl(c);
 }
 
-- 
1.7.3.3

