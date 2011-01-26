Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1AZLAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:00:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:53241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab1AZLAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:00:30 -0500
Date: Wed, 26 Jan 2011 10:59:59 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, yinghai@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D3A16F9.109@kernel.org>
References: <4D3A16F9.109@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Change two init functions to static
Message-ID: <tip-82d70cab6bce0147aa0aa9583ef9ac58141f4ef4@git.kernel.org>
Git-Commit-ID: 82d70cab6bce0147aa0aa9583ef9ac58141f4ef4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 11:00:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82d70cab6bce0147aa0aa9583ef9ac58141f4ef4
Gitweb:     http://git.kernel.org/tip/82d70cab6bce0147aa0aa9583ef9ac58141f4ef4
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 21 Jan 2011 15:30:01 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 08:46:57 +0100

x86, perf: Change two init functions to static

init_hw_perf_events() is called via early_initcall now.
x86_pmu_event_init is x86_pmu member function.

So we can change them to static.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
LKML-Reference: <4D3A16F9.109@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9d977a2..4d98789 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
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
