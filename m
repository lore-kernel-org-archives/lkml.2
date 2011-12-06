Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1LFGbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:31:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab1LFGbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:31:32 -0500
Date: Mon, 5 Dec 2011 22:30:35 -0800
From: tip-bot for Steffen Persvold <sp@numascale.com>
Message-ID: <tip-e4a02b4a951a7adf9d982b11c64686570c29fbe7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sp@numascale.com, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        daniel@numascale-asia.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sp@numascale.com, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        daniel@numascale-asia.com, mingo@elte.hu
In-Reply-To: <1323073238-32686-2-git-send-email-daniel@numascale-asia.com>
References: <1323073238-32686-2-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Fix the !CONFIG_NUMA build of the new CPU ID fixup code support
Git-Commit-ID: e4a02b4a951a7adf9d982b11c64686570c29fbe7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 22:30:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4a02b4a951a7adf9d982b11c64686570c29fbe7
Gitweb:     http://git.kernel.org/tip/e4a02b4a951a7adf9d982b11c64686570c29fbe7
Author:     Steffen Persvold <sp@numascale.com>
AuthorDate: Tue, 6 Dec 2011 01:10:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 07:03:37 +0100

x86: Fix the !CONFIG_NUMA build of the new CPU ID fixup code support

I used "ifdef CONFIG_NUMA" simply because it doesn't make
sense in a non-numa configuration even with SMP enabled.

Besides, the only place where it is called right now is
in kernel/cpu/amd.c:srat_detect_node() within the
"CONFIG_NUMA" protected part.

Signed-off-by: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Link: http://lkml.kernel.org/r/1323073238-32686-2-git-send-email-daniel@numascale-asia.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ad4da45..a70bd5b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1146,7 +1146,9 @@ static void dbg_restore_debug_regs(void)
  */
 void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
+#ifdef CONFIG_NUMA
 	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
+#endif
 }
 
 /*
