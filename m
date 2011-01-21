Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1AUXce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:32:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18246 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1AUXcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:32:32 -0500
Message-ID: <4D3A16F9.109@kernel.org>
Date: Fri, 21 Jan 2011 15:30:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, perf: Change two init functions to static
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


init_hw_perf_events() is called via early_initcall now.
x86_pmu_event_init is x86_pmu member function.

Could change them to static.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1389,7 +1389,7 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
-int __init init_hw_perf_events(void)
+static int __init init_hw_perf_events(void)
 {
 	struct event_constraint *c;
 	int err;
@@ -1608,7 +1608,7 @@ out:
 	return ret;
 }
 
-int x86_pmu_event_init(struct perf_event *event)
+static int x86_pmu_event_init(struct perf_event *event)
 {
 	struct pmu *tmp;
 	int err;
