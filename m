Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0L1Luu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:50:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab0L1LtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:49:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qVG7HX+ErBmbkvXTgHVQMjnxXmNetc0AJs1sUVLsOHJqIGV3yiTGEOn3bRyvqYxh5i
         eqwTuguTG9SW1xyTCmfSuRGmwbvjTalV3pi8e40KR2zpk/jSdTqYnMkfNWQxS6TGK1gj
         E/Mt7aA+KNBRNtkPJ4NTSoCvAUr+giFu5iGVs=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/16] x86: Implement x86_32_early_logical_apicid() for numaq_32
Date: Tue, 28 Dec 2010 12:48:44 +0100
Message-Id: <1293536929-31683-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293536929-31683-1-git-send-email-tj@kernel.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apic/es7000_32.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 0ffc1ec..5c53d05 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -460,6 +460,12 @@ static unsigned long es7000_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
+static int es7000_early_logical_apicid(int cpu)
+{
+	/* on es7000, logical apicid is the same as physical */
+	return early_per_cpu(x86_bios_cpu_apicid, cpu);
+}
+
 static unsigned long calculate_ldr(int cpu)
 {
 	unsigned long id = per_cpu(x86_bios_cpu_apicid, cpu);
@@ -683,7 +689,7 @@ struct apic __refdata apic_es7000_cluster = {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
-	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
 
 struct apic __refdata apic_es7000 = {
@@ -747,5 +753,5 @@ struct apic __refdata apic_es7000 = {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
-	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
-- 
1.7.1

