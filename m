Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0ESVwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:52:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:41480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0ESVwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:52:01 -0400
Date: Wed, 19 May 2010 21:51:42 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1274295685-6774-2-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-2-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86: detect scattered cpuid features earlier
Message-ID: <tip-1dedefd1a066a795a87afca9c0236e1a94de9bf6@git.kernel.org>
Git-Commit-ID: 1dedefd1a066a795a87afca9c0236e1a94de9bf6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 21:51:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dedefd1a066a795a87afca9c0236e1a94de9bf6
Gitweb:     http://git.kernel.org/tip/1dedefd1a066a795a87afca9c0236e1a94de9bf6
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Wed, 19 May 2010 12:01:23 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 May 2010 13:32:12 -0700

x86: detect scattered cpuid features earlier

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
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c1c00d0..284bf89 100644
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
 
