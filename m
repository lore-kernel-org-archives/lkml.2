Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1LFU0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:26:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38311 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab1LFU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:26:02 -0500
Date: Tue, 6 Dec 2011 12:25:40 -0800
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-565cbc3e934f221369a656b4469a044aa4c3f2a8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <20111206180859.GR1669@redhat.com>
References: <20111206180859.GR1669@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, NMI: NMI-selftest should handle the UP case properly
Git-Commit-ID: 565cbc3e934f221369a656b4469a044aa4c3f2a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:25:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  565cbc3e934f221369a656b4469a044aa4c3f2a8
Gitweb:     http://git.kernel.org/tip/565cbc3e934f221369a656b4469a044aa4c3f2a8
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 6 Dec 2011 13:08:59 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 21:02:39 +0100

x86, NMI: NMI-selftest should handle the UP case properly

If no remote cpus are online, then just quietly skip the remote
IPI test for now.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: andi@firstfloor.org
Cc: torvalds@linux-foundation.org
Cc: peterz@infradead.org
Cc: robert.richter@amd.com
Link: http://lkml.kernel.org/r/20111206180859.GR1669@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/nmi_selftest.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 572adb6..1e42a23 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -90,7 +90,8 @@ static void remote_ipi(void)
 {
 	cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
-	test_nmi_ipi(to_cpumask(nmi_ipi_mask));
+	if (!cpumask_empty(nmi_ipi_mask))
+		test_nmi_ipi(to_cpumask(nmi_ipi_mask));
 }
 
 static void local_ipi(void)
