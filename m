Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0IQPla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:41:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59780 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab0IQPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c3bbzQE9+qJD9fde9ZqDnx0oHT2yk4PA4+EHbq7rJH8s9XuSseTdoi3OkVgnVoNNek
         XsjxtAWW3vJSccISGnuIoax8r4E7sW2wcRU50MWjccnvKPuFihitpGQT48efPlR4DTh/
         t5Vlpis9LKM52QpF30wxOmaQhuX/Vns/YjPNs=
Date: Fri, 17 Sep 2010 18:07:45 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 1/3] x86, cacheinfo: Fix dependency of AMD L3 CID
Message-ID: <20100917160744.GF4958@loge.amd.com>
References: <20100917155904.GA4958@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917155904.GA4958@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

L3 cache index disable code uses PCI accesses to AMD northbridge functions.
Currently the code is #ifdef CONFIG_CPU_SUP_AMD.
But it should be #if (defined(CONFIG_CPU_SUP_AMD) && defined(CONFIG_PCI))
which in the end is a dependency to K8_NB.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 898c2f4..2521cdc 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -306,7 +306,7 @@ struct _cache_attr {
 	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
 };
 
-#ifdef CONFIG_CPU_SUP_AMD
+#ifdef CONFIG_K8_NB
 
 /*
  * L3 cache descriptors
@@ -556,12 +556,12 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
-#else	/* CONFIG_CPU_SUP_AMD */
+#else	/* CONFIG_K8_NB */
 static void __cpuinit
 amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
 {
 };
-#endif /* CONFIG_CPU_SUP_AMD */
+#endif /* CONFIG_K8_NB */
 
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
@@ -1000,7 +1000,7 @@ static struct attribute *default_attrs[] = {
 
 static struct attribute *default_l3_attrs[] = {
 	DEFAULT_SYSFS_CACHE_ATTRS,
-#ifdef CONFIG_CPU_SUP_AMD
+#ifdef CONFIG_K8_NB
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
 #endif
-- 
1.6.4.4

