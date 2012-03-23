Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2CWLfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 07:35:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab2CWLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:35:36 -0400
Date: Fri, 23 Mar 2012 04:35:23 -0700
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-0b8b8078cb4db2ebe9a20f2b2eaeb58988be32bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <1332477103-4595-1-git-send-email-yinghai@kernel.org>
References: <1332477103-4595-1-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Fix excessive MSR print out when show_msr is not specified
Git-Commit-ID: 0b8b8078cb4db2ebe9a20f2b2eaeb58988be32bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 04:35:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b8b8078cb4db2ebe9a20f2b2eaeb58988be32bd
Gitweb:     http://git.kernel.org/tip/0b8b8078cb4db2ebe9a20f2b2eaeb58988be32bd
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 22 Mar 2012 21:31:43 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 23 Mar 2012 09:55:00 +0100

x86: Fix excessive MSR print out when show_msr is not specified

Dave found:

| During bootup, I now have 162 messages like this..
| [    0.227346]  MSR0000001b: 00000000fee00900
| [    0.227465]  MSR00000021: 0000000000000001
| [    0.227584]  MSR0000002a: 00000000c1c81400
|
| commit 21c3fcf3e39353d4f21d50e257cc74f3204b1988 looks suspect.
| It claims that it will only print these out if show_msr= is
| passed, but that doesn't seem to be the case.

Fix it by changing to the version that checks the index.

Reported-and-tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1332477103-4595-1-git-send-email-yinghai@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ade9c79..b240323 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -998,7 +998,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else
 		printk(KERN_CONT "\n");
 
-	__print_cpu_msr();
+	print_cpu_msr(c);
 }
 
 void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)
