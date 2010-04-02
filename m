Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0DBTHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:07:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:47738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0DBTHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:07:23 -0400
Date: Fri, 2 Apr 2010 19:06:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1269353485.5109.48.camel@twins>
References: <1269353485.5109.48.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Move notify_cpu_starting() callback to a later stage
Message-ID: <tip-85257024096a96fc5c00ce59d685f62bbed3ad95@git.kernel.org>
Git-Commit-ID: 85257024096a96fc5c00ce59d685f62bbed3ad95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:06:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85257024096a96fc5c00ce59d685f62bbed3ad95
Gitweb:     http://git.kernel.org/tip/85257024096a96fc5c00ce59d685f62bbed3ad95
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 23 Mar 2010 19:30:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:30:01 +0200

x86: Move notify_cpu_starting() callback to a later stage

Because we need to have cpu identification things done by the time we run
CPU_STARTING notifiers.

( This init ordering will be relied on by the next fix. )

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1269353485.5109.48.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 06d98ae..6808b93 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -242,8 +242,6 @@ static void __cpuinit smp_callin(void)
 	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
-	notify_cpu_starting(cpuid);
-
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
@@ -264,6 +262,8 @@ static void __cpuinit smp_callin(void)
 	 */
 	smp_store_cpu_info(cpuid);
 
+	notify_cpu_starting(cpuid);
+
 	/*
 	 * Allow the master to continue.
 	 */
