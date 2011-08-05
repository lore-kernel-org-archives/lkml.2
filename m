Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1HESBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:01:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35589 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1HESBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:01:20 -0400
Date: Fri, 5 Aug 2011 20:01:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3.2 2/3] x86: Add a BSP cpu_dev helper
Message-ID: <20110805180116.GB26217@aftab>
References: <1312550110-24160-1-git-send-email-bp@amd64.org>
 <4E3C2405.8090309@zytor.com>
 <20110805175522.GA26217@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805175522.GA26217@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function ptr to struct cpu_dev which is destined to be run only
once on the BSP during boot.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
1.7.4.rc2
