Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1F1Ct7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:49:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab1F1Csj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:48:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=hByi7PAD4mUW5tb1C1zSIRXEiJJgzpwlHpHle1jghawUX1RUyMb/JJI6l0Or0jSNJ
	2gxe5pVBF1C5RSITgz72w==
From: Todd Poynor <toddpoynor@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 2/3] ARM: Call idle notifiers
Date: Mon, 27 Jun 2011 19:46:29 -0700
Message-Id: <1309229190-25006-3-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: Id833e61c13baa1783705ac9e9046d1f0cc90c95e
Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 arch/arm/kernel/process.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 5e1e541..1b9101e 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -184,6 +184,7 @@ void cpu_idle(void)
 	while (1) {
 		tick_nohz_stop_sched_tick(1);
 		leds_event(led_idle_start);
+		idle_notifier_call_chain(IDLE_START);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
 			if (cpu_is_offline(smp_processor_id()))
@@ -208,6 +209,7 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
+		idle_notifier_call_chain(IDLE_END);
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
-- 
1.7.3.1

