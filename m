Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1AaRZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:25:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:36757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1AaRZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:25:17 -0500
Date: Mon, 31 Jan 2011 17:24:47 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110131155905.GM7459@htj.dyndns.org>
References: <20110131155905.GM7459@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Rename incorrectly named parameter of numa_cpu_node()
Message-ID: <tip-eff9073790e1286aa12bf1c65814d3e0132b12e1@git.kernel.org>
Git-Commit-ID: eff9073790e1286aa12bf1c65814d3e0132b12e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 17:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eff9073790e1286aa12bf1c65814d3e0132b12e1
Gitweb:     http://git.kernel.org/tip/eff9073790e1286aa12bf1c65814d3e0132b12e1
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Mon, 31 Jan 2011 16:59:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Jan 2011 18:22:25 +0100

x86: Rename incorrectly named parameter of numa_cpu_node()

numa_cpu_node() prototype in numa_32.h has wrongly named
parameter @apicid when it actually takes the CPU number.

Change it to @cpu.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <20110131155905.GM7459@htj.dyndns.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/numa_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index bc66031..c6beed1 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -6,7 +6,7 @@ extern int numa_off;
 extern int pxm_to_nid(int pxm);
 
 #ifdef CONFIG_NUMA
-extern int __cpuinit numa_cpu_node(int apicid);
+extern int __cpuinit numa_cpu_node(int cpu);
 #else	/* CONFIG_NUMA */
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
 #endif	/* CONFIG_NUMA */
