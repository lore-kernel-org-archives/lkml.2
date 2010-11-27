Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab0K0PW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:22:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:37967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0K0PWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:22:54 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/16] x86: Implement cpu_to_logical_apicid() for numaq_32
Date: Sat, 27 Nov 2010 16:22:00 +0100
Message-Id: <1290871325-3055-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290871325-3055-1-git-send-email-tj@kernel.org>
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 15:22:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apic/es7000_32.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index d6199fc..6eb0bd1 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -462,11 +462,8 @@ static unsigned long es7000_check_apicid_present(int bit)
 
 static int es7000_cpu_to_logical_apicid(int cpu)
 {
-	/*
-	 * This is stub implementation which causes static percpu area
-	 * layout to ignore NUMA affinity.
-	 */
-	return BAD_APICID;
+	/* on bigsmp, logical apicid is the same as physical */
+	return early_per_cpu(x86_bios_cpu_apicid, cpu);
 }
 
 static unsigned long calculate_ldr(int cpu)
-- 
1.7.1

