Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab1HEW7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:59:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:56389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1HEW7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:59:21 -0400
Date: Fri, 5 Aug 2011 22:58:58 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Message-ID: <tip-a110b5ec7371592eac856ac5c22dc7b518952d44@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@amd64.org,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@amd64.org, hpa@linux.intel.com,
        borislav.petkov@amd.com
In-Reply-To: <20110805180116.GB26217@aftab>
References: <20110805180116.GB26217@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Add a BSP cpu_dev helper
Git-Commit-ID: a110b5ec7371592eac856ac5c22dc7b518952d44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 22:58:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a110b5ec7371592eac856ac5c22dc7b518952d44
Gitweb:     http://git.kernel.org/tip/a110b5ec7371592eac856ac5c22dc7b518952d44
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Fri, 5 Aug 2011 20:01:16 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 5 Aug 2011 12:26:49 -0700

x86: Add a BSP cpu_dev helper

Add a function ptr to struct cpu_dev which is destined to be run only
once on the BSP during boot.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/20110805180116.GB26217@aftab
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |    3 +++
 arch/x86/kernel/cpu/cpu.h    |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..8ed394a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -681,6 +681,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
+
+	if (this_cpu->c_bsp_init)
+		this_cpu->c_bsp_init(c);
 }
 
 void __init early_cpu_init(void)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index e765633..1b22dcc 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -18,6 +18,7 @@ struct cpu_dev {
 	struct		cpu_model_info c_models[4];
 
 	void            (*c_early_init)(struct cpuinfo_x86 *);
+	void		(*c_bsp_init)(struct cpuinfo_x86 *);
 	void		(*c_init)(struct cpuinfo_x86 *);
 	void		(*c_identify)(struct cpuinfo_x86 *);
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
