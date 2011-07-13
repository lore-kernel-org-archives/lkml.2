Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1GMDHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:07:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:44076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab1GMDHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:07:24 -0400
Date: Wed, 13 Jul 2011 03:06:56 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Message-ID: <tip-25970852280c9d5fb2de899769880d3e97332baa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, nagananda.chumbalkar@hp.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE MSR
Git-Commit-ID: 25970852280c9d5fb2de899769880d3e97332baa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jul 2011 03:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25970852280c9d5fb2de899769880d3e97332baa
Gitweb:     http://git.kernel.org/tip/25970852280c9d5fb2de899769880d3e97332baa
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Tue, 12 Jul 2011 05:59:07 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Jul 2011 14:33:49 -0700

x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE MSR

If there's no special reason to zero-out the "high" 32-bits of the IA32_APIC_BASE
MSR, let's preserve it.

The x2APIC Specification doesn't explicitly state any such requirement. (Sec 2.2
in: http://www.intel.com/Assets/PDF/manual/318148.pdf).

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Link: http://lkml.kernel.org/r/20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..f7b0c7a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1429,7 +1429,7 @@ void enable_x2apic(void)
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
+		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
 	}
 }
 #endif /* CONFIG_X86_X2APIC */
