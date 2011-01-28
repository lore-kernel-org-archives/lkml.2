Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1A1Ok1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:40:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:60017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1A1OkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:40:25 -0500
Date: Fri, 28 Jan 2011 14:40:13 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-10-git-send-email-tj@kernel.org>
References: <1295789862-25482-10-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Implement x86_32_early_logical_apicid() for bigsmp_32
Message-ID: <tip-12bf24a47c1a095233cc8a8b863b509a0d8e0f2c@git.kernel.org>
Git-Commit-ID: 12bf24a47c1a095233cc8a8b863b509a0d8e0f2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:40:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12bf24a47c1a095233cc8a8b863b509a0d8e0f2c
Gitweb:     http://git.kernel.org/tip/12bf24a47c1a095233cc8a8b863b509a0d8e0f2c
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:07 +0100

x86: Implement x86_32_early_logical_apicid() for bigsmp_32

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-10-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/bigsmp_32.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index dd32a9b..bc7ed04 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -45,6 +45,12 @@ static unsigned long bigsmp_check_apicid_present(int bit)
 	return 1;
 }
 
+static int bigsmp_early_logical_apicid(int cpu)
+{
+	/* on bigsmp, logical apicid is the same as physical */
+	return early_per_cpu(x86_cpu_to_apicid, cpu);
+}
+
 static inline unsigned long calculate_ldr(int cpu)
 {
 	unsigned long val, id;
@@ -252,5 +258,5 @@ struct apic apic_bigsmp = {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
-	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
