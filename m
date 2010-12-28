Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0L1Lu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:50:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55346 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0L1LtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:49:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=p321GR1JxTsn/u7fttLSfEzdfoYTJ6P8EetTPhuflA0W7T94U/bH3i85pxmVC+p9Dq
         9ouSFqu864D4CCP7jg0lKuMoGeW6bptJcQKVdyLim8x3p4Ya90ZY2kRYbl0lNKD5aGRX
         MW3iKAXrFIg8Fbbn9mXIkhdFKI5JAVYktWz10=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/16] x86: Implement x86_32_early_logical_apicid() for bigsmp_32
Date: Tue, 28 Dec 2010 12:48:42 +0100
Message-Id: <1293536929-31683-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293536929-31683-1-git-send-email-tj@kernel.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
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
-- 
1.7.1

