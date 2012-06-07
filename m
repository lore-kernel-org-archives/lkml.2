Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab2FGV7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:59:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995Ab2FGV7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:59:49 -0400
Date: Thu, 7 Jun 2012 14:59:38 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-ecd431d95aa04257e977fd6878e4203ce462e7e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, yinghai@kernel.org, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, konrad.wilk@oracle.com, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <1338562358-28182-3-git-send-email-bp@amd64.org>
References: <1338562358-28182-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Fix show_msr MSR accessing function
Git-Commit-ID: ecd431d95aa04257e977fd6878e4203ce462e7e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 07 Jun 2012 14:59:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ecd431d95aa04257e977fd6878e4203ce462e7e9
Gitweb:     http://git.kernel.org/tip/ecd431d95aa04257e977fd6878e4203ce462e7e9
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 1 Jun 2012 16:52:36 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jun 2012 11:41:28 -0700

x86, cpu: Fix show_msr MSR accessing function

There's no real reason why, when showing the MSRs on a CPU at boottime,
we should be using the AMD-specific variant. Simply use the generic safe
one which handles #GPs just fine.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1338562358-28182-3-git-send-email-bp@amd64.org
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b9333b..5bbc082 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -947,7 +947,7 @@ static void __cpuinit __print_cpu_msr(void)
 		index_max = msr_range_array[i].max;
 
 		for (index = index_min; index < index_max; index++) {
-			if (rdmsrl_amd_safe(index, &val))
+			if (rdmsrl_safe(index, &val))
 				continue;
 			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
 		}
