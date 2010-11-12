Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0KLOvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:51:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab0KLOvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:51:17 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] x86, hw_nmi: Move backtrace_mask declaration under ARCH_HAS_NMI_WATCHDOG.
Date: Fri, 12 Nov 2010 09:50:54 -0500
Message-Id: <1289573455-3410-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>

backtrace_mask has been used under the code context of
ARCH_HAS_NMI_WATCHDOG. So put it into that context.
We were warned by the following warning:

arch/x86/kernel/apic/hw_nmi.c:21: warning: ‘backtrace_mask’ defined but not used

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index ef4755d..f349647 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -17,15 +17,16 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 
-/* For reliability, we're prepared to waste bits here. */
-static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
-
 u64 hw_nmi_get_sample_period(void)
 {
 	return (u64)(cpu_khz) * 1000 * 60;
 }
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
+
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
-- 
1.7.2.3

