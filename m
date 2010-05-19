Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0ESTJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:09:18 -0400
Received: from mga06.intel.com ([134.134.136.21]:15519 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753979Ab0ESTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:08:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,265,1272870000"; 
   d="scan'208";a="519453406"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Alan Cox <alan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 1/3] x86: detect scattered cpuid features earlier
Date: Wed, 19 May 2010 12:01:23 -0700
Message-Id: <1274295685-6774-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274295685-6774-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some extra CPU features such as ARAT is needed in early boot so
that x86_init function pointers can be set up properly.
http://lkml.org/lkml/2010/5/18/519
At start_kernel() level, this patch moves init_scattered_cpuid_features()
from check_bugs() to setup_arch() -> early_cpu_init() which is earlier than
platform specific x86_init layer setup. Suggested by HPA.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..fe1e5d6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -576,6 +576,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
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
1.6.3.3

