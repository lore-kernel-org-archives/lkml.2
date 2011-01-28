Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1A1OlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:41:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:60054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab1A1OlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:41:22 -0500
Date: Fri, 28 Jan 2011 14:40:56 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-12-git-send-email-tj@kernel.org>
References: <1295789862-25482-12-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Implement x86_32_early_logical_apicid() for numaq_32
Message-ID: <tip-df04cf011b0657ddc782b48d455f7e232b9be41c@git.kernel.org>
Git-Commit-ID: df04cf011b0657ddc782b48d455f7e232b9be41c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:40:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df04cf011b0657ddc782b48d455f7e232b9be41c
Gitweb:     http://git.kernel.org/tip/df04cf011b0657ddc782b48d455f7e232b9be41c
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:08 +0100

x86: Implement x86_32_early_logical_apicid() for numaq_32

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-12-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
