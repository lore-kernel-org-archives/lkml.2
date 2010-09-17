Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0IQWz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:55:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:39387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0IQWzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:55:25 -0400
Date: Fri, 17 Sep 2010 22:55:01 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100917160744.GF4958@loge.amd.com>
References: <20100917160744.GF4958@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, cacheinfo: Fix dependency of AMD L3 CID
Message-ID: <tip-3518dd14ca888085797ca8d3a9e11c8ef9e7ae68@git.kernel.org>
Git-Commit-ID: 3518dd14ca888085797ca8d3a9e11c8ef9e7ae68
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 22:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3518dd14ca888085797ca8d3a9e11c8ef9e7ae68
Gitweb:     http://git.kernel.org/tip/3518dd14ca888085797ca8d3a9e11c8ef9e7ae68
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 17 Sep 2010 18:07:45 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Sep 2010 13:25:56 -0700

x86, cacheinfo: Fix dependency of AMD L3 CID

L3 cache index disable code uses PCI accesses to AMD northbridge functions.
Currently the code is #ifdef CONFIG_CPU_SUP_AMD.
But it should be #if (defined(CONFIG_CPU_SUP_AMD) && defined(CONFIG_PCI))
which in the end is a dependency to K8_NB.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100917160744.GF4958@loge.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
