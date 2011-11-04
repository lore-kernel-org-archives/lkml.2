Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab1KDLP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:15:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44682 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1KDLP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:15:57 -0400
From: Borislav Petkov <bp@amd64.org>
To: linux-stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] x86: Add a BSP cpu_dev helper
Date: Fri,  4 Nov 2011 12:15:52 +0100
Message-Id: <1320405354-9850-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1320405354-9850-1-git-send-email-bp@amd64.org>
References: <20111104111115.GA8020@aftab>
 <1320405354-9850-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit: a110b5ec7371592eac856ac5c22dc7b518952d44

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
-- 
1.7.8.rc0

