Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2EHE0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:26:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2EHE0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:26:48 -0400
Date: Mon, 7 May 2012 21:26:36 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-3pfty0ml4yp62phbkchichh0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, suresh.b.siddha@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Fix UP boot crash
Git-Commit-ID: 9438ef7f4ea73d5430a330fc206f97826eb9fb16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:26:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9438ef7f4ea73d5430a330fc206f97826eb9fb16
Gitweb:     http://git.kernel.org/tip/9438ef7f4ea73d5430a330fc206f97826eb9fb16
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 May 2012 19:19:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 19:19:56 +0200

x86/apic: Fix UP boot crash

Commit 31b3c9d72340 ("xen/x86: Implement x86_apic_ops") implemented
this:

... without considering that on UP the function pointer might be NULL.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/n/tip-3pfty0ml4yp62phbkchichh0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8526317..7e67c5a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1012,7 +1012,8 @@ void __init setup_arch(char **cmdline_p)
 	init_cpu_to_node();
 
 	init_apic_mappings();
-	x86_io_apic_ops.init();
+	if (x86_io_apic_ops.init)
+		x86_io_apic_ops.init();
 
 	kvm_guest_init();
 
