Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0IQB52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:57:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61597 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0IQB5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:57:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=wtgcwfTDHz4BpcT3OzUHd6ZJZDFa377gkFJ5seYC1Y8Px5KOeLfjwWgHBhq1z1twG
	SkyDZX6C7Ml855/0afVWw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 3/6] x86: Add IRQ_TIME_ACCOUNTING in x86
Date: Thu, 16 Sep 2010 18:56:33 -0700
Message-Id: <1284688596-6731-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284688596-6731-1-git-send-email-venki@google.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds IRQ_TIME_ACCOUNTING option on x86 and runtime enables it
when TSC is enabled.

This change just enables fine grained irq time accounting, isn't used yet.
Following patches use it for different purposes.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/Kconfig      |   11 +++++++++++
 arch/x86/kernel/tsc.c |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..f4c70c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -795,6 +795,17 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	default n
+	---help---
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 26a863a..110d815 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -987,6 +987,8 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	enable_sched_clock_irqtime();
+
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
-- 
1.7.1

