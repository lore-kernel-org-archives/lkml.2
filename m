Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0FBHpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:45:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51315 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab0FBHpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:45:19 -0400
Date: Wed, 2 Jun 2010 07:43:47 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, tglx@linutronix.de, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com, tglx@linutronix.de, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <20100601190455.GA14237@aftab>
References: <20100601190455.GA14237@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, smpboot: Fix cores per node printing on boot
Message-ID: <tip-4adc8b71cc142f9a7b44b13b99aab38ba897c56f@git.kernel.org>
Git-Commit-ID: 4adc8b71cc142f9a7b44b13b99aab38ba897c56f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Jun 2010 07:43:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4adc8b71cc142f9a7b44b13b99aab38ba897c56f
Gitweb:     http://git.kernel.org/tip/4adc8b71cc142f9a7b44b13b99aab38ba897c56f
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 1 Jun 2010 21:04:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Jun 2010 09:38:53 +0200

x86, smpboot: Fix cores per node printing on boot

Percpu initialization happens now after booting the cores on the
machine and this causes them all to be displayed as belonging to
node 0:

Jun  8 05:57:21 kepek kernel: [    0.106999] Booting Node   0,
Processors  #1 #2 #3 #4 #5 #6 #7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20 #21 #22 #23 Ok.

Use early_cpu_to_node() to get the correct node of each core
instead.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <20100601190455.GA14237@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 37462f1..c4f33b2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -686,7 +686,7 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 static void __cpuinit announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
-	int node = cpu_to_node(cpu);
+	int node = early_cpu_to_node(cpu);
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
