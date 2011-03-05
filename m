Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab1CEIbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:31:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:42225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1CEIbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:31:35 -0500
Date: Sat, 5 Mar 2011 08:31:09 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, davej@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        davej@redhat.com, mingo@elte.hu
In-Reply-To: <4D7118D30200007800034F79@vpn.id2.novell.com>
References: <4D7118D30200007800034F79@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Really print supported CPUs if PROCESSOR_SELECT=y
Message-ID: <tip-ac23f25355ef53f3d14352fcff3c6817527a9749@git.kernel.org>
Git-Commit-ID: ac23f25355ef53f3d14352fcff3c6817527a9749
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 05 Mar 2011 08:31:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac23f25355ef53f3d14352fcff3c6817527a9749
Gitweb:     http://git.kernel.org/tip/ac23f25355ef53f3d14352fcff3c6817527a9749
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 4 Mar 2011 15:52:35 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 5 Mar 2011 09:29:45 +0100

x86: Really print supported CPUs if PROCESSOR_SELECT=y

I'm sure it was a mere oversight that the CONFIG_ prefixes are
missing.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Dave Jones <davej@redhat.com>
LKML-Reference: <4D7118D30200007800034F79@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1d59834..5d98c46 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -675,7 +675,7 @@ void __init early_cpu_init(void)
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
-#ifdef PROCESSOR_SELECT
+#ifdef CONFIG_PROCESSOR_SELECT
 	printk(KERN_INFO "KERNEL supported cpus:\n");
 #endif
 
@@ -687,7 +687,7 @@ void __init early_cpu_init(void)
 		cpu_devs[count] = cpudev;
 		count++;
 
-#ifdef PROCESSOR_SELECT
+#ifdef CONFIG_PROCESSOR_SELECT
 		{
 			unsigned int j;
 
