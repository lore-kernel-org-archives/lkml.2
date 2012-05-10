Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2EJOau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:30:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56032 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2EJOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:45 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/9] x86, MCE, AMD: Remove local_allocate_... wrapper
Date: Thu, 10 May 2012 16:30:23 +0200
Message-Id: <1336660229-32644-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

It is unneeded now so drop it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 2a5dd30f9969..7fd02cac962b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -61,6 +61,7 @@ struct threshold_bank {
 	struct kobject		*kobj;
 	struct threshold_block	*blocks;
 };
+
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
 static unsigned char shared_bank[NR_BANKS] = {
@@ -545,13 +546,6 @@ out_free:
 	return err;
 }
 
-static __cpuinit long
-local_allocate_threshold_blocks(int cpu, unsigned int bank)
-{
-	return allocate_threshold_blocks(cpu, bank, 0,
-					 MSR_IA32_MC0_MISC + bank * 4);
-}
-
 static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	struct device *dev = per_cpu(mce_device, cpu);
@@ -575,7 +569,8 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	err = local_allocate_threshold_blocks(cpu, bank);
+	err = allocate_threshold_blocks(cpu, bank, 0,
+					MSR_IA32_MC0_MISC + bank * 4);
 	if (!err)
 		goto out;
 
-- 
1.7.9.3.362.g71319

